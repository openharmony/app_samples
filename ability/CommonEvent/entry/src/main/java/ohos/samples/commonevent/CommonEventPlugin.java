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

package ohos.samples.commonevent;

import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventPublishInfo;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.event.commonevent.MatchingSkills;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.RemoteException;

/**
 * CommonEventPlugin
 */
public class CommonEventPlugin {
    private static final String TAG = MainAbility.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private final String event = "com.utils.test";

    private boolean unSubscribe = true;

    private TestCommonEventSubscriber subscriber;

    private NotificationEventListener eventListener;

    private final Context context;

    /**
     * Initialize context
     *
     * @param context context
     */
    public CommonEventPlugin(Context context) {
        this.context = context;
    }

    /**
     * Publish disordered commonEvent
     */
    public void publishDisorderedEvent() {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withAction(event).build();
        intent.setOperation(operation);
        CommonEventData eventData = new CommonEventData(intent);
        try {
            CommonEventManager.publishCommonEvent(eventData);
            showTips(context, "Publish succeeded");
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "publishDisorderedEvent remoteException.");
        }
    }

    /**
     * Publish permission commonEvent
     */
    public void publishPermissionEvent() {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withAction(event).build();
        intent.setOperation(operation);
        CommonEventData eventData = new CommonEventData(intent);
        CommonEventPublishInfo publishInfo = new CommonEventPublishInfo();
        String[] permissions = {"ohos.samples.permission"};
        publishInfo.setSubscriberPermissions(permissions);
        try {
            CommonEventManager.publishCommonEvent(eventData, publishInfo);
            showTips(context, "Publish succeeded");
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "publishPermissionEvent remoteException.");
        }
    }

    /**
     * Publish ordered commonEvent
     */
    public void publishOrderlyEvent() {
        MatchingSkills skills = new MatchingSkills();
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withAction(event).build();
        intent.setOperation(operation);
        CommonEventData eventData = new CommonEventData(intent);
        skills.addEvent(event);
        CommonEventPublishInfo publishInfo = new CommonEventPublishInfo();
        publishInfo.setOrdered(true);
        try {
            CommonEventManager.publishCommonEvent(eventData, publishInfo);
            showTips(context, "Publish succeeded");
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "publishOrderlyEvent remoteException.");
        }
    }

    /**
     * Publish sticky commonEvent
     */
    public void publishStickyEvent() {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withAction(event).build();
        intent.setOperation(operation);
        CommonEventData eventData = new CommonEventData(intent);
        CommonEventPublishInfo publishInfo = new CommonEventPublishInfo();
        publishInfo.setSticky(true);
        try {
            CommonEventManager.publishCommonEvent(eventData, publishInfo);
            showTips(context, "Publish succeeded");
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "publishStickyEvent remoteException.");
        }
    }

    /**
     * Subscribe commonEvent
     */
    public void subscribeEvent() {
        if (unSubscribe) {
            MatchingSkills matchingSkills = new MatchingSkills();
            matchingSkills.addEvent(event);
            CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(matchingSkills);
            subscribeInfo.setPriority(100);
            subscriber = new TestCommonEventSubscriber(subscribeInfo);
            try {
                CommonEventManager.subscribeCommonEvent(subscriber);
                showTips(context, "Subscribe succeeded");
                unSubscribe = false;
            } catch (RemoteException e) {
                HiLog.error(LABEL_LOG, "%{public}s", "subscribeEvent remoteException.");
            }
        }
    }

    /**
     * UnSubscribe commonEvent
     */
    public void unSubscribeEvent() {
        if (subscriber == null) {
            HiLog.info(LABEL_LOG, "%{public}s", "CommonEvent onUnsubscribe commonEventSubscriber is null");
            return;
        }
        try {
            CommonEventManager.unsubscribeCommonEvent(subscriber);
            showTips(context, "UnSubscribe succeeded");
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "unsubscribeEvent remoteException.");
        }
        destroy();
    }

    private void destroy() {
        subscriber = null;
        eventListener = null;
        unSubscribe = true;
    }

    private void showTips(Context context, String msg) {
        new ToastDialog(context).setText(msg).show();
    }

    class TestCommonEventSubscriber extends CommonEventSubscriber {
        TestCommonEventSubscriber(CommonEventSubscribeInfo info) {
            super(info);
        }

        @Override
        public void onReceiveEvent(CommonEventData commonEventData) {
            if (commonEventData == null || commonEventData.getIntent() == null) {
                return;
            }
            String receivedAction = commonEventData.getIntent().getAction();
            HiLog.info(LABEL_LOG, "%{public}s", "onReceiveEvent action:" + receivedAction);
            if (receivedAction.equals(event) && eventListener != null) {
                eventListener.onEventReceive("Receive CommonEvent succeeded,CommonEvent is:" + event);
            }
        }
    }

    /**
     * NotificationEvenListener
     *
     */
    public interface NotificationEventListener {
        void onEventReceive(String result);
    }

    /**
     * set component background selector
     *
     * @param eventListener Notification Even Listener
     */
    public void setEvenListener(NotificationEventListener eventListener) {
        this.eventListener = eventListener;
    }
}
