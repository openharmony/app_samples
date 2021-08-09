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

package ohos.samples.serviceability.slice;

import ohos.samples.serviceability.RemoteAgentProxy;
import ohos.samples.serviceability.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.ability.IAbilityConnection;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Component;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.bundle.ElementName;
import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.distributedschedule.interwork.DeviceManager;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.rpc.IRemoteObject;
import ohos.rpc.RemoteException;

import java.security.SecureRandom;
import java.util.List;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private static final String TAG = MainAbilitySlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int EVENT_ABILITY_CONNECT_DONE = 0x1000001;

    private static final int EVENT_ABILITY_DISCONNECT_DONE = 0x1000002;

    private static final String REMOTE_BUNDLE = "ohos.samples.serviceability";

    private static final String REMOTE_SERVICE = "RemoteAbility";

    private static final String LOCAL_BUNDLE = "ohos.samples.serviceability";

    private static final String NORMAL_SERVICE = "LocalServiceAbility";

    private static final String FOREGROUND_SERVICE = "ForegroundServiceAbility";

    private final EventHandler eventHandler = new EventHandler(EventRunner.current()) {
        @Override
        protected void processEvent(InnerEvent event) {
            switch (event.eventId) {
                case EVENT_ABILITY_CONNECT_DONE:
                    showTips(MainAbilitySlice.this, "Service connect succeeded");
                    break;
                case EVENT_ABILITY_DISCONNECT_DONE:
                    showTips(MainAbilitySlice.this, "Service disconnect succeeded");
                    break;
                default:
                    break;
            }
        }
    };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_slice);

        initComponents();
    }

    private void initComponents() {
        Component startLocalButton = findComponentById(ResourceTable.Id_start_local_button);
        Component stopLocalButton = findComponentById(ResourceTable.Id_stop_local_button);
        Component connectLocalButton = findComponentById(ResourceTable.Id_connect_local_button);
        Component disconnectLocalButton = findComponentById(ResourceTable.Id_disconnect_local_button);
        startLocalButton.setClickedListener(component -> startLocalService(NORMAL_SERVICE));
        stopLocalButton.setClickedListener(component -> stopService(false));
        connectLocalButton.setClickedListener(component -> connectService(false));
        disconnectLocalButton.setClickedListener(component -> disconnectAbility(connection));
        Component keepRunningButton = findComponentById(ResourceTable.Id_keep_run_button);
        keepRunningButton.setClickedListener(component -> startLocalService(FOREGROUND_SERVICE));

        Component startRemoteButton = findComponentById(ResourceTable.Id_start_remote_button);
        Component stopRemoteButton = findComponentById(ResourceTable.Id_stop_remote_button);
        Component connectRemoteButton = findComponentById(ResourceTable.Id_connect_remote_button);
        Component disconnectRemoteButton = findComponentById(ResourceTable.Id_disconnect_remote_button);
        startRemoteButton.setClickedListener(component -> startRemoteService());
        connectRemoteButton.setClickedListener(component -> connectService(true));
        stopRemoteButton.setClickedListener(component -> stopService(true));
        disconnectRemoteButton.setClickedListener(component -> disconnectAbility(connection));
    }

    private void startLocalService(String serviceName) {
        Intent localServiceIntent = getLocalServiceIntent(serviceName);
        startAbility(localServiceIntent);
    }

    private void startRemoteService() {
        Intent remoteServiceIntent = getRemoteServiceIntent();
        startAbility(remoteServiceIntent);
    }

    private Intent getLocalServiceIntent(String serviceName) {
        Operation operation = new Intent.OperationBuilder().withDeviceId("")
            .withBundleName(MainAbilitySlice.LOCAL_BUNDLE)
            .withAbilityName(serviceName)
            .build();
        Intent intent = new Intent();
        intent.setOperation(operation);
        return intent;
    }

    private Intent getRemoteServiceIntent() {
        Operation operation = new Intent.OperationBuilder().withDeviceId(getRemoteDeviceId())
            .withBundleName(MainAbilitySlice.REMOTE_BUNDLE)
            .withAbilityName(MainAbilitySlice.REMOTE_SERVICE)
            .withFlags(Intent.FLAG_ABILITYSLICE_MULTI_DEVICE)
            .build();
        Intent intent = new Intent();
        intent.setOperation(operation);
        return intent;
    }

    private void connectService(boolean isConnectRemote) {
        Intent intent = isConnectRemote
            ? getRemoteServiceIntent()
            : getLocalServiceIntent(NORMAL_SERVICE);
        connectAbility(intent, connection);
    }

    private void stopService(boolean isStopRemote) {
        Intent intent = isStopRemote
            ? getRemoteServiceIntent()
            : getLocalServiceIntent(NORMAL_SERVICE);
        stopAbility(intent);
    }

    private String getRemoteDeviceId() {
        List<DeviceInfo> infoList = DeviceManager.getDeviceList(DeviceInfo.FLAG_GET_ALL_DEVICE);
        if ((infoList == null) || (infoList.size() == 0)) {
            return "";
        }
        int random = new SecureRandom().nextInt(infoList.size());
        return infoList.get(random).getDeviceId();
    }

    private final IAbilityConnection connection = new IAbilityConnection() {
        @Override
        public void onAbilityConnectDone(ElementName elementName, IRemoteObject iRemoteObject, int resultCode) {
            HiLog.info(LABEL_LOG, "%{public}s", "onAbilityConnectDone resultCode : " + resultCode);
            eventHandler.sendEvent(EVENT_ABILITY_CONNECT_DONE);
            RemoteAgentProxy remoteAgentProxy = new RemoteAgentProxy(iRemoteObject);
            try {
                remoteAgentProxy.setRemoteObject("This param from client");
            } catch (RemoteException e) {
                HiLog.error(LABEL_LOG, "%{public}s", "onAbilityConnectDone RemoteException");
            }
        }

        @Override
        public void onAbilityDisconnectDone(ElementName elementName, int resultCode) {
            HiLog.info(LABEL_LOG, "%{public}s", "onAbilityDisconnectDone resultCode : " + resultCode);
            eventHandler.sendEvent(EVENT_ABILITY_DISCONNECT_DONE);
        }
    };

    private void showTips(Context context, String msg) {
        new ToastDialog(context).setText(msg).show();
    }
}
