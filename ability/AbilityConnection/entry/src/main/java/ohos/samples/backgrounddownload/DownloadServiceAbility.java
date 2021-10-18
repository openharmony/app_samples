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

package ohos.samples.backgrounddownload;

import static ohos.samples.backgrounddownload.utils.DownloadServiceConnection.getEventHandler;

import ohos.samples.backgrounddownload.utils.Const;
import ohos.samples.backgrounddownload.utils.LogUtil;

import ohos.aafwk.ability.Ability;
import ohos.aafwk.content.Intent;
import ohos.eventhandler.InnerEvent;
import ohos.miscservices.download.DownloadConfig;
import ohos.miscservices.download.DownloadSession;
import ohos.miscservices.download.IDownloadListener;
import ohos.rpc.IRemoteObject;
import ohos.rpc.MessageOption;
import ohos.rpc.MessageParcel;
import ohos.rpc.RemoteObject;
import ohos.utils.net.Uri;

import java.util.ArrayList;
import java.util.List;

/**
 * DownloadServiceAbility
 */
public class DownloadServiceAbility extends Ability implements IDownloadListener {
    private static final String TAG = DownloadServiceAbility.class.getSimpleName();

    private final List<DownloadSession> downloadSessionList = new ArrayList<>();

    private class DownloadRemoteObject extends RemoteObject {
        private DownloadRemoteObject() {
            super("Remote");
        }

        @Override
        public boolean onRemoteRequest(int code, MessageParcel data, MessageParcel reply, MessageOption option) {
            switch (code) {
                case Const.REMOTE_REQUEST_CODE_NEW_TASK: {
                    startDownload(data.readString());
                    reply.writeInt(Const.SEND_REQUEST_SUCCESS);
                    break;
                }
                case Const.REMOTE_REQUEST_CODE_CANCEL_TASK: {
                    cancelDownload();
                    reply.writeInt(Const.SEND_REQUEST_SUCCESS);
                    break;
                }
                default:
                    break;
            }
            return true;
        }
    }

    @Override
    protected void onStart(Intent intent) {
        super.onStart(intent);
    }

    @Override
    protected IRemoteObject onConnect(Intent intent) {
        return new DownloadRemoteObject();
    }

    @Override
    protected void onStop() {
        LogUtil.info(TAG, "service on stop");
        for (DownloadSession downloadSession : downloadSessionList) {
            downloadSession.remove();
            downloadSession.removeListener(this);
        }
        super.onStop();
    }

    private void startDownload(String url) {
        Uri uri = Uri.parse(url);
        DownloadConfig config = new DownloadConfig.Builder(this, uri).setPath(null, "BackgroundDownload")
            .setTitle(url)
            .setDescription("This is a download session")
            .setNetworkRestriction(DownloadConfig.NETWORK_WIFI | DownloadConfig.NETWORK_MOBILE)
            .build();
        DownloadSession downloadSession = new DownloadSession(this, config);
        downloadSession.start();
        downloadSession.addListener(this);
        downloadSessionList.add(downloadSession);
        sendMessage("start download");
        LogUtil.info(TAG, "start download: " + url);
    }

    private void cancelDownload() {
        LogUtil.info(TAG, "cancel download: --");
        int index = downloadSessionList.size() - 1;
        if (index < 0) {
            return;
        }
        downloadSessionList.get(index).remove();
        downloadSessionList.get(index).removeListener(this);
        downloadSessionList.remove(index);
        LogUtil.info(TAG, "cancel download: " + index);
    }

    private void sendMessage(String message) {
        InnerEvent innerEvent = InnerEvent.get(Const.HANDLER_EVENT_ID, Const.HANDLER_EVENT_PARAM, message);
        getEventHandler().sendEvent(innerEvent);
    }

    @Override
    public void onRemoved() {
        LogUtil.info(TAG, "session on removed");
        sendMessage("session removed");
    }

    @Override
    public void onCompleted() {
        LogUtil.info(TAG, "onCompleted");
        sendMessage("session complete");
    }

    @Override
    public void onFailed(int errorCode) {
        LogUtil.info(TAG, "onFailed: " + errorCode);
        sendMessage("session fail");
    }

    @Override
    public void onProgress(long receivedSize, long totalSize) {
        LogUtil.info(TAG, "progress: " + receivedSize + " / " + totalSize);
        sendMessage(receivedSize + " / " + totalSize);
    }
}