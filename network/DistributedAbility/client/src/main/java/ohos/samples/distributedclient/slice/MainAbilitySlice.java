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

package ohos.samples.distributedclient.slice;

import ohos.samples.distributedclient.DevicePlugin;
import ohos.samples.distributedclient.ResourceTable;
import ohos.samples.distributedclient.interfaces.DeviceListener;
import ohos.samples.distributedclient.provider.DeviceProvider;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Button;
import ohos.agp.components.Component;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.ListContainer;
import ohos.agp.components.Text;
import ohos.agp.window.dialog.CommonDialog;
import ohos.agp.window.dialog.ToastDialog;
import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;

import java.util.ArrayList;
import java.util.List;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice implements DeviceListener {
    private static final int DIALOG_WIDTH = 900;

    private static final int DIALOG_HEIGHT = 300;

    private static final int DIALOG_CORNER_RADIUS = 30;

    private static final int UPDATE_RESULT_MESSAGE = 0x1000001;

    private DevicePlugin devicePlugin;

    private List<DeviceInfo> deviceInfoList = new ArrayList<>();

    private DeviceProvider deviceProvider;

    private String dialogMessage;

    private final EventHandler handler = new EventHandler(EventRunner.current()) {
        @Override
        protected void processEvent(InnerEvent event) {
            showDialog(dialogMessage);
            scanRemoteAbility(false);
        }
    };

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_layout);

        initDevicePlugin();
        initComponents();
    }

    private void initDevicePlugin() {
        devicePlugin = DevicePlugin.getInstance();
        devicePlugin.register(this);
        devicePlugin.initListener(this);
    }

    private void initComponents() {
        Component scanBtn = findComponentById(ResourceTable.Id_scan_btn);
        Component registerBtn = findComponentById(ResourceTable.Id_register_change_btn);
        Component unRegisterBtn = findComponentById(ResourceTable.Id_unregister_btn);
        Component disconnectBtn = findComponentById(ResourceTable.Id_disconnect_btn);
        registerBtn.setClickedListener(component -> devicePlugin.registerDeviceStateListener());
        unRegisterBtn.setClickedListener(component -> devicePlugin.unRegisterDeviceStateListener());
        disconnectBtn.setClickedListener(component -> devicePlugin.stopRemoteConnectedAbility());
        scanBtn.setClickedListener(component -> scanRemoteAbility(true));
        deviceProvider = new DeviceProvider(this, deviceInfoList, devicePlugin);
        ListContainer listContainer = (ListContainer) findComponentById(ResourceTable.Id_container_list);
        listContainer.setItemProvider(deviceProvider);
    }

    private void scanRemoteAbility(boolean showToast) {
        deviceInfoList = devicePlugin.scanRemoteAbility();
        deviceProvider.updateData(deviceInfoList);
        if (showToast) {
            showTip("scan deviceInfoList size : " + deviceInfoList.size());
        }
    }

    private void showTip(String msg) {
        new ToastDialog(this).setContentText(msg).show();
    }

    @Override
    public void updateResult(String message) {
        dialogMessage = message;
        handler.sendEvent(UPDATE_RESULT_MESSAGE);
    }

    private void showDialog(String message) {
        Component container = LayoutScatter.getInstance(this).parse(ResourceTable.Layout_dialog_layout, null, false);
        Text content = (Text) container.findComponentById(ResourceTable.Id_message);
        content.setText(message);
        CommonDialog commonDialog = new CommonDialog(this);
        commonDialog.setSize(DIALOG_WIDTH, DIALOG_HEIGHT);
        commonDialog.setCornerRadius(DIALOG_CORNER_RADIUS);
        commonDialog.setContentCustomComponent(container);
        commonDialog.show();
        Button btnOk = (Button) container.findComponentById(ResourceTable.Id_btn_ok);
        btnOk.setClickedListener(component -> commonDialog.hide());
    }
}
