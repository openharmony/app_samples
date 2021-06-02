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

package ohos.samples.distributedscheduler.slice;

import ohos.samples.distributedscheduler.MainAbility;
import ohos.samples.distributedscheduler.RemoteAgentProxy;
import ohos.samples.distributedscheduler.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.ability.IAbilityConnection;
import ohos.aafwk.ability.IAbilityContinuation;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.IntentParams;
import ohos.aafwk.content.Operation;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
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
public class MainAbilitySlice extends AbilitySlice implements IAbilityContinuation {
    private static final String TAG = MainAbility.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private static final int EVENT_ABILITY_CONNECT_DONE = 0x1000001;

    private static final int EVENT_ABILITY_DISCONNECT_DONE = 0x1000002;

    private static final String REMOTE_BUNDLE = "ohos.samples.distributedscheduler";

    private static final String REMOTE_SERVICE = "RemoteAbility";

    private static final String REMOTE_SERVICE_FA = "PageAbility";

    private Text text;

    private String param;

    private EventHandler eventHandler = new EventHandler(EventRunner.current()) {
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
        super.setUIContent(ohos.samples.distributedscheduler.ResourceTable.Layout_main_ability_slice);

        initComponents();
    }

    private void initComponents() {
        Component startRemoteFAButton = findComponentById(ResourceTable.Id_start_fa_button);
        startRemoteFAButton.setClickedListener(component -> startRemoteFA());

        Component startRemotePAButton = findComponentById(ResourceTable.Id_start_pa_button);
        Component stopRemotePAButton = findComponentById(ResourceTable.Id_stop_pa_button);
        startRemotePAButton.setClickedListener(component -> startRemoteService());
        stopRemotePAButton.setClickedListener(component -> stopService());

        Component connectRemotePAButton = findComponentById(ResourceTable.Id_connect_pa_button);
        Component disconnectRemotePAButton = findComponentById(ResourceTable.Id_disconnect_pa_button);
        Component continueFAButton = findComponentById(ResourceTable.Id_continue_fa_button);
        connectRemotePAButton.setClickedListener(component -> connectService());
        disconnectRemotePAButton.setClickedListener(component -> disconnectAbility(connection));
        continueFAButton.setClickedListener(component -> continueAbility(getRemoteDeviceId()));

        text = (Text) findComponentById(ResourceTable.Id_text);
        text.setText(param);
    }

    private Intent getRemotePageIntent(String bundleName, String serviceName) {
        Operation operation = new Intent.OperationBuilder()
            .withDeviceId(getRemoteDeviceId())
            .withBundleName(bundleName)
            .withAbilityName(serviceName)
            .withFlags(Intent.FLAG_ABILITYSLICE_MULTI_DEVICE)
            .build();
        Intent intent = new Intent();
        intent.setOperation(operation);
        return intent;
    }

    private void startRemoteFA() {
        Intent remotePageIntent = getRemotePageIntent(REMOTE_BUNDLE, REMOTE_SERVICE_FA);
        startAbility(remotePageIntent);
    }

    private Intent getRemoteServiceIntent(String bundleName, String serviceName) {
        Operation operation = new Intent.OperationBuilder()
            .withDeviceId(getRemoteDeviceId())
            .withBundleName(bundleName)
            .withAbilityName(serviceName)
            .withFlags(Intent.FLAG_ABILITYSLICE_MULTI_DEVICE)
            .build();
        Intent intent = new Intent();
        intent.setOperation(operation);
        return intent;
    }

    private void startRemoteService() {
        Intent remoteServiceIntent = getRemoteServiceIntent(REMOTE_BUNDLE, REMOTE_SERVICE);
        startAbility(remoteServiceIntent);
    }

    private void stopService() {
        Intent intent = getRemoteServiceIntent(REMOTE_BUNDLE, REMOTE_SERVICE);
        stopAbility(intent);
    }

    private void connectService() {
        Intent intent = getRemoteServiceIntent(REMOTE_BUNDLE, REMOTE_SERVICE);
        connectAbility(intent, connection);
    }

    private String getRemoteDeviceId() {
        List<DeviceInfo> infoList = DeviceManager.getDeviceList(DeviceInfo.FLAG_GET_ALL_DEVICE);
        if ((infoList == null) || (infoList.size() == 0)) {
            return "";
        }
        int random = new SecureRandom().nextInt(infoList.size());
        return infoList.get(random).getDeviceId();
    }

    private IAbilityConnection connection = new IAbilityConnection() {
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

    @Override
    public boolean onStartContinuation() {
        return true;
    }

    @Override
    public boolean onSaveData(IntentParams intentParams) {
        String exampleData = String.valueOf(text.getText());
        intentParams.setParam("continueParam", exampleData);
        return true;
    }

    @Override
    public boolean onRestoreData(IntentParams intentParams) {
        Object object = intentParams.getParam("continueParam");
        if (object instanceof String) {
            param = (String) object;
            return true;
        }
        return false;
    }

    @Override
    public void onCompleteContinuation(int code) {
        terminate();
    }
}
