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
import ohos.agp.components.Text;
import ohos.utils.net.Uri;
import ohos.miscservices.download.DownloadConfig;
import ohos.miscservices.download.DownloadSession;
import ohos.miscservices.download.IDownloadListener;

/**
 * DownloadSample app remove download slice
 */
public class DownloadStateSlice extends AbilitySlice {
    private static final String TAG = DownloadStateSlice.class.getSimpleName();

    private DownloadSession downloadAppSession = null;

    private DownloadSession downloadWebpageSession = null;

    private Text downloadAppStateText;

    private Text downloadWebPageStateText;

    private Text downloadFailedStateText;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        super.setUIContent(ResourceTable.Layout_download_state_slice);
        initComponents();
    }

    private void initComponents() {
        downloadAppStateText = (Text) findComponentById(ResourceTable.Id_download_app_state_text);
        downloadFailedStateText = (Text) findComponentById(ResourceTable.Id_download_failed_state_text);
        downloadWebPageStateText = (Text) findComponentById(ResourceTable.Id_download_webpage_state_text);

        findComponentById(ResourceTable.Id_download_app_button).setClickedListener(
            downloadAppButton -> downloadApp(new DownloadAppListener()));
        findComponentById(ResourceTable.Id_remove_download_app_button).setClickedListener(
            removeDownloadAppButton -> removeDownloadApp());
        findComponentById(ResourceTable.Id_pause_download_app_button).setClickedListener(
            pauseDownloadAppButton -> pauseDownloadApp());
        findComponentById(ResourceTable.Id_resume_download_app_button).setClickedListener(
            resumeDownloadAppButton -> resumeDownloadApp());

        findComponentById(ResourceTable.Id_download_webpage_button).setClickedListener(
            downloadWebPageButton -> downloadWebPage(new DownloadWebPageListener()));
        findComponentById(ResourceTable.Id_remove_download_webpage_button).setClickedListener(
            removeDownloadWebPageButton -> removeDownloadWebPage());
        findComponentById(ResourceTable.Id_pause_download_webpage_button).setClickedListener(
            pauseDownloadWebPageButton -> pauseDownloadWebPage());
        findComponentById(ResourceTable.Id_resume_download_webpage_button).setClickedListener(
            resumeDownloadWebPageButton -> resumeDownloadWebPage());

        findComponentById(ResourceTable.Id_download_failed_button).setClickedListener(
            downloadFailedButton -> downloadFailed(new DownloadFailedListener()));
    }

    private void downloadFailed(DownloadFailedListener listener) {
        LogUtil.info(TAG, "DownloadFailed button clicked ");
        Uri uri = Uri.parse(Const.ERROR_URL);
        DownloadConfig param = new DownloadConfig.Builder(DownloadStateSlice.this, uri).build();
        DownloadSession downloadErrorPageSession = new DownloadSession(DownloadStateSlice.this, param);
        downloadErrorPageSession.start();
        downloadErrorPageSession.addListener(listener);
    }

    private class DownloadFailedListener implements IDownloadListener {
        @Override
        public void onFailed(int errorCode) {
            downloadFailedStateText.setText("OnFailed");
        }
    }

    private void resumeDownloadWebPage() {
        LogUtil.info(TAG, "Resume download button clicked ");
        if (downloadWebpageSession == null) {
            LogUtil.error(TAG, "Resume failed because the download session is null.");
            return;
        }
        downloadWebpageSession.resume();
    }

    private void pauseDownloadWebPage() {
        LogUtil.info(TAG, "Pause download button clicked ");
        if (downloadWebpageSession == null) {
            LogUtil.error(TAG, "Pause failed because the download session is null.");
            return;
        }
        downloadWebpageSession.pause();
    }

    private void removeDownloadWebPage() {
        LogUtil.info(TAG, "Remove download button clicked ");
        if (downloadWebpageSession == null) {
            LogUtil.error(TAG, "Remove failed because the download session is null.");
            return;
        }
        downloadWebpageSession.remove();
    }

    private void downloadWebPage(DownloadWebPageListener listener) {
        LogUtil.info(TAG, "Download button clicked ");
        Uri uri = Uri.parse(Const.WEBPAGE_URL);
        DownloadConfig param = new DownloadConfig.Builder(DownloadStateSlice.this, uri).build();
        downloadWebpageSession = new DownloadSession(DownloadStateSlice.this, param);
        downloadWebpageSession.start();
        downloadWebpageSession.addListener(listener);
    }

    private class DownloadWebPageListener implements IDownloadListener {
        @Override
        public void onRemoved() {
            downloadWebPageStateText.setText("Removed");
        }

        @Override
        public void onCompleted() {
            downloadWebPageStateText.setText("Completed");
        }

        @Override
        public void onFailed(int errorCode) {
            downloadWebPageStateText.setText("OnFailed");
        }

        @Override
        public void onPaused() {
            downloadWebPageStateText.setText("OnPaused");
        }

        @Override
        public void onProgress(long receivedSize, long totalSize) {
            long progress = 0;
            if (totalSize != 0) {
                progress = receivedSize * 100 / totalSize;
            }
            downloadWebPageStateText.setText("Progress: " + progress + "%");
        }
    }

    private void resumeDownloadApp() {
        LogUtil.info(TAG, "Resume download button clicked ");
        if (downloadAppSession == null) {
            LogUtil.error(TAG, "Resume failed because the download session is null.");
            return;
        }
        downloadAppSession.resume();
    }

    private void pauseDownloadApp() {
        LogUtil.info(TAG, "Pause download button clicked ");
        if (downloadAppSession == null) {
            LogUtil.error(TAG, "Pause failed because the download session is null.");
            return;
        }
        downloadAppSession.pause();
    }

    private void removeDownloadApp() {
        LogUtil.info(TAG, "Remove download button clicked ");
        if (downloadAppSession == null) {
            LogUtil.error(TAG, "Remove failed because the download session is null.");
            return;
        }
        downloadAppSession.remove();
    }

    private void downloadApp(IDownloadListener listener) {
        LogUtil.info(TAG, "Download button clicked ");
        Uri uri = Uri.parse(Const.DOWNLOAD_FILE_URL);
        DownloadConfig config = new DownloadConfig.Builder(DownloadStateSlice.this, uri).build();
        downloadAppSession = new DownloadSession(DownloadStateSlice.this, config);
        downloadAppSession.start();
        downloadAppSession.addListener(listener);
    }

    private class DownloadAppListener implements IDownloadListener {
        @Override
        public void onRemoved() {
            downloadAppStateText.setText("Removed");
        }

        @Override
        public void onCompleted() {
            downloadAppStateText.setText("Completed");
        }

        @Override
        public void onFailed(int errorCode) {
            downloadAppStateText.setText("onFailed");
        }

        @Override
        public void onPaused() {
            downloadAppStateText.setText("onPaused");
        }

        @Override
        public void onProgress(long receivedSize, long totalSize) {
            long progress = 0;
            if (totalSize != 0) {
                progress = receivedSize * 100 / totalSize;
            }
            downloadAppStateText.setText("Progress : " + progress + "%");
        }
    }
}