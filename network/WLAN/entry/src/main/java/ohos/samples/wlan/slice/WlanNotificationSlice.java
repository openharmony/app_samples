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

package ohos.samples.wlan.slice;

import ohos.samples.wlan.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.IntentParams;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.agp.window.dialog.ToastDialog;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.event.commonevent.MatchingSkills;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.RemoteException;
import ohos.wifi.WifiEvents;

/**
 * WlanNotificationSlice
 */
public class WlanNotificationSlice extends AbilitySlice {
    private static final String TAG = WlanNotificationSlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private WifiEventSubscriber wifiEventSubscriber;

    private Text logText;

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_wlan_notification_slice_layout);
        initComponent();
        initWifiEventSubscriber();
    }

    private void initComponent() {
        Component registerButton = findComponentById(ResourceTable.Id_register_button);
        Component unRegisterButton = findComponentById(ResourceTable.Id_unregister_button);
        logText = (Text) findComponentById(ResourceTable.Id_log_text);

        registerButton.setClickedListener(this::registerEvent);
        unRegisterButton.setClickedListener(this::unregisterEvent);
    }

    private void initWifiEventSubscriber() {
        MatchingSkills match = new MatchingSkills();
        match.addEvent(WifiEvents.EVENT_ACTIVE_STATE);
        CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(match);
        wifiEventSubscriber = new WifiEventSubscriber(subscribeInfo);
    }

    private void unregisterEvent(Component component) {
        try {
            CommonEventManager.unsubscribeCommonEvent(wifiEventSubscriber);
            showTips("Unregister wifi event");
        } catch (RemoteException | IllegalArgumentException remoteException) {
            HiLog.error(LABEL_LOG, "%{public}s", "unregisterEvent: remoteException|illegalArgumentException");
        }
    }

    private void registerEvent(Component component) {
        try {
            CommonEventManager.subscribeCommonEvent(wifiEventSubscriber);
            showTips("Register wifi event");
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "%{public}s", "registerEvent: -------remoteException");
        }
    }

    class WifiEventSubscriber extends CommonEventSubscriber {
        WifiEventSubscriber(CommonEventSubscribeInfo info) {
            super(info);
        }

        @Override
        public void onReceiveEvent(CommonEventData commonEventData) {
            if (!WifiEvents.EVENT_ACTIVE_STATE.equals(commonEventData.getIntent().getAction())) {
                return;
            }
            IntentParams params = commonEventData.getIntent().getParams();
            if (params == null || params.getParam(WifiEvents.PARAM_ACTIVE_STATE) == null) {
                return;
            }

            int wifiState = (int) params.getParam(WifiEvents.PARAM_ACTIVE_STATE);
            switch (wifiState) {
                case WifiEvents.STATE_ACTIVE: {
                    logText.append("Wifi active" + System.lineSeparator());
                    break;
                }
                case WifiEvents.STATE_INACTIVE: {
                    logText.append("Wifi inactive" + System.lineSeparator());
                    break;
                }
                default:
                    logText.append("Wifi unknown state" + System.lineSeparator());
                    break;
            }
        }
    }

    private void showTips(String message) {
        new ToastDialog(this).setText(message).show();
    }

    @Override
    protected void onStop() {
        super.onStop();
        unregisterEvent(null);
    }
}
