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

package ohos.samples.autoreplynotificationsample;

import ohos.aafwk.content.Operation;
import ohos.samples.autoreplynotificationsample.utils.Constants;
import ohos.samples.autoreplynotificationsample.utils.LogUtil;

import ohos.aafwk.content.Intent;
import ohos.ace.ability.AceInternalAbility;
import ohos.app.AbilityContext;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.event.commonevent.MatchingSkills;
import ohos.event.intentagent.IntentAgent;
import ohos.event.intentagent.IntentAgentConstant;
import ohos.event.intentagent.IntentAgentHelper;
import ohos.event.intentagent.IntentAgentInfo;
import ohos.event.notification.NotificationActionButton;
import ohos.event.notification.NotificationConstant;
import ohos.event.notification.NotificationHelper;
import ohos.event.notification.NotificationRequest;
import ohos.event.notification.NotificationUserInput;
import ohos.global.resource.RawFileEntry;
import ohos.global.resource.Resource;
import ohos.media.image.ImageSource;
import ohos.media.image.PixelMap;
import ohos.media.image.common.PixelFormat;
import ohos.media.image.common.Rect;
import ohos.media.image.common.Size;
import ohos.rpc.IRemoteObject;
import ohos.rpc.MessageOption;
import ohos.rpc.MessageParcel;
import ohos.rpc.RemoteException;
import ohos.utils.PacMap;
import ohos.utils.zson.ZSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Internal Ability
 */
public class NotificationAbility extends AceInternalAbility {
    private static final String TAG = NotificationAbility.class.getSimpleName();

    private static NotificationAbility instance;

    private static final String BUNDLE_NAME = "ohos.samples.autoreplynotificationsample";

    private static final String RAW_FILE_PATH = "entry/resources/rawfile/";

    private static final String ABILITY_NAME = "NotificationAbility";

    private static final int DEFAULT_TYPE = 0;

    private static final int NOTIFICATION_TYPE_TEXT = 0;

    private static final int NOTIFICATION_TYPE_IMG = 1;

    private AbilityContext context;

    private CommonEventSubscriber subscriber;

    private NotificationAbility() {
        super(BUNDLE_NAME, ABILITY_NAME);
    }

    /**
     * Business execution
     *
     * @param code Request Code.
     * @param data Receives MessageParcel object.
     * @param reply The MessageParcel object is returned.
     * @param option Indicates whether the operation is synchronous or asynchronous.
     * @return If the operation is successful, true is returned. Otherwise, false is returned.
     */
    public boolean onRemoteRequest(int code, MessageParcel data, MessageParcel reply, MessageOption option) {
        String result = data.readString();
        LogUtil.info(TAG, " code = " + code + ", result = " + result);

        switch (code) {
            case Constants.START_NOTIFICATION_TEXT:
                startNotification(reply, NOTIFICATION_TYPE_TEXT);
                break;
            case Constants.START_NOTIFICATION_IMG:
                startNotification(reply, NOTIFICATION_TYPE_IMG);
                break;
            case Constants.CANCEL_NOTIFICATION:
                cancelNotification(reply);
                break;
            case Constants.SUBSCRIBE_MSG:
                subscribeEvent(data, reply, option);
                break;
            case Constants.UN_SUBSCRIBE_MSG:
                unSubscribeEvent(data);
                break;
            default:
                reply.writeString("service not defined");
                return false;
        }
        return true;
    }

    private void cancelNotification(MessageParcel reply) {
        LogUtil.info(TAG, "cancelNotification begin");
        try {
            NotificationHelper.cancelNotification(Constants.NOTIFICATION_ID);
            reply.writeString("cancel notification success");
        } catch (RemoteException e) {
            reply.writeString("RemoteException in cancelNotification");
        }
    }

    private void cancelNotification() {
        LogUtil.info(TAG, "cancelNotification begin");
        try {
            NotificationHelper.cancelNotification(Constants.NOTIFICATION_ID);
        } catch (RemoteException e) {
            LogUtil.warn(TAG, "RemoteException in cancelNotification");
        }
    }

    private void startNotification(MessageParcel reply, int type) {
        cancelNotification();
        NotificationRequest.NotificationNormalContent normalContent
            = new NotificationRequest.NotificationNormalContent();
        normalContent.setTitle(Constants.NOTIFICATION_TITLE);
        normalContent.setText(Constants.NOTIFICATION_TEXT);
        NotificationRequest.NotificationContent notificationContent = new NotificationRequest.NotificationContent(
            normalContent);
        NotificationRequest notificationRequest = new NotificationRequest(Constants.NOTIFICATION_ID);
        notificationRequest.setContent(notificationContent);
        IntentAgent intentAgent = setIntentAgent();
        try {
            if (type == NOTIFICATION_TYPE_TEXT) {
                NotificationActionButton actionButton = new NotificationActionButton.Builder(null,
                    Constants.USE_INPUT_REPLY, intentAgent).addNotificationUserInput(
                    new NotificationUserInput.Builder(Constants.USE_INPUT_KEY).setTag(Constants.USE_INPUT_TAG).build())
                    .setSemanticActionButton(NotificationConstant.SemanticActionButton.ARCHIVE_ACTION_BUTTON)
                    .setAutoCreatedReplies(false)
                    .build();
                notificationRequest.addActionButton(actionButton);
            } else {
                PixelMap pixelMap = getPixMap();
                NotificationActionButton actionButton = new NotificationActionButton.Builder(pixelMap, "",
                    intentAgent).addNotificationUserInput(
                    new NotificationUserInput.Builder(Constants.USE_INPUT_KEY).setTag(Constants.USE_INPUT_TAG).build())
                    .setSemanticActionButton(NotificationConstant.SemanticActionButton.ARCHIVE_ACTION_BUTTON)
                    .setAutoCreatedReplies(false)
                    .setContextDependent(true)
                    .build();
                notificationRequest.addActionButton(actionButton);
            }
            NotificationHelper.publishNotification(notificationRequest);
            reply.writeString("start notification success");
        } catch (RemoteException e) {
            LogUtil.warn(TAG, "Exception in startNotification");
            reply.writeString(Constants.START_NOTIFICATION_FAIL_INFORMATION);
        }
    }

    private PixelMap getPixMap() {
        try {
            RawFileEntry rawFileEntry = context.getResourceManager().getRawFileEntry(RAW_FILE_PATH + "icon.png");
            Resource resource = rawFileEntry.openRawFile();
            ImageSource.SourceOptions srcOpts = new ImageSource.SourceOptions();
            ImageSource imageSource = ImageSource.create(resource, srcOpts);
            ImageSource.DecodingOptions decodingOptions = new ImageSource.DecodingOptions();
            decodingOptions.desiredSize = new Size(0, 0);
            decodingOptions.desiredRegion = new Rect(0, 0, 0, 0);
            decodingOptions.desiredPixelFormat = PixelFormat.ARGB_8888;
            return imageSource.createPixelmap(decodingOptions);
        } catch (IOException e) {
            LogUtil.error(TAG, "getPixMap IOException");
        }
        return null;
    }

    private void subscribeEvent(MessageParcel data, MessageParcel reply, MessageOption option) {
        MatchingSkills matchingSkills = new MatchingSkills();
        matchingSkills.addEvent(Constants.COMMON_EVENT_ACTION);
        IRemoteObject notifier = data.readRemoteObject();
        CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(matchingSkills);
        subscriber = new CommonEventSubscriber(subscribeInfo) {
            @Override
            public void onReceiveEvent(CommonEventData commonEventData) {
                Intent intent = commonEventData.getIntent();
                if (intent == null) {
                    return;
                }
                if (Constants.COMMON_EVENT_ACTION.equals(intent.getAction())) {
                    cancelNotification();
                    PacMap pacMap = NotificationUserInput.getInputsFromIntent(intent);
                    replyMsg(notifier, reply, pacMap);
                    data.reclaim();
                }
            }
        };
        if (option.getFlags() == MessageOption.TF_SYNC) {
            reply.writeString("subscribe common event success");
        }
        try {
            CommonEventManager.subscribeCommonEvent(subscriber);
            reply.writeString(" subscribe common event success");
        } catch (RemoteException e) {
            LogUtil.error(TAG, "RemoteException in subscribeNotificationEvents!");
        }
    }

    private void replyMsg(IRemoteObject notifier, MessageParcel reply, PacMap pacMap) {
        if (pacMap == null) {
            LogUtil.warn(TAG, "onReceiveEvent: pacMap is null!");
            return;
        }
        String result = pacMap.getString(Constants.USE_INPUT_KEY);
        if (result == null) {
            LogUtil.warn(TAG, "onReceiveEvent: result is null!");
            reply.writeString(Constants.CLICK_INFORMATION);
            return;
        }
        MessageParcel notifyData = MessageParcel.obtain();
        boolean writeResult = notifyData.writeString(ZSONObject.toZSONString(result));
        if (!writeResult) {
            LogUtil.info(TAG, "writeResult : " + writeResult);
            notifyData.reclaim();
            return;
        }
        MessageParcel messageParcel = MessageParcel.obtain();
        try {
            notifier.sendRequest(DEFAULT_TYPE, notifyData, messageParcel, new MessageOption());
        } catch (RemoteException exception) {
            LogUtil.info(TAG, "RemoteException : " + exception);
        } finally {
            notifyData.reclaim();
            messageParcel.reclaim();
        }
    }

    private IntentAgent setIntentAgent() {

        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withAction(Constants.COMMON_EVENT_ACTION).build();
        intent.setOperation(operation);
        List<Intent> intentList = new ArrayList<>();
        intentList.add(intent);

        IntentAgentInfo intentAgentInfo = new IntentAgentInfo(Constants.REQUEST_CODE,
            IntentAgentConstant.OperationType.SEND_COMMON_EVENT, IntentAgentConstant.Flags.CANCEL_PRESENT_FLAG,
            intentList, null);
        return IntentAgentHelper.getIntentAgent(context, intentAgentInfo);
    }

    /**
     * Internal ability registration.
     *
     * @param abilityContext context
     */
    public static void register(MainAbility abilityContext) {
        instance = new NotificationAbility();
        instance.onRegister(abilityContext);
    }

    private void onRegister(AbilityContext context) {
        this.context = context;
        this.setInternalAbilityHandler(this::onRemoteRequest);
    }

    /**
     * Internal ability deRegistration.
     */
    public static void deRegister() {
        instance.onDeRegister();
    }

    private void onDeRegister() {
        context = null;
        this.setInternalAbilityHandler(null);
    }

    private void unSubscribeEvent(MessageParcel data) {
        try {
            CommonEventManager.unsubscribeCommonEvent(subscriber);
            data.writeString("Unsubscribe common event success!");
        } catch (RemoteException e) {
            data.writeString("Unsubscribe common event fail!");
            LogUtil.error(TAG, "RemoteException in onUnsubscribe!");
        }
        subscriber = null;
    }
}
