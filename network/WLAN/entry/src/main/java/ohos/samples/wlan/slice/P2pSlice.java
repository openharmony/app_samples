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

import static ohos.event.commonevent.CommonEventSupport.COMMON_EVENT_WIFI_P2P_PEERS_STATE_CHANGED;
import static ohos.wifi.p2p.WifiP2pConfig.GO_BAND_AUTO;

import ohos.samples.wlan.ItemProvider;
import ohos.samples.wlan.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.ListContainer;
import ohos.agp.components.Text;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.event.commonevent.MatchingSkills;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.RemoteException;
import ohos.wifi.WifiEvents;
import ohos.wifi.p2p.WifiP2pCallback;
import ohos.wifi.p2p.WifiP2pConfig;
import ohos.wifi.p2p.WifiP2pController;
import ohos.wifi.p2p.WifiP2pDevice;
import ohos.wifi.p2p.WifiP2pGroup;
import ohos.wifi.p2p.WifiP2pNetworkInfo;

import java.lang.ref.WeakReference;
import java.util.List;

/**
 * P2pSlice
 */
public class P2pSlice extends AbilitySlice {
    private static final String TAG = P2pSlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int EVEN_ID_DISCOVER_END = 0xD000001;

    private static final int EVENT_ID_MESSAGE = 0xD000002;

    private P2pCallBack p2pCallBack;

    private ListContainer listContainer;

    private Text logText;

    private WifiEventSubscriber wifiEventSubscriber;

    private WifiP2pController wifiP2pController;

    private WeakReference<WifiP2pCallback> wifiP2pCallbackWeakReference;

    private final EventHandler handler = new EventHandler(EventRunner.current()) {
        @Override
        @SuppressWarnings("unchecked")
        protected void processEvent(InnerEvent event) {
            switch (event.eventId) {
                case EVEN_ID_DISCOVER_END: {
                    Object object = event.object;
                    if (object instanceof List) {
                        ItemProvider itemProvider = new ItemProvider(getApplicationContext(),
                                (List<WifiP2pDevice>) object);
                        listContainer.setItemProvider(itemProvider);
                    } else {
                        HiLog.error(LABEL_LOG, "unknown object type.");
                    }
                    break;
                }
                case EVENT_ID_MESSAGE: {
                    logText.append(event.object + System.lineSeparator());
                    break;
                }
                default:
                    break;
            }
        }
    };

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_p2p_slice_layout);
        initComponents();
        registerEvent();
        initController();
    }

    private void initController() {
        wifiP2pController = WifiP2pController.getInstance(getApplicationContext());
        p2pCallBack = new P2pCallBack();
        wifiP2pCallbackWeakReference = new WeakReference<>(p2pCallBack);
        try {
            wifiP2pController.init(EventRunner.create(true), wifiP2pCallbackWeakReference.get());
        } catch (RemoteException e) {
            HiLog.info(LABEL_LOG, "wifiP2pController: RemoteException");
            e.printStackTrace();
        }
    }

    private void initComponents() {
        Component discoverDevice = findComponentById(ResourceTable.Id_discover_button);
        Component createGroupButton = findComponentById(ResourceTable.Id_create_group_button);
        logText = (Text) findComponentById(ResourceTable.Id_log_text);
        listContainer = (ListContainer) findComponentById(ResourceTable.Id_listContainer);

        discoverDevice.setClickedListener(component -> discoverDevice(true));
        createGroupButton.setClickedListener(component -> createGroup(true));
        listContainer.setItemClickedListener((listContainer, component, index, l) -> connectDevice(
            (WifiP2pDevice) listContainer.getItemProvider().getItem(index)));

        Component stopDiscoverButton = findComponentById(ResourceTable.Id_stop_discover_button);
        Component removeGroup = findComponentById(ResourceTable.Id_remove_group_button);
        Component disconnectButton = findComponentById(ResourceTable.Id_disconnect_button);

        stopDiscoverButton.setClickedListener(component -> discoverDevice(false));
        removeGroup.setClickedListener(component -> createGroup(false));
        disconnectButton.setClickedListener(component -> disconnect());
    }

    private void disconnect() {
        try {
            wifiP2pController.cancelConnect(wifiP2pCallbackWeakReference.get());
        } catch (RemoteException e) {
            HiLog.error(LABEL_LOG, "disconnect: remoteException");
        }
    }

    private void discoverDevice(boolean isDiscover) {
        HiLog.info(LABEL_LOG, "%{public}s", "discoverDevice");
        try {
            if (isDiscover) {
                wifiP2pController.discoverDevices(wifiP2pCallbackWeakReference.get());
            } else {
                wifiP2pController.stopDeviceDiscovery(wifiP2pCallbackWeakReference.get());
            }
        } catch (RemoteException remoteException) {
            HiLog.error(LABEL_LOG, "discoverDevice: remoteException");
        }
    }

    private void createGroup(boolean isCreateGroup) {
        try {
            WifiP2pConfig wifiP2pConfig = new WifiP2pConfig("DEFAULT_GROUP_NAME", "DEFAULT_PASSPHRASE");
            wifiP2pConfig.setDeviceAddress("02:02:02:02:03:04");
            wifiP2pConfig.setGroupOwnerBand(GO_BAND_AUTO);
            if (isCreateGroup) {
                wifiP2pController.createGroup(wifiP2pConfig, wifiP2pCallbackWeakReference.get());
            } else {
                wifiP2pController.removeGroup(wifiP2pCallbackWeakReference.get());
            }
        } catch (RemoteException remoteException) {
            HiLog.error(LABEL_LOG, "createGroup: remoteException");
        }
    }

    private void requestInfo() {
        HiLog.info(LABEL_LOG, "requestInfo");
        try {
            wifiP2pController.requestP2pInfo(WifiP2pController.GROUP_INFO_REQUEST, p2pCallBack);
            wifiP2pController.requestP2pInfo(WifiP2pController.DEVICE_INFO_REQUEST, p2pCallBack);
            wifiP2pController.requestP2pInfo(WifiP2pController.NETWORK_INFO_REQUEST, p2pCallBack);
            wifiP2pController.requestP2pInfo(WifiP2pController.DEVICE_LIST_REQUEST, p2pCallBack);
        } catch (RemoteException remoteException) {
            HiLog.error(LABEL_LOG, "requestInfo: remoteException");
        }
    }

    private void connectDevice(WifiP2pDevice p2pDevice) {
        WifiP2pConfig wifiP2pConfig = new WifiP2pConfig("DEFAULT_GROUP_NAME", "DEFAULT_PASSPHRASE");
        wifiP2pConfig.setDeviceAddress(p2pDevice.getDeviceAddress());

        try {
            wifiP2pController.connect(wifiP2pConfig, wifiP2pCallbackWeakReference.get());
        } catch (RemoteException remoteException) {
            HiLog.error(LABEL_LOG, "requestInfo: remoteException");
        }
    }

    private class P2pCallBack extends WifiP2pCallback {
        @Override
        public void eventExecFail(int reason) {
            sendHandlerMessage("ExecFail");
        }

        @Override
        public void eventExecOk() {
            sendHandlerMessage("ExecOk");
        }

        @Override
        public void eventP2pGroup(WifiP2pGroup group) {
            sendHandlerMessage("P2pGroup: " + group.getGroupName());
        }

        @Override
        public void eventP2pDevice(WifiP2pDevice p2pDevice) {
            sendHandlerMessage("P2pDevice: " + p2pDevice.getDeviceName());
        }

        @Override
        public void eventP2pDevicesList(List<WifiP2pDevice> devices) {
            InnerEvent innerEvent = InnerEvent.get();
            innerEvent.eventId = EVEN_ID_DISCOVER_END;
            innerEvent.object = devices;
            handler.sendEvent(innerEvent);
            sendHandlerMessage("P2pDevices: " + devices.size());
        }

        @Override
        public void eventP2pNetwork(WifiP2pNetworkInfo networkInfo) {
            sendHandlerMessage("P2pNetwork: " + networkInfo.getConnState().toString());
        }

        @Override
        public void eventP2pControllerDisconnected() {
            sendHandlerMessage("P2pController Disconnected");
        }
    }

    private void sendHandlerMessage(String message) {
        InnerEvent innerEvent = InnerEvent.get();
        innerEvent.eventId = EVENT_ID_MESSAGE;
        innerEvent.object = message;
        handler.sendEvent(innerEvent);
    }

    private void registerEvent() {
        MatchingSkills match = new MatchingSkills();
        match.addEvent(COMMON_EVENT_WIFI_P2P_PEERS_STATE_CHANGED);
        match.addEvent(WifiEvents.EVENT_P2P_DEVICES_CHANGED);
        CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(match);
        wifiEventSubscriber = new WifiEventSubscriber(subscribeInfo);

        try {
            CommonEventManager.subscribeCommonEvent(wifiEventSubscriber);
        } catch (RemoteException remoteException) {
            HiLog.error(LABEL_LOG, "%{public}s", "registerEvent: remoteException");
        }
    }

    private void unregisterEvent() {
        try {
            CommonEventManager.unsubscribeCommonEvent(wifiEventSubscriber);
        } catch (RemoteException | IllegalArgumentException exception) {
            HiLog.error(LABEL_LOG, "%{public}s", "unregisterEvent: remoteException|illegalArgumentException");
        }
    }

    class WifiEventSubscriber extends CommonEventSubscriber {
        public WifiEventSubscriber(CommonEventSubscribeInfo subscribeInfo) {
            super(subscribeInfo);
        }

        @Override
        public void onReceiveEvent(CommonEventData commonEventData) {
            HiLog.info(LABEL_LOG, "%{public}s", commonEventData.getIntent().getAction());
            if (commonEventData.getIntent().getAction().equals(WifiEvents.EVENT_P2P_DEVICES_CHANGED)) {
                requestInfo();
            }
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        unregisterEvent();
    }
}
