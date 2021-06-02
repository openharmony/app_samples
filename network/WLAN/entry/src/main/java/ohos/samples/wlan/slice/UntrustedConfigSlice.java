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
import ohos.agp.components.Component;
import ohos.agp.window.dialog.ToastDialog;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.wifi.WifiDevice;
import ohos.wifi.WifiDeviceConfig;
import ohos.wifi.WifiSecurity;

/**
 * UntrustedConfigSlice
 */
public class UntrustedConfigSlice extends AbilitySlice {
    private static final String TAG = UntrustedConfigSlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private String ssid;

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_untrusted_config_slice_layout);
        initComponents();
    }

    private void initComponents() {
        Component addButton = findComponentById(ResourceTable.Id_add_untrusted_button);
        Component removeButton = findComponentById(ResourceTable.Id_remove_untrusted_button);

        addButton.setClickedListener(this::addUntrustedConfig);
        removeButton.setClickedListener(this::removeUntrustedConfig);
    }

    private void addUntrustedConfig(Component component) {
        setConnectedWifiSsid();
        if (ssid == null) {
            HiLog.warn(LABEL_LOG, "%{public}s", "ssid is null");
            return;
        }

        WifiDevice wifiDevice = WifiDevice.getInstance(this);
        WifiDeviceConfig config = new WifiDeviceConfig();
        config.setSsid(ssid);
        config.setPreSharedKey("123456789");
        config.setHiddenSsid(false);
        config.setSecurityType(WifiSecurity.PSK);
        boolean isSuccess = wifiDevice.addUntrustedConfig(config);

        new ToastDialog(this).setText(isSuccess ? "Add Success" : "Add Fail").show();
    }

    private void removeUntrustedConfig(Component component) {
        setConnectedWifiSsid();
        if (ssid == null) {
            HiLog.warn(LABEL_LOG, "%{public}s", "ssid is null");
            return;
        }

        WifiDevice wifiDevice = WifiDevice.getInstance(this);
        WifiDeviceConfig config = new WifiDeviceConfig();
        config.setSsid(ssid);
        config.setPreSharedKey("123456789");
        config.setHiddenSsid(false);
        config.setSecurityType(WifiSecurity.PSK);
        boolean isSuccess = wifiDevice.removeUntrustedConfig(config);

        new ToastDialog(this).setText(isSuccess ? "Remove Success" : "Remove Fail").show();
    }

    private void setConnectedWifiSsid() {
        WifiDevice wifiDevice = WifiDevice.getInstance(this);
        boolean isConnected = wifiDevice.isConnected();
        if (!isConnected) {
            ssid = null;
            return;
        }
        ssid = wifiDevice.getLinkedInfo().get().getSsid();
    }
}
