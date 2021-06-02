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

package ohos.samples.bluetooth.slice;

import ohos.samples.bluetooth.BluetoothPlugin;
import ohos.samples.bluetooth.ResourceTable;
import ohos.samples.bluetooth.adapter.BluetoothItemProvider;
import ohos.samples.bluetooth.interfaces.BluetoothEventListener;
import ohos.samples.bluetooth.model.BluetoothDevice;
import ohos.samples.bluetooth.utils.Constants;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.AbsButton;
import ohos.agp.components.Button;
import ohos.agp.components.Component;
import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.ListContainer;
import ohos.agp.components.ProgressBar;
import ohos.agp.components.Switch;
import ohos.agp.components.Text;
import ohos.bluetooth.BluetoothHost;
import ohos.samples.bluetooth.utils.LogUtil;

import java.util.List;

/**
 * MainAbilitySlice extends AbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice
    implements Component.ClickedListener, BluetoothEventListener, AbsButton.CheckedStateChangedListener {
    private BluetoothItemProvider availableDevicesItemProvider;

    private BluetoothItemProvider pairedDevicesItemProvider;

    private Text textBluetoothStatus;

    private DirectionalLayout containerLists;

    private Switch bluetoothSwitch;

    private ProgressBar progressBar;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_slice_main);
    }

    @Override
    public void onActive() {
        super.onActive();
        initializeBluetoothHost();
        initComponents();
        subscribeBluetoothEvents();
    }

    private void initializeBluetoothHost() {
        BluetoothPlugin.getInstance(this).initializeBluetooth(this);
    }

    private void subscribeBluetoothEvents() {
        BluetoothPlugin.getInstance(this).subscribeBluetoothEvents();
    }

    private void initComponents() {
        Button btnStartDiscovery = (Button) findComponentById(ResourceTable.Id_btn_start_discovery);
        btnStartDiscovery.setClickedListener(this);

        initListContainer();
        textBluetoothStatus = (Text) findComponentById(ResourceTable.Id_bluetooth_status);

        bluetoothSwitch = (Switch) findComponentById(ResourceTable.Id_bt_switch);
        bluetoothSwitch.setCheckedStateChangedListener(this);
        updateBluetoothStatus(BluetoothPlugin.getInstance(this).getBluetoothStatus());

        containerLists = (DirectionalLayout) findComponentById(ResourceTable.Id_container_lists);
        containerLists.setVisibility(isBluetoothEnabled() ? Component.VISIBLE : Component.HIDE);

        progressBar = (ProgressBar) findComponentById(ResourceTable.Id_progressbar);
    }

    private void initListContainer() {
        ListContainer availableDevicesContainer =
            (ListContainer) findComponentById(ResourceTable.Id_list_available_devices);
        availableDevicesItemProvider = new BluetoothItemProvider(this,
            BluetoothPlugin.getInstance(this).getAvailableDevices());
        availableDevicesContainer.setItemProvider(availableDevicesItemProvider);

        ListContainer pairedDevicesContainer = (ListContainer) findComponentById(ResourceTable.Id_list_paired_devices);
        pairedDevicesItemProvider = new BluetoothItemProvider(this,
            BluetoothPlugin.getInstance(this).getPairedDevices());
        pairedDevicesContainer.setItemProvider(pairedDevicesItemProvider);
    }

    private void updateBluetoothStatus(int bluetoothStatus) {
        bluetoothSwitch.setChecked(isBluetoothEnabled());
        textBluetoothStatus.setText(getBluetoothStatusString(bluetoothStatus));
    }

    private void showProgressBar(boolean isShow) {
        progressBar.setVisibility(Component.HIDE);
        LogUtil.info("MainAbilitySlice", "isShow:" + isShow);
    }

    private boolean isBluetoothEnabled() {
        int status = BluetoothPlugin.getInstance(this).getBluetoothStatus();
        return status == BluetoothHost.STATE_ON;
    }

    private String getBluetoothStatusString(int bluetoothStatus) {
        switch (bluetoothStatus) {
            case BluetoothHost.STATE_OFF:
            case BluetoothHost.STATE_BLE_TURNING_OFF:
                return Constants.BT_DISABLED;

            case BluetoothHost.STATE_TURNING_ON:
                return Constants.BT_TURNING_ON;

            case BluetoothHost.STATE_ON:
                return Constants.BT_ENABLED;

            case BluetoothHost.STATE_TURNING_OFF:
                return Constants.BT_TURNING_OFF;

            default:
                return Constants.BT_UNDEFINED;
        }
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }

    @Override
    public void onClick(Component component) {
        if (component.getId() == ResourceTable.Id_btn_start_discovery) {
            BluetoothPlugin.getInstance(this).startBtScan();
        }
    }

    @Override
    public void updateAvailableDevices(List<BluetoothDevice> list) {
        availableDevicesItemProvider.updateDeviceList(list);
    }

    @Override
    public void updatePairedDevices(List<BluetoothDevice> list) {
        pairedDevicesItemProvider.updateDeviceList(list);
    }

    @Override
    public void notifyBluetoothStatusChanged(int bluetoothStatus) {
        updateBluetoothStatus(bluetoothStatus);
    }

    @Override
    public void notifyDiscoveryState(boolean isStarted) {
        showProgressBar(isStarted);
    }

    @Override
    protected void onStop() {
        BluetoothPlugin.getInstance(this).unSubscribeBluetoothEvents();
        super.onStop();
    }

    @Override
    public void onCheckedChanged(AbsButton absButton, boolean isChecked) {
        if (absButton.getId() == ResourceTable.Id_bt_switch && containerLists != null) {
            if (isChecked) {
                BluetoothPlugin.getInstance(this).enableBluetooth();
                containerLists.setVisibility(Component.VISIBLE);
            } else {
                BluetoothPlugin.getInstance(this).disableBluetooth();
                containerLists.setVisibility(Component.HIDE);
            }
        }
    }
}
