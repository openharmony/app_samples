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

package ohos.samples.distributedclient;

import ohos.samples.distributedclient.interfaces.DeviceListener;
import ohos.samples.distributedclient.utils.LogUtil;
import ohos.samples.distributedserver.RemoteAgentProxy;

import ohos.aafwk.ability.IAbilityConnection;
import ohos.aafwk.content.Intent;
import ohos.aafwk.content.Operation;
import ohos.app.Context;
import ohos.bundle.ElementName;
import ohos.distributedschedule.interwork.DeviceInfo;
import ohos.distributedschedule.interwork.DeviceManager;
import ohos.distributedschedule.interwork.IDeviceStateCallback;
import ohos.rpc.IRemoteObject;
import ohos.rpc.RemoteException;

import java.util.List;

/**
 * Device Plugin class
 */
public class DevicePlugin {
    private static final String TAG = DevicePlugin.class.getSimpleName();

    private static final String REMOTE_BUNDLE_NAME = "ohos.samples.distributedserver";

    private static final String REMOTE_ABILITY_NAME = "ohos.samples.distributedserver.RemoteAbility";

    private static volatile DevicePlugin instance = null;

    private Context context;

    private DeviceListener listener;

    private final IAbilityConnection connection = new IAbilityConnection() {
        @Override
        public void onAbilityConnectDone(ElementName elementName, IRemoteObject iRemoteObject, int resultCode) {
            LogUtil.info(TAG, "onAbilityConnectDone resultCode:" + resultCode);
            RemoteAgentProxy remoteAgentProxy = new RemoteAgentProxy(iRemoteObject);
            try {
                remoteAgentProxy.setRemoteObject();
            } catch (RemoteException e) {
                LogUtil.error(TAG, "onAbilityConnectDone RemoteException");
            }
            listener.updateResult("Connect  " + (resultCode == 0 ? "Success" : "Failed"));
        }

        @Override
        public void onAbilityDisconnectDone(ElementName elementName, int resultCode) {
            LogUtil.info(TAG, "ability disconnect done ");
            listener.updateResult("Disconnect  " + (resultCode == 0 ? "Success" : "Failed"));
        }
    };

    private final IDeviceStateCallback iDeviceStateCallback = new IDeviceStateCallback() {
        @Override
        public void onDeviceOffline(String deviceId, int deviceType) {
            LogUtil.info(TAG, "onDeviceOffline , deviceId: " + deviceId);
            DeviceInfo deviceInfo = DeviceManager.getDeviceInfo(deviceId);
            listener.updateResult("Offline : " + (deviceInfo == null ? "Unknown" : deviceInfo.getDeviceName()));
        }

        @Override
        public void onDeviceOnline(String deviceId, int deviceType) {
            LogUtil.info(TAG, "onDeviceOnline , deviceId: " + deviceId);
            DeviceInfo deviceInfo = DeviceManager.getDeviceInfo(deviceId);
            listener.updateResult("Online : " + (deviceInfo == null ? "Unknown" : deviceInfo.getDeviceName()));
        }
    };

    /**
     * scan remote ability devices list
     *
     * @return current distribute net device list
     */
    public List<DeviceInfo> scanRemoteAbility() {
        return DeviceManager.getDeviceList(DeviceInfo.FLAG_GET_ALL_DEVICE);
    }

    /**
     * connect remote ability
     *
     * @param deviceInfo remoteAbility device info.
     * @param context context.
     */
    public void connectAbility(Context context, DeviceInfo deviceInfo) {
        Intent intent = new Intent();
        Operation operation = new Intent.OperationBuilder().withDeviceId(deviceInfo.getDeviceId())
            .withBundleName(REMOTE_BUNDLE_NAME)
            .withAbilityName(REMOTE_ABILITY_NAME)
            .withFlags(Intent.FLAG_ABILITYSLICE_MULTI_DEVICE)
            .build();
        intent.setOperation(operation);
        intent.setParam("ClientDeviceName", deviceInfo.getDeviceName());
        context.connectAbility(intent, connection);
    }

    /**
     * disconnect remote ability
     */
    public void stopRemoteConnectedAbility() {
        context.disconnectAbility(connection);
        LogUtil.info(TAG, "stopRemoteConnectAbility");
    }

    /**
     * init device listener
     *
     * @param deviceListener device listener
     */
    public void initListener(DeviceListener deviceListener) {
        listener = deviceListener;
    }

    /**
     * register device state listener
     */
    public void registerDeviceStateListener() {
        boolean registerResult = DeviceManager.registerDeviceStateCallback(iDeviceStateCallback);
        listener.updateResult("Register " + (registerResult ? "Success" : "Failed"));
    }

    /**
     * unregister device state listener
     */
    public void unRegisterDeviceStateListener() {
        boolean unRegisterResult = DeviceManager.unregisterDeviceStateCallback(iDeviceStateCallback);
        listener.updateResult("UnRegister " + (unRegisterResult ? "Success" : "Failed"));
    }

    /**
     * Register context
     *
     * @param context context.
     */
    public void register(Context context) {
        this.context = context;
    }

    /**
     * Constructor used to create a DeviceManagerPlugin instance.
     *
     * @return instance of DeviceManagerPlugin
     */
    public static DevicePlugin getInstance() {
        if (instance == null) {
            synchronized (DevicePlugin.class) {
                if (instance == null) {
                    instance = new DevicePlugin();
                }
            }
        }
        return instance;
    }
}
