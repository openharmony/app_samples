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

package ohos.samples.intentagent.slice;

import ohos.samples.intentagent.IntentAgentAbility;
import ohos.samples.intentagent.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.IntentParams;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Component;
import ohos.event.intentagent.IntentAgent;
import ohos.event.intentagent.IntentAgentConstant;
import ohos.event.intentagent.IntentAgentHelper;
import ohos.event.intentagent.IntentAgentInfo;
import ohos.event.intentagent.TriggerInfo;
import ohos.event.notification.NotificationHelper;
import ohos.event.notification.NotificationRequest;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.RemoteException;

import java.util.ArrayList;
import java.util.List;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final String BUNDLE_NAME = "ohos.samples.intentagent";

    private static final int NOTIFICATION_ID = 0XD0000002;

    private static final int REQUEST_CODE = 1000;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);

        initComponents();
    }

    private void initComponents() {
        Component publishButton = findComponentById(ResourceTable.Id_publish_button);
        Component proactiveButton = findComponentById(ResourceTable.Id_proactive_button);
        publishButton.setClickedListener(this::publishIntentAgentNotification);
        proactiveButton.setClickedListener(this::proactiveActivateIntentAgent);
    }

    private void publishIntentAgentNotification(Component component) {
        NotificationRequest request = new NotificationRequest(NOTIFICATION_ID);
        String title = "IntentAgentNotification";
        String text = "I'm a notification with a intentAgent";
        NotificationRequest.NotificationNormalContent content = new NotificationRequest.NotificationNormalContent();
        content.setTitle(title).setText(text);
        NotificationRequest.NotificationContent notificationContent = new NotificationRequest.NotificationContent(
            content);
        request.setContent(notificationContent);
        request.setIntentAgent(getIntentAgent());
        try {
            NotificationHelper.publishNotification(request);
        } catch (RemoteException ex) {
            HiLog.error(LABEL_LOG, "%{public}s", "publish Intent Agent Notification remoteException");
        }
    }

    private void proactiveActivateIntentAgent(Component component) {
        IntentAgentHelper.triggerIntentAgent(this, getIntentAgent(), null, null,
            new TriggerInfo(null, null, null, REQUEST_CODE));
    }

    private IntentAgent getIntentAgent() {
        Operation operation = new Intent.OperationBuilder().withDeviceId("")
            .withBundleName(BUNDLE_NAME)
            .withAbilityName(IntentAgentAbility.class.getName())
            .build();
        Intent intent = new Intent();
        intent.setOperation(operation);
        List<Intent> intents = new ArrayList<>();
        intents.add(intent);
        IntentAgentInfo agentInfo = new IntentAgentInfo(REQUEST_CODE, IntentAgentConstant.OperationType.START_ABILITY,
            IntentAgentConstant.Flags.UPDATE_PRESENT_FLAG, intents, new IntentParams());
        return IntentAgentHelper.getIntentAgent(this, agentInfo);
    }
}