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

import java.io.FileInputStream;
import java.io.IOException;

import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.utils.net.Uri;
import ohos.miscservices.download.DownloadConfig;
import ohos.miscservices.download.DownloadSession;

/**
 * DownloadOperationSlice
 */
public class DownloadOperationSlice extends AbilitySlice {
    private static final String TAG = DownloadOperationSlice.class.getSimpleName();

    private DownloadSession downloadSession = null;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_download_operation_slice);
        initComponents();
    }

    private void initComponents() {
        findComponentById(ResourceTable.Id_start_download_btn).setClickedListener(
            startDownloadButton -> startDownloadButton());
        findComponentById(ResourceTable.Id_query_download_btn).setClickedListener(
            queryDownloadButton -> queryDownload());
        findComponentById(ResourceTable.Id_open_file_btn).setClickedListener(openFileButton -> openFile());
        findComponentById(ResourceTable.Id_remove_download_btn).setClickedListener(
            removeDownloadButton -> removeDownload());
    }

    private void removeDownload() {
        LogUtil.info(TAG, "Remove download button clicked ");
        if (downloadSession == null) {
            LogUtil.error(TAG, "Remove failed because the download session is null.");
            return;
        }
        boolean isRemoved = downloadSession.remove();
        if (isRemoved) {
            downloadSession = null;
        }
        LogUtil.info(TAG, "removeDownload, isRemoved = " + isRemoved);
    }

    private synchronized void openFile() {
        if (downloadSession == null) {
            LogUtil.error(TAG, "OpenFile failed because the downloadSession is null.");
            return;
        }
        try (FileInputStream fileInputStream = new FileInputStream(
            downloadSession.openDownloadedFile().readFileDescriptor())) {
            LogUtil.info(TAG, "The first byte is " + fileInputStream.read());
        } catch (IOException exception) {
            LogUtil.error(TAG, "openFile IOException | FileNotFoundException");
        }
    }

    private void queryDownload() {
        LogUtil.info(TAG, "QueryById button clicked ");
        if (downloadSession == null) {
            LogUtil.error(TAG, "Query failed because the download session is null.");
            return;
        }
        DownloadSession.DownloadInfo downloadInfo = downloadSession.query();
        if (downloadInfo != null) {
            LogUtil.info(TAG, "The file name is : " + downloadInfo.getFileName());
        }
    }

    private void startDownloadButton() {
        LogUtil.info(TAG, "Download button clicked ");
        Uri uri = Uri.parse(Const.WEBPAGE_URL);
        DownloadConfig config = new DownloadConfig.Builder(DownloadOperationSlice.this, uri).setPath(null, "Alipay")
            .setTitle("Download Test")
            .setDescription("This is a download test")
            .setNetworkRestriction(DownloadConfig.NETWORK_WIFI | DownloadConfig.NETWORK_MOBILE)
            .build();
        downloadSession = new DownloadSession(DownloadOperationSlice.this, config);
        downloadSession.start();
    }
}
