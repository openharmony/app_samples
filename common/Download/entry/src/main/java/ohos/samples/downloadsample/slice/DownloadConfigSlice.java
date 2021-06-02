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

package ohos.samples.downloadsample.slice;

import ohos.samples.downloadsample.ResourceTable;
import ohos.samples.downloadsample.utils.Const;
import ohos.samples.downloadsample.utils.LogUtil;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Switch;
import ohos.agp.components.Text;

import ohos.utils.net.Uri;
import ohos.miscservices.download.DownloadConfig;
import ohos.miscservices.download.DownloadSession;

/**
 * DownloadSample app start download slice
 */
public class DownloadConfigSlice extends AbilitySlice {
    private static final String TAG = DownloadConfigSlice.class.getSimpleName();

    private DownloadSession downloadSession;

    private long currentSessionId = -1L;

    private Switch roamSwitch;

    private Switch networkSwitch;

    private Switch wifiSwitch;

    private Switch mobileSwitch;

    private Text sessionIdText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_download_config_slice);

        initComponents();
    }

    private void initComponents() {
        roamSwitch = (Switch) findComponentById(ResourceTable.Id_roam_switch);
        networkSwitch = (Switch) findComponentById(ResourceTable.Id_metering_network_switch);
        wifiSwitch = (Switch) findComponentById(ResourceTable.Id_wifi_switch);
        mobileSwitch = (Switch) findComponentById(ResourceTable.Id_mobile_switch);

        sessionIdText = (Text) findComponentById(ResourceTable.Id_session_id_text);

        findComponentById(ResourceTable.Id_start_download_button).setClickedListener(
            startDownloadButton -> startDownload());
        findComponentById(ResourceTable.Id_remove_download_button).setClickedListener(
            removeDownloadButton -> removeDownload());
        findComponentById(ResourceTable.Id_attach_download_button).setClickedListener(
            attachDownloadButton -> attachDownload());
    }

    private void attachDownload() {
        if (downloadSession == null || currentSessionId == -1) {
            LogUtil.error(TAG, "Download attach button clicked, but session is null or sessionId is -1");
            return;
        }
        DownloadSession attachDownloadSession = new DownloadSession(DownloadConfigSlice.this,
            Uri.parse(Const.DOWNLOAD_FILE_URL));
        boolean isAttach = attachDownloadSession.attach(currentSessionId);
        DownloadSession.DownloadInfo downloadInfo = downloadSession.query();
        LogUtil.info(TAG, "Download attach button clicked sessionId:" + currentSessionId + " , isAttach: " + isAttach
            + ", the file name is : " + downloadInfo.getFileName());
    }

    private void removeDownload() {
        if (downloadSession == null) {
            LogUtil.error(TAG, "Download remove button clicked, but session is null");
            return;
        }
        boolean isRemove = downloadSession.remove();
        LogUtil.info(TAG, "Remove sessionId:" + currentSessionId + " isRemove:" + isRemove);
        if (isRemove) {
            currentSessionId = -1;
            sessionIdText.setText("SessionId = " + currentSessionId + "");
            downloadSession = null;
        }
        LogUtil.info(TAG, "Download remove button clicked sessionId:" + currentSessionId + " isRemove:" + isRemove);
    }

    private void startDownload() {
        LogUtil.info(TAG, "Download start button clicked sessionId:" + currentSessionId);
        int flag = wifiSwitch.isChecked() ? DownloadConfig.NETWORK_WIFI : -1;
        if (wifiSwitch.isChecked()) {
            flag = mobileSwitch.isChecked() ? (DownloadConfig.NETWORK_MOBILE | flag) : flag;
        } else {
            flag = mobileSwitch.isChecked() ? DownloadConfig.NETWORK_MOBILE : flag;
        }
        LogUtil.info(TAG,
            "START chargingBtn:" + " roamBtn:" + roamSwitch.isChecked() + " netBtn:" + networkSwitch.isChecked()
                + " notifyBtn:" + " idleBtn:" + " wifi/mobile:" + flag);
        DownloadConfig config = new DownloadConfig.Builder(DownloadConfigSlice.this,
            Uri.parse(Const.DOWNLOAD_FILE_URL)).setTitle("Download Test")
            .setDescription("This is a download test.")
            .setNetworkRestriction(flag)
            .enableMetered(networkSwitch.isChecked())
            .enableRoaming(roamSwitch.isChecked())
            .addHttpheader("version", "1.0")
            .addHttpheader("platform", "2.0")
            .build();
        downloadSession = new DownloadSession(DownloadConfigSlice.this, config);
        long startSessionId = downloadSession.start();
        boolean isStart = startSessionId != -1;
        if (isStart) {
            currentSessionId = startSessionId;
            sessionIdText.setText("SessionId = " + startSessionId + "");
        }
        LogUtil.info(TAG, "Start sessionId:" + currentSessionId + " isStart:" + isStart);
    }
}