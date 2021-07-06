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

package ohos.samples.distributedcommoneventsample;

import ohos.samples.distributedcommoneventsample.utils.LogUtil;

import ohos.aafwk.content.Intent;
import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.distributedschedule.interwork.DeviceManager;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.event.commonevent.MatchingSkills;
import ohos.rpc.RemoteException;

import java.util.List;

/**
 * Plugin class
 */
public class DistributeNotificationPlugin {
    private static final String TAG = "DistributeNotificationPlugin";

    private static final String TEST_ACTION = "usual.event.test2";

    private static final String NOTIFICATION_KEY = "notification_key";

    private static final String NOTIFICATION_CONTENT = "Receive CommonEvent Success";

    private CommonEventSubscriber commonEventSubscriber;

    private DistributeNotificationEventListener eventListener;

    /**
     * publish CommonEvent
     */
    public void publishCommonEvent() {
        LogUtil.info(TAG, "publish CommonEvent begin");
        Intent intent = new Intent();
        intent.setAction(TEST_ACTION);
        intent.setParam(NOTIFICATION_KEY, NOTIFICATION_CONTENT);
        CommonEventData eventData = new CommonEventData(intent);
        try {
            CommonEventManager.publishCommonEvent(eventData);
            LogUtil.info("publishCommonEvent", "the action of Intent is:" + TEST_ACTION);
            if (eventListener != null) {
                eventListener.onEventPublish("CommonEvent Publish Success");
            }
        } catch (RemoteException e) {
            LogUtil.error(TAG, "CommonEvent publish Error!");
        }
    }

    /**
     * CommonEvent Subscribe
     */
    public void subscribeCommonEvent() {
        LogUtil.info(TAG, "CommonEvent onSubscribe begin.");
        MatchingSkills skills = new MatchingSkills();
        skills.addEvent(TEST_ACTION);
        CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(skills);
        List<DeviceInfo> deviceInfos = DeviceManager.getDeviceList(DeviceInfo.FLAG_GET_ALL_DEVICE);
        if (deviceInfos.size() == 0) {
            LogUtil.error(TAG, "No online devices found");
            subscribeInfo.setDeviceId("");
        } else {
            subscribeInfo.setDeviceId(deviceInfos.get(0).getDeviceId());
            LogUtil.info(TAG, "onSubscribe subscribeInfo setDeviceId:" + deviceInfos.get(0).getDeviceId());
        }

        commonEventSubscriber = new CommonEventSubscriber(subscribeInfo) {
            @Override
            public void onReceiveEvent(CommonEventData commonEventData) {
                LogUtil.info(TAG, "CommonEventData onReceiveEvent begin");
                if (commonEventData == null) {
                    LogUtil.info(TAG, "commonEventData is null.");
                    return;
                }
                Intent intent = commonEventData.getIntent();
                if (intent == null) {
                    LogUtil.debug(TAG, "commonEventData getIntent is null.");
                    return;
                }
                String receivedAction = intent.getAction();
                LogUtil.info(TAG, "onReceiveEvent action:" + receivedAction);
                if (receivedAction.equals(TEST_ACTION)) {
                    String notificationContent = intent.getStringParam(NOTIFICATION_KEY);
                    if (eventListener != null) {
                        eventListener.onEventReceive(notificationContent);
                    }
                }
            }
        };

        LogUtil.info(TAG, "CommonEventManager subscribeCommonEvent begin.");
        try {
            CommonEventManager.subscribeCommonEvent(commonEventSubscriber);
            if (eventListener != null) {
                eventListener.onEventSubscribe("CommonEvent Subscribe Success");
            }
        } catch (RemoteException exception) {
            LogUtil.error(TAG, "CommonEvent Subscribe Error!");
        }
    }

    /**
     * CommonEvent Unsubscribe
     */
    public void unsubscribeCommonEvent() {
        LogUtil.info(TAG, "CommonEvent onUnsubscribe begin.");
        if (commonEventSubscriber == null) {
            LogUtil.info(TAG, "CommonEvent onUnsubscribe commonEventSubscriber is null");
            return;
        }
        try {
            CommonEventManager.unsubscribeCommonEvent(commonEventSubscriber);
            if (eventListener != null) {
                eventListener.onEventUnsubscribe("CommonEvent Unsubscribe Success");
            }
        } catch (RemoteException exception) {
            LogUtil.error(TAG, "unsubscribeCommonEvent remoteException!");
        }
        commonEventSubscriber = null;
    }

    /**
     * interface
     *
     */
    public interface DistributeNotificationEventListener {
        void onEventPublish(String result);

        void onEventSubscribe(String result);

        void onEventUnsubscribe(String result);

        void onEventReceive(String result);
    }

    public void setEventListener(DistributeNotificationEventListener eventListener) {
        this.eventListener = eventListener;
    }
}
