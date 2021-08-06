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

package ohos.samples.setting.slice;

import ohos.samples.setting.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.ability.DataAbilityHelper;
import ohos.aafwk.ability.IDataAbilityObserver;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Text;
import ohos.sysappcomponents.settings.SystemSettings;

/**
 * MainAbilitySlice
 */
public class MainAbilitySlice extends AbilitySlice {
    private Text wifiStatusText;

    private Text bluetoothText;

    private Text airplaneModeStatusText;

    private DataAbilityHelper dataAbilityHelper;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_main_ability_slice);
        initDataAbilityHelper();
        initComponents();
    }

    private void initDataAbilityHelper() {
        dataAbilityHelper = DataAbilityHelper.creator(this);
        dataAbilityHelper.registerObserver(SystemSettings.getUri(SystemSettings.Wireless.WIFI_STATUS),
            dataAbilityObserver);
        dataAbilityHelper.registerObserver(SystemSettings.getUri(SystemSettings.General.AIRPLANE_MODE_STATUS),
            dataAbilityObserver);
        dataAbilityHelper.registerObserver(SystemSettings.getUri(SystemSettings.Wireless.BLUETOOTH_STATUS),
            dataAbilityObserver);
    }

    private void initComponents() {
        if (findComponentById(ResourceTable.Id_wifi_status) instanceof Text) {
            wifiStatusText = (Text) findComponentById(ResourceTable.Id_wifi_status);
        }
        setWifiStatus(SystemSettings.getValue(dataAbilityHelper, SystemSettings.Wireless.WIFI_STATUS));
        if (findComponentById(ResourceTable.Id_bluetooth_status) instanceof Text) {
            bluetoothText = (Text) findComponentById(ResourceTable.Id_bluetooth_status);
        }
        setBluetoothStatus(SystemSettings.getValue(dataAbilityHelper, SystemSettings.Wireless.BLUETOOTH_STATUS));
        if (findComponentById(ResourceTable.Id_airplane_mode_status) instanceof Text) {
            airplaneModeStatusText = (Text) findComponentById(ResourceTable.Id_airplane_mode_status);
        }
        setAirplaneModeStatus(SystemSettings.getValue(dataAbilityHelper, SystemSettings.General.AIRPLANE_MODE_STATUS));
    }

    private final IDataAbilityObserver dataAbilityObserver = new IDataAbilityObserver() {
        @Override
        public void onChange() {
            String wifiFormat = SystemSettings.getValue(dataAbilityHelper, SystemSettings.Wireless.WIFI_STATUS);
            String airplaneModeStatus = SystemSettings.getValue(dataAbilityHelper,
                SystemSettings.General.AIRPLANE_MODE_STATUS);
            String bluetoothFormat = SystemSettings.getValue(dataAbilityHelper,
                SystemSettings.Wireless.BLUETOOTH_STATUS);
            setWifiStatus(wifiFormat);
            setAirplaneModeStatus(airplaneModeStatus);
            setBluetoothStatus(bluetoothFormat);
        }
    };

    private void setWifiStatus(String wifiStatus) {
        if ("1".equals(wifiStatus)) {
            wifiStatusText.setText("open");
        } else {
            wifiStatusText.setText("close");
        }
    }

    private void setAirplaneModeStatus(String airplaneModeStatus) {
        if ("1".equals(airplaneModeStatus)) {
            airplaneModeStatusText.setText("open");
        } else {
            airplaneModeStatusText.setText("close");
        }
    }

    private void setBluetoothStatus(String blueToothStatus) {
        if ("1".equals(blueToothStatus)) {
            bluetoothText.setText("open");
        } else {
            bluetoothText.setText("close");
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        unregisterObserver();
    }

    private void unregisterObserver() {
        dataAbilityHelper.unregisterObserver(SystemSettings.getUri(SystemSettings.Wireless.WIFI_STATUS),
            dataAbilityObserver);
        dataAbilityHelper.unregisterObserver(SystemSettings.getUri(SystemSettings.General.AIRPLANE_MODE_STATUS),
            dataAbilityObserver);
        dataAbilityHelper.unregisterObserver(SystemSettings.getUri(SystemSettings.Wireless.BLUETOOTH_STATUS),
            dataAbilityObserver);
    }
}
