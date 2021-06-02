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

import ohos.bundle.IBundleManager;
import ohos.samples.wlan.ResourceTable;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.Text;
import ohos.agp.window.dialog.ToastDialog;
import ohos.hiviewdfx.HiLog;
import ohos.hiviewdfx.HiLogLabel;
import ohos.security.SystemPermission;
import ohos.wifi.IpInfo;
import ohos.wifi.WifiDevice;
import ohos.wifi.WifiLinkedInfo;
import ohos.wifi.WifiScanInfo;
import ohos.wifi.WifiUtils;

import java.util.List;
import java.util.Optional;

/**
 * FeatureSlice
 */
public class FeatureSlice extends AbilitySlice {
    private static final String TAG = FeatureSlice.class.getSimpleName();

    private static final HiLogLabel LABEL_LOG = new HiLogLabel(3, 0xD000F00, TAG);

    private Text logText;

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
        setUIContent(ResourceTable.Layout_feature_slice_layout);
        initComponents();
    }

    private void initComponents() {
        Component scanButton = findComponentById(ResourceTable.Id_scan_button);
        Component getInfoButton = findComponentById(ResourceTable.Id_info_button);
        Component getCountryCodeButton = findComponentById(ResourceTable.Id_countryCode_button);
        Component getSupportedFeatureButton = findComponentById(ResourceTable.Id_support_feature_button);

        scanButton.setClickedListener(this::scanWifi);
        getInfoButton.setClickedListener(this::getConnectedStateInfo);
        getCountryCodeButton.setClickedListener(this::getCountryCode);
        getSupportedFeatureButton.setClickedListener(this::getSupportFeature);

        logText = (Text) findComponentById(ResourceTable.Id_log_text);
        initStateText();
    }

    private void initStateText() {
        WifiDevice wifiDevice = WifiDevice.getInstance(this);
        boolean isWifiActive = wifiDevice.isWifiActive();
        logText.append(isWifiActive ? "State : ON" : "State : OFF" + System.lineSeparator());
    }

    private void scanWifi(Component component) {
        WifiDevice wifiDevice = WifiDevice.getInstance(this);
        boolean isScanSuccess = wifiDevice.scan();
        if (!isScanSuccess) {
            HiLog.info(LABEL_LOG, "%{public}s", "Scan fail");
            return;
        }
        List<WifiScanInfo> scanInfos = wifiDevice.getScanInfoList();

        logText.append(System.lineSeparator());
        for (WifiScanInfo wifiScanInfo : scanInfos) {
            logText.append(wifiScanInfo.getSsid() + System.lineSeparator());
        }
    }

    private void getConnectedStateInfo(Component component) {
        WifiDevice wifiDevice = WifiDevice.getInstance(this);
        boolean isConnected = wifiDevice.isConnected();
        if (!isConnected) {
            new ToastDialog(this).setText("Wifi is not connected").show();
            return;
        }
        Optional<WifiLinkedInfo> linkedInfo = wifiDevice.getLinkedInfo();
        String ssid = linkedInfo.get().getSsid();
        Optional<IpInfo> ipInfo = wifiDevice.getIpInfo();
        int ipAddress = ipInfo.get().getIpAddress();
        int gateway = ipInfo.get().getGateway();

        logText.append(System.lineSeparator());
        logText.append("SSID: " + ssid + System.lineSeparator());
        logText.append("IP: " + ipAddress + System.lineSeparator());
        logText.append("Gateway: " + gateway + System.lineSeparator());
    }

    private void getCountryCode(Component component) {
        if (verifySelfPermission(SystemPermission.LOCATION) != IBundleManager.PERMISSION_GRANTED) {
            HiLog.info(LABEL_LOG, "join getCountryCode method and the location permission is failed");
            return;
        }
        WifiDevice wifiDevice = WifiDevice.getInstance(this);
        String countryCode = wifiDevice.getCountryCode();

        logText.append(System.lineSeparator());
        logText.append("Country Code : " + countryCode + System.lineSeparator());
    }

    private void getSupportFeature(Component component) {
        WifiDevice wifiDevice = WifiDevice.getInstance(this);
        boolean isSupportInfra = wifiDevice.isFeatureSupported(WifiUtils.WIFI_FEATURE_INFRA);
        boolean isSupport5G = wifiDevice.isFeatureSupported(WifiUtils.WIFI_FEATURE_INFRA_5G);
        boolean isSupportPassPoint = wifiDevice.isFeatureSupported(WifiUtils.WIFI_FEATURE_PASSPOINT);
        boolean isSupportP2P = wifiDevice.isFeatureSupported(WifiUtils.WIFI_FEATURE_P2P);
        boolean isSupportHotSpot = wifiDevice.isFeatureSupported(WifiUtils.WIFI_FEATURE_MOBILE_HOTSPOT);
        boolean isSupportAware = wifiDevice.isFeatureSupported(WifiUtils.WIFI_FEATURE_AWARE);
        boolean isSupportApSta = wifiDevice.isFeatureSupported(WifiUtils.WIFI_FEATURE_AP_STA);
        boolean isSupportWpa3Sae = wifiDevice.isFeatureSupported(WifiUtils.WIFI_FEATURE_WPA3_SAE);
        boolean isSupportWpa3Suite = wifiDevice.isFeatureSupported(WifiUtils.WIFI_FEATURE_WPA3_SUITE_B);
        boolean isSupportOwe = wifiDevice.isFeatureSupported(WifiUtils.WIFI_FEATURE_OWE);

        logText.append(System.lineSeparator());
        logText.append(isSupportInfra ? "Infra : Support" : "Infra : Not Support" + System.lineSeparator());
        logText.append(isSupport5G ? "5G : Support" : "5G : Not Support" + System.lineSeparator());
        logText.append(isSupportPassPoint ? "PassPoint : Support" : "PassPoint : Not Support" + System.lineSeparator());
        logText.append(isSupportP2P ? "P2P : Support" : "P2P : Not Support" + System.lineSeparator());
        logText.append(
            isSupportHotSpot ? "Mobile HotPot : Support" : "Mobile HotPot : Not Support" + System.lineSeparator());
        logText.append(isSupportAware ? "Aware : Support" : "Aware : Not Support" + System.lineSeparator());
        logText.append(isSupportApSta ? "AP_STA : Support" : "AP_STA : Not Support" + System.lineSeparator());
        logText.append(isSupportWpa3Sae ? "WPA3_SAE : Support" : "WPA3_SAE : Not Support" + System.lineSeparator());
        logText.append(isSupportWpa3Suite ? "WPA3_Suit : Support" : "WPA3_Suit : Not Support" + System.lineSeparator());
        logText.append(isSupportOwe ? "OWE : Support" : "OWE : Not Support" + System.lineSeparator());
    }
}
