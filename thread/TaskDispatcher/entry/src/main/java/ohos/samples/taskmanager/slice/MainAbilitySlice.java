/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ohos.samples.taskmanager.slice;

import ohos.samples.taskmanager.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.app.dispatcher.Group;
import ohos.app.dispatcher.TaskDispatcher;
import ohos.app.dispatcher.task.Revocable;
import ohos.app.dispatcher.task.TaskPriority;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;

import java.util.ArrayList;
import java.util.concurrent.CountDownLatch;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int TASK_TOTAL = 10;

    private static final int DELAY_TIME = 1000;

    private Text resultText;

    private EventHandler handler = new EventHandler(EventRunner.current());

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);

        initComponents();
    }

    private void initComponents() {
        Component syncDispatchButton = findComponentById(ResourceTable.Id_sync_dispatch_button);
        Component asyncDispatchButton = findComponentById(ResourceTable.Id_async_dispatch_button);
        Component delayDispatchButton = findComponentById(ResourceTable.Id_delay_dispatch_button);
        Component groupDispatchButton = findComponentById(ResourceTable.Id_group_dispatch_button);
        syncDispatchButton.setClickedListener(this::syncTask);
        asyncDispatchButton.setClickedListener(this::asyncTask);
        delayDispatchButton.setClickedListener(this::delayTask);
        groupDispatchButton.setClickedListener(this::groupTask);
        resultText = (Text) findComponentById(ResourceTable.Id_result_text);
        Component revokeTaskButton = findComponentById(ResourceTable.Id_revoke_task_button);
        Component syncBarrierButton = findComponentById(ResourceTable.Id_sync_barrier_button);
        Component asyncBarrierButton = findComponentById(ResourceTable.Id_async_barrier_button);
        Component applyDispatchButton = findComponentById(ResourceTable.Id_apply_dispatch_button);
        revokeTaskButton.setClickedListener(this::postTaskAndRevoke);
        syncBarrierButton.setClickedListener(this::syncBarrier);
        asyncBarrierButton.setClickedListener(this::asyncBarrier);
        applyDispatchButton.setClickedListener(this::applyDispatchTask);
    }

    private void syncTask(Component component) {
        StringBuffer stringBuffer = new StringBuffer();
        TaskDispatcher globalTaskDispatcher = getGlobalTaskDispatcher(TaskPriority.DEFAULT);
        globalTaskDispatcher.syncDispatch(() -> stringBuffer.append("Sync task1 run" + System.lineSeparator()));
        stringBuffer.append("After sync task1" + System.lineSeparator());
        globalTaskDispatcher.syncDispatch(() -> stringBuffer.append("Sync task2 run" + System.lineSeparator()));
        stringBuffer.append("After sync task2" + System.lineSeparator());
        resultText.setText(stringBuffer.toString());
    }

    private void asyncTask(Component component) {
        StringBuffer stringBuffer = new StringBuffer();
        TaskDispatcher globalTaskDispatcher = getGlobalTaskDispatcher(TaskPriority.DEFAULT);
        globalTaskDispatcher.asyncDispatch(() -> {
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                HiLog.error(LABEL_LOG, "%{public}s", "AsyncDispatch InterruptedException");
            }
            stringBuffer.append("Async task1 run" + System.lineSeparator());
            handler.postSyncTask(() -> resultText.setText(stringBuffer.toString()));
        });
        stringBuffer.append("After async task1" + System.lineSeparator());
        globalTaskDispatcher.asyncDispatch(() -> {
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                HiLog.error(LABEL_LOG, "%{public}s", "AsyncDispatch InterruptedException");
            }
            stringBuffer.append("Async task2 run" + System.lineSeparator());
            handler.postSyncTask(() -> resultText.setText(stringBuffer.toString()));
        });
        stringBuffer.append("After async task2" + System.lineSeparator());
        resultText.setText(stringBuffer.toString());
    }

    private void delayTask(Component component) {
        StringBuffer stringBuffer = new StringBuffer();
        TaskDispatcher globalTaskDispatcher = getGlobalTaskDispatcher(TaskPriority.DEFAULT);
        final long callTime = System.currentTimeMillis();
        globalTaskDispatcher.delayDispatch(() -> {
            stringBuffer.append("DelayDispatch task1 run" + System.lineSeparator());
            final long actualDelayMs = System.currentTimeMillis() - callTime;
            stringBuffer.append("ActualDelayTime >= delayTime : " + (actualDelayMs >= DELAY_TIME));
            handler.postSyncTask(() -> resultText.setText(stringBuffer.toString()));
        }, DELAY_TIME);
        stringBuffer.append("After delayDispatch task1" + System.lineSeparator());
        resultText.setText(stringBuffer.toString());
    }

    private void groupTask(Component component) {
        StringBuffer stringBuffer = new StringBuffer();
        TaskDispatcher dispatcher = createParallelTaskDispatcher("", TaskPriority.DEFAULT);
        Group group = dispatcher.createDispatchGroup();
        dispatcher.asyncGroupDispatch(group, () -> {
            stringBuffer.append("GroupTask1 is running" + System.lineSeparator());
            handler.postSyncTask(() -> resultText.setText(stringBuffer.toString()));
        });
        dispatcher.asyncGroupDispatch(group, () -> {
            stringBuffer.append("GroupTask2 is running" + System.lineSeparator());
            handler.postSyncTask(() -> resultText.setText(stringBuffer.toString()));
        });
        dispatcher.groupDispatchNotify(group, () -> stringBuffer.append(
            "This task running after all tasks in the group are completed" + System.lineSeparator()));
        resultText.setText(stringBuffer.toString());
    }

    private void postTaskAndRevoke(Component component) {
        StringBuffer stringBuffer = new StringBuffer();
        TaskDispatcher dispatcher = getUITaskDispatcher();
        Revocable revocable = dispatcher.delayDispatch(() -> {
            stringBuffer.append("Delay dispatch" + System.lineSeparator());
            handler.postSyncTask(() -> resultText.setText(stringBuffer.toString()));
        }, 50);
        boolean revoked = revocable.revoke();
        stringBuffer.append("Revoke result :" + revoked);
        resultText.setText(stringBuffer.toString());
    }

    private void syncBarrier(Component component) {
        StringBuffer stringBuffer = new StringBuffer();
        TaskDispatcher dispatcher = createParallelTaskDispatcher("SyncBarrierDispatcher", TaskPriority.DEFAULT);
        Group group = dispatcher.createDispatchGroup();
        dispatcher.asyncGroupDispatch(group, () -> {
            stringBuffer.append("Task1 is running" + System.lineSeparator());
        });
        dispatcher.asyncGroupDispatch(group, () -> {
            stringBuffer.append("Task2 is running" + System.lineSeparator());
        });
        dispatcher.syncDispatchBarrier(() -> {
            stringBuffer.append("Barrier" + System.lineSeparator());
        });
        stringBuffer.append("After syncDispatchBarrier" + System.lineSeparator());
        resultText.setText(stringBuffer.toString());
    }

    private void asyncBarrier(Component component) {
        StringBuffer stringBuffer = new StringBuffer();
        TaskDispatcher dispatcher = createParallelTaskDispatcher("AsyncBarrierDispatcher", TaskPriority.DEFAULT);
        Group group = dispatcher.createDispatchGroup();
        dispatcher.asyncGroupDispatch(group, () -> {
            stringBuffer.append("Task1 is running" + System.lineSeparator());
            handler.postSyncTask(() -> resultText.setText(stringBuffer.toString()));
        });
        dispatcher.asyncGroupDispatch(group, () -> {
            stringBuffer.append("Task2 is running" + System.lineSeparator());
            handler.postSyncTask(() -> resultText.setText(stringBuffer.toString()));
        });
        dispatcher.asyncDispatchBarrier(() -> {
            stringBuffer.append("Barrier" + System.lineSeparator());
            handler.postSyncTask(() -> resultText.setText(stringBuffer.toString()));
        });
        stringBuffer.append("After asyncDispatchBarrier" + System.lineSeparator());
        resultText.setText(stringBuffer.toString());
    }

    private void applyDispatchTask(Component component) {
        StringBuffer stringBuffer = new StringBuffer();
        final CountDownLatch latch = new CountDownLatch(TASK_TOTAL);
        final ArrayList<Long> indexList = new ArrayList<>(TASK_TOTAL);
        TaskDispatcher globalTaskDispatcher = getGlobalTaskDispatcher(TaskPriority.DEFAULT);
        globalTaskDispatcher.applyDispatch(index -> {
            indexList.add(index);
            latch.countDown();
        }, TASK_TOTAL);
        try {
            latch.await();
        } catch (InterruptedException exception) {
            HiLog.error(LABEL_LOG, "%{public}s", "applyDispatchTask InterruptedException");
        }
        stringBuffer.append("List size matches :" + (indexList.size() == TASK_TOTAL));
        resultText.setText(stringBuffer.toString());
    }
}
