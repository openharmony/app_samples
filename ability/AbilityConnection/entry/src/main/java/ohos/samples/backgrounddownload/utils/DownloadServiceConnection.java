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

package ohos.samples.backgrounddownload.utils;

import ohos.aafwk.ability.IAbilityConnection;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.app.Context;
import ohos.bundle.ElementName;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;
import ohos.eventhandler.InnerEvent;
import ohos.rpc.IRemoteBroker;
import ohos.rpc.IRemoteObject;
import ohos.rpc.MessageOption;
import ohos.rpc.MessageParcel;
import ohos.rpc.RemoteException;

/**
 * DownloadServiceConnection
 */
public class DownloadServiceConnection implements IAbilityConnection {
    private static final String TAG = DownloadServiceConnection.class.getSimpleName();

    private static DownloadStateChangeListener downloadStateChangeListener;

    /**
     * handle message from service to ability slice
     */
    private static final EventHandler handler = new EventHandler(EventRunner.current()) {
        @Override
        protected void processEvent(InnerEvent event) {
            if (event.eventId == Const.HANDLER_EVENT_ID && event.object instanceof String) {
                String message = (String) event.object;
                downloadStateChangeListener.onDownloadStateChange(message);
            }
        }
    };

    private final Context context;

    private DownloadServiceProxy downloadServiceProxy;

    /**
     * DownloadServiceConnection
     *
     * @param abilityContext Context
     */
    public DownloadServiceConnection(Context abilityContext) {
        context = abilityContext;
    }

    @Override
    public void onAbilityConnectDone(ElementName elementName, IRemoteObject iRemoteObject, int resultCode) {
        LogUtil.info(TAG, "on Ability Connect Done");
        sendHandlerMessage("service connect done");
        downloadServiceProxy = new DownloadServiceProxy(iRemoteObject);
    }

    @Override
    public void onAbilityDisconnectDone(ElementName elementName, int resultCode) {
        LogUtil.info(TAG, "on Ability Disconnect Done");
        downloadServiceProxy = null;
        sendHandlerMessage("service disconnect done");
    }

    /**
     * start service
     */
    public void startService() {
        if (downloadServiceProxy != null) {
            sendHandlerMessage("service connected");
            return;
        }
        context.connectAbility(getIntent(), this);
    }

    /**
     * stop service
     */
    public void stopService() {
        if (downloadServiceProxy == null) {
            sendHandlerMessage("no service running");
            return;
        }
        context.disconnectAbility(this);
        context.stopAbility(getIntent());
        downloadServiceProxy = null;
    }

    /**
     * start task
     *
     * @param url String
     */
    public void startTask(String url) {
        if (downloadServiceProxy == null) {
            sendHandlerMessage("no service running");
            return;
        }
        downloadServiceProxy.startTask(url);
    }

    /**
     * cancel task
     */
    public void cancelTask() {
        if (downloadServiceProxy == null) {
            sendHandlerMessage("no service running");
            return;
        }
        downloadServiceProxy.cancelTask();
    }

    private Intent getIntent() {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withDeviceId("")
            .withBundleName("ohos.samples.backgrounddownload")
            .withAbilityName("ohos.samples.backgrounddownload.DownloadServiceAbility")
            .build();
        intent.setOperation(operation);
        return intent;
    }

    /**
     * getEventHandler
     *
     * @return EventHandler
     */
    public static EventHandler getEventHandler() {
        return handler;
    }

    /**
     * setDownLoadStateChangeListener
     *
     * @param stateChangeListener DownLoadStateChangeListener
     */
    public void setDownLoadStateChangeListener(DownloadStateChangeListener stateChangeListener) {
        downloadStateChangeListener = stateChangeListener;
    }

    private class DownloadServiceProxy implements IRemoteBroker {
        private final IRemoteObject remoteObject;

        DownloadServiceProxy(IRemoteObject iRemoteObject) {
            remoteObject = iRemoteObject;
        }

        @Override
        public IRemoteObject asObject() {
            return remoteObject;
        }

        private void startTask(String url) {
            MessageParcel messageParcel = MessageParcel.obtain();
            messageParcel.writeString(url);
            MessageParcel messageParcel1 = MessageParcel.obtain();
            MessageOption messageOption = new MessageOption();
            try {
                remoteObject.sendRequest(Const.REMOTE_REQUEST_CODE_NEW_TASK, messageParcel, messageParcel1,
                    messageOption);
                if (messageParcel1.readInt() == Const.SEND_REQUEST_SUCCESS) {
                    sendHandlerMessage("start task");
                }
            } catch (RemoteException exception) {
                LogUtil.error(TAG, "remote exception");
            } finally {
                messageParcel.reclaim();
                messageParcel1.reclaim();
            }
        }

        private void cancelTask() {
            MessageParcel messageParcel = MessageParcel.obtain();
            MessageParcel messageParcel1 = MessageParcel.obtain();
            MessageOption messageOption = new MessageOption();
            try {
                remoteObject.sendRequest(Const.REMOTE_REQUEST_CODE_CANCEL_TASK, messageParcel, messageParcel1,
                    messageOption);
                if (messageParcel1.readInt() == Const.SEND_REQUEST_SUCCESS) {
                    sendHandlerMessage("cancel task");
                }
            } catch (RemoteException exception) {
                LogUtil.error(TAG, "remote exception");
            } finally {
                messageParcel.reclaim();
                messageParcel1.reclaim();
            }
        }
    }

    /**
     * interface for DownLoad State Change
     */
    public interface DownloadStateChangeListener {
        void onDownloadStateChange(String message);
    }

    private void sendHandlerMessage(String message) {
        InnerEvent innerEvent = InnerEvent.get(Const.HANDLER_EVENT_ID, Const.HANDLER_EVENT_PARAM, message);
        handler.sendEvent(innerEvent);
    }
}
