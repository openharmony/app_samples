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

package ohos.samples.notification.slice;

import ohos.aafwk.content.Operation;
import ohos.agp.components.Text;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.samples.notification.MainAbility;
import ohos.samples.notification.ResourceTable;
import ohos.samples.notification.utils.Const;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.IntentParams;
import ohos.agp.components.Component;
import ohos.bundle.ElementName;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.MatchingSkills;
import ohos.event.intentagent.IntentAgent;
import ohos.event.intentagent.IntentAgentConstant;
import ohos.event.intentagent.IntentAgentHelper;
import ohos.event.intentagent.IntentAgentInfo;
import ohos.event.notification.NotificationActionButton;
import ohos.event.notification.NotificationConstant;
import ohos.event.notification.NotificationHelper;
import ohos.event.notification.NotificationRequest;
import ohos.event.notification.NotificationSlot;
import ohos.event.notification.NotificationUserInput;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.RemoteException;
import ohos.utils.PacMap;
import ohos.utils.net.Uri;

import java.util.ArrayList;
import java.util.List;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbility.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private NotificationEventSubscriber eventSubscriber;

    private int notificationId;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        subscribeCommonEvent();
        defineNotificationSlot();
        initComponents();
    }

    private void initComponents() {
        Component publishButton = findComponentById(ResourceTable.Id_publish_button);
        Component publishTextButton = findComponentById(ResourceTable.Id_publish_text_button);
        publishButton.setClickedListener(
            component -> publishNotification());
        publishTextButton.setClickedListener(
            component -> publishNotificationWithAction());
        Component cancelButton = findComponentById(ResourceTable.Id_cancel_button);
        Component cancelAllButton = findComponentById(ResourceTable.Id_cancel_all_button);
        cancelButton.setClickedListener(component -> cancel());
        cancelAllButton.setClickedListener(component -> cancelAll());
    }

    private void defineNotificationSlot() {
        NotificationSlot notificationSlot = new NotificationSlot(Const.SLOT_ID, Const.SLOT_NAME, NotificationSlot.LEVEL_HIGH);
        notificationSlot.setEnableVibration(true);
        notificationSlot.setLockscreenVisibleness(NotificationRequest.VISIBLENESS_TYPE_PUBLIC);
        Uri uri = Uri.parse(Const.SOUND_URI);
        notificationSlot.setSound(uri);
        try {
            NotificationHelper.addNotificationSlot(notificationSlot);
        } catch (RemoteException ex) {
            HiLog.error(LABEL_LOG, "%{public}s", "defineNotificationSlot remoteException.");
        }
    }

    private void publishNotification() {
        notificationId = 0x1000001;
        NotificationRequest request = new NotificationRequest(notificationId).setSlotId(Const.SLOT_ID)
            .setTapDismissed(true);
        request.setContent(createNotificationContent(Const.NOTIFICATION_TITLE, Const.NOTIFICATION_CONTENT));
        IntentAgent intentAgent = createIntentAgent(MainAbility.class.getName(),
            IntentAgentConstant.OperationType.START_ABILITY);
        request.setIntentAgent(intentAgent);
        try {
            NotificationHelper.publishNotification(request);
        } catch (RemoteException ex) {
            HiLog.error(LABEL_LOG, "%{public}s", "publishNotification remoteException.");
        }
    }

    private void publishNotificationWithAction() {
        notificationId = 0x1000002;
        NotificationRequest request = new NotificationRequest(notificationId).setSlotId(Const.SLOT_ID)
            .setTapDismissed(true);
        request.setContent(createNotificationContent(Const.NOTIFICATION_TITLE2, Const.NOTIFICATION_CONTENT2));
        IntentAgent intentAgent = createIntentAgent(MainAbility.class.getName(),
            IntentAgentConstant.OperationType.SEND_COMMON_EVENT);
        request.setIntentAgent(intentAgent);
        NotificationUserInput input = new NotificationUserInput.Builder(Const.NOTIFICATION_INPUT_KEY).setTag(
            Const.NOTIFICATION_OPER_TITLE).build();
        NotificationActionButton actionButton = new NotificationActionButton.Builder(null,
            Const.NOTIFICATION_OPER_TITLE, intentAgent).addNotificationUserInput(input)
            .setSemanticActionButton(NotificationConstant.SemanticActionButton.ARCHIVE_ACTION_BUTTON)
            .setAutoCreatedReplies(false)
            .build();
        request.addActionButton(actionButton);
        try {
            NotificationHelper.publishNotification(request);
        } catch (RemoteException ex) {
            HiLog.error(LABEL_LOG, "%{public}s", "publishNotificationWithAction remoteException.");
        }
    }

    private NotificationRequest.NotificationContent createNotificationContent(String title, String text) {
        NotificationRequest.NotificationNormalContent content
            = new NotificationRequest.NotificationNormalContent().setTitle(title).setText(text);
        return new NotificationRequest.NotificationContent(content);
    }

    private IntentAgent createIntentAgent(String ability, IntentAgentConstant.OperationType operationType) {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withAction(Const.NOTIFICATION_ACTION).build();
        intent.setOperation(operation);
        if (operationType != IntentAgentConstant.OperationType.SEND_COMMON_EVENT) {
            intent.setElement(new ElementName("", Const.BUNDLE_NAME, ability));
        }
        List<Intent> intents = new ArrayList<>();
        intents.add(intent);
        IntentAgentInfo agentInfo = new IntentAgentInfo(Const.REQUEST_CODE, operationType,
            IntentAgentConstant.Flags.UPDATE_PRESENT_FLAG, intents, new IntentParams());
        return IntentAgentHelper.getIntentAgent(getContext(), agentInfo);
    }

    private void cancel() {
        try {
            NotificationHelper.cancelNotification(notificationId);
        } catch (RemoteException ex) {
            HiLog.error(LABEL_LOG, "%{public}s", "cancel remoteException.");
        }
    }

    private void cancelAll() {
        try {
            NotificationHelper.cancelAllNotifications();
        } catch (RemoteException ex) {
            HiLog.error(LABEL_LOG, "%{public}s", "cancelAll remoteException.");
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        unSubscribeCommonEvent();
    }

    private void subscribeCommonEvent() {
        MatchingSkills skills = new MatchingSkills();
        skills.addEvent(Const.NOTIFICATION_ACTION);
        CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(skills);
        subscribeInfo.setThreadMode(CommonEventSubscribeInfo.ThreadMode.HANDLER);
        eventSubscriber = new NotificationEventSubscriber(subscribeInfo, this);
        try {
            CommonEventManager.subscribeCommonEvent(eventSubscriber);
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "subscribeCommonEvent remoteException.");
        }
    }

    private void unSubscribeCommonEvent() {
        try {
            CommonEventManager.unsubscribeCommonEvent(eventSubscriber);
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "unSubscribeCommonEvent remoteException.");
        }
    }

    static class NotificationEventSubscriber extends CommonEventSubscriber {
        private final AbilitySlice slice;

        /**
         * Constructor
         *
         * @param subscribeInfo subscribe information
         * @param slice slice who own the subscriber
         */
        public NotificationEventSubscriber(CommonEventSubscribeInfo subscribeInfo, AbilitySlice slice) {
            super(subscribeInfo);
            this.slice = slice;
        }

        @Override
        public void onReceiveEvent(CommonEventData commonEventData) {
            Intent intent = commonEventData.getIntent();
            if (intent == null) {
                return;
            }
            if (Const.NOTIFICATION_ACTION.equals(intent.getAction())) {
                PacMap pacMap = NotificationUserInput.getInputsFromIntent(intent);
                if (pacMap == null) {
                    return;
                }
                String inputText = pacMap.getString(Const.NOTIFICATION_INPUT_KEY);
                slice.getUITaskDispatcher().asyncDispatch(() -> {
                    Text replyText = (Text) slice.findComponentById(ResourceTable.Id_notify2_reply);
                    replyText.setText(inputText);
                });
            }
        }
    }

}
