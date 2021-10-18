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

package ohos.samples.bluetooth;

import static ohos.bluetooth.BluetoothHost.STATE_OFF;
import static ohos.bluetooth.BluetoothHost.STATE_ON;
import static ohos.bluetooth.BluetoothHost.STATE_TURNING_OFF;
import static ohos.bluetooth.BluetoothHost.STATE_TURNING_ON;

import ohos.samples.bluetooth.interfaces.BluetoothEventListener;
import ohos.samples.bluetooth.model.BluetoothDevice;
import ohos.samples.bluetooth.utils.Constants;
import ohos.samples.bluetooth.utils.LogUtil;

import ohos.aafwk.content.Intent;
import ohos.app.AbilityContext;
import ohos.bluetooth.BluetoothHost;
import ohos.bluetooth.BluetoothRemoteDevice;
import ohos.bundle.IBundleManager;
import ohos.event.commonevent.CommonEventData;
import ohos.event.commonevent.CommonEventManager;
import ohos.event.commonevent.CommonEventSubscribeInfo;
import ohos.event.commonevent.CommonEventSubscriber;
import ohos.event.commonevent.MatchingSkills;
import ohos.rpc.RemoteException;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * BluetoothPlugin
 * All the apis are implemented in this class.
 */
public class BluetoothPlugin {
    private static final String TAG = BluetoothPlugin.class.getSimpleName();

    private static volatile BluetoothPlugin sInstance = null;

    private BluetoothHost btHost = null;

    private CommonEventSubscriber commonEventSubscriber = null;

    private final Set<BluetoothRemoteDevice> availableDevices = new LinkedHashSet<>();

    private final AbilityContext mainSliceContext;

    private BluetoothEventListener bluetoothEventListener;

    private BluetoothPlugin(AbilityContext context) {
        mainSliceContext = context;
    }

    /**
     * Obtains the instance of teh BluetoothPlugin class
     *
     * @param context AbilityContext
     * @return Instance of the BluetoothPlugin class
     */
    public static BluetoothPlugin getInstance(AbilityContext context) {
        if (sInstance == null) {
            synchronized (BluetoothPlugin.class) {
                if (sInstance == null) {
                    sInstance = new BluetoothPlugin(context);
                }
            }
        }
        return sInstance;
    }

    /**
     * initiate pairing with bluetooth device of given address.
     *
     * @param pairAddress address of the bluetooth device
     */
    public void startPair(String pairAddress) {
        Optional<BluetoothRemoteDevice> optBluetoothDevice = getSelectedDevice(pairAddress);
        optBluetoothDevice.ifPresent(BluetoothRemoteDevice::startPair);
    }

    private Optional<BluetoothRemoteDevice> getSelectedDevice(String pairAddress) {
        if (pairAddress != null && !pairAddress.isEmpty()) {
            for (BluetoothRemoteDevice device : availableDevices) {
                if (device.getDeviceAddr().equals(pairAddress)) {
                    return Optional.ofNullable(device);
                }
            }
        }
        return Optional.empty();
    }

    /**
     * Obtains the status of the Bluetooth on device.
     *
     * @return status of Bluetooth on device
     */
    public int getBluetoothStatus() {
        return btHost.getBtState();
    }

    /**
     * Enables the Bluetooth on device.
     */
    public void enableBluetooth() {
        if (btHost.getBtState() == STATE_OFF || btHost.getBtState() == STATE_TURNING_OFF) {
            btHost.enableBt();
        }
        bluetoothEventListener.notifyBluetoothStatusChanged(btHost.getBtState());
    }

    /**
     * Disables the Bluetooth on device.
     */
    public void disableBluetooth() {
        if (btHost.getBtState() == STATE_ON || btHost.getBtState() == STATE_TURNING_ON) {
            btHost.disableBt();
        }
        bluetoothEventListener.notifyBluetoothStatusChanged(btHost.getBtState());
    }

    /**
     * Scans the currently available bluetooth devices
     */
    public void startBtScan() {
        int btStatus = btHost.getBtState();
        if (btStatus == STATE_ON) {
            if (hasPermission()) {
                startBtDiscovery();
            } else {
                requestPermission();
            }
        }
    }

    /**
     * Scans the currently available bluetooth devices
     */
    public void startBtDiscovery() {
        if (!btHost.isBtDiscovering()) {
            btHost.startBtDiscovery();
        }
    }

    private boolean hasPermission() {
        return mainSliceContext.verifySelfPermission(Constants.PERM_LOCATION) == IBundleManager.PERMISSION_GRANTED;
    }

    private void requestPermission() {
        if (mainSliceContext.canRequestPermission(Constants.PERM_LOCATION)) {
            mainSliceContext.requestPermissionsFromUser(new String[] {Constants.PERM_LOCATION},
                Constants.USER_REQUEST_LOCATION_SCAN);
        }
    }

    /**
     * Subscribe for Events of Bluetooth using CommonEvents
     */
    public void subscribeBluetoothEvents() {
        MatchingSkills matchingSkills = new MatchingSkills();
        matchingSkills.addEvent(BluetoothHost.EVENT_HOST_STATE_UPDATE);
        matchingSkills.addEvent(BluetoothHost.EVENT_HOST_DISCOVERY_STARTED);
        matchingSkills.addEvent(BluetoothHost.EVENT_HOST_DISCOVERY_FINISHED);
        matchingSkills.addEvent(BluetoothRemoteDevice.EVENT_DEVICE_DISCOVERED);
        matchingSkills.addEvent(BluetoothRemoteDevice.EVENT_DEVICE_PAIR_STATE);
        CommonEventSubscribeInfo subscribeInfo = new CommonEventSubscribeInfo(matchingSkills);
        commonEventSubscriber = new CommonEventSubscriber(subscribeInfo) {
            @Override
            public void onReceiveEvent(CommonEventData commonEventData) {
                Intent intent = commonEventData.getIntent();
                handleIntent(intent);
            }
        };
        try {
            CommonEventManager.subscribeCommonEvent(commonEventSubscriber);
        } catch (RemoteException e) {
            LogUtil.error(TAG, "RemoteException while subscribe bluetooth events.");
        }
    }

    private void handleIntent(Intent intent) {
        if (intent == null) {
            return;
        }

        String action = intent.getAction();
        switch (action) {
            case BluetoothHost.EVENT_HOST_STATE_UPDATE:
                handleHostStateUpdate();
                break;
            case BluetoothHost.EVENT_HOST_DISCOVERY_STARTED:
                handleDeviceDiscoveryState(true);
                break;
            case BluetoothRemoteDevice.EVENT_DEVICE_DISCOVERED:
                handleBluetoothDeviceDiscovered(intent);
                break;
            case BluetoothHost.EVENT_HOST_DISCOVERY_FINISHED:
                handleDeviceDiscoveryState(false);
                break;
            case BluetoothRemoteDevice.EVENT_DEVICE_PAIR_STATE:
                handleDevicePairState(intent);
                break;
            default:
                LogUtil.info(TAG, "Action not handled : " + action);
        }
    }

    private void handleDevicePairState(Intent intent) {
        BluetoothRemoteDevice btRemoteDevice = intent.getSequenceableParam(BluetoothRemoteDevice.REMOTE_DEVICE_PARAM_DEVICE);
        if (btRemoteDevice.getPairState() == BluetoothRemoteDevice.PAIR_STATE_PAIRED) {
            updateAvailableDeviceList(btRemoteDevice);
            updatePairedDeviceList();
        }
    }

    private void handleDeviceDiscoveryState(boolean isStarted) {
        bluetoothEventListener.notifyDiscoveryState(isStarted);
    }

    private void handleHostStateUpdate() {
        int status = getBluetoothStatus();
        bluetoothEventListener.notifyBluetoothStatusChanged(status);
    }

    private void handleBluetoothDeviceDiscovered(Intent intent) {
        BluetoothRemoteDevice btRemoteDevice = intent.getSequenceableParam(
            BluetoothRemoteDevice.REMOTE_DEVICE_PARAM_DEVICE);
        if (btRemoteDevice.getPairState() != BluetoothRemoteDevice.PAIR_STATE_PAIRED) {
            availableDevices.add(btRemoteDevice);
        }
        bluetoothEventListener.updateAvailableDevices(getAvailableDevices());
    }

    private void updateAvailableDeviceList(BluetoothRemoteDevice remoteDevice) {
        availableDevices.removeIf(device -> device.getDeviceAddr().equals(remoteDevice.getDeviceAddr()));
        bluetoothEventListener.updateAvailableDevices(getAvailableDevices());
    }

    private void updatePairedDeviceList() {
        bluetoothEventListener.updatePairedDevices(getPairedDevices());
    }

    public List<BluetoothDevice> getAvailableDevices() {
        return getBluetoothDevices(availableDevices);
    }

    /**
     * Obtains the paired Bluetooth device list.
     *
     * @return paired Bluetooth devices
     */
    public List<BluetoothDevice> getPairedDevices() {
        Set<BluetoothRemoteDevice> pairedDevices = new HashSet<>(btHost.getPairedDevices());
        return getBluetoothDevices(pairedDevices);
    }

    private List<BluetoothDevice> getBluetoothDevices(Set<BluetoothRemoteDevice> remoteDeviceList) {
        List<BluetoothDevice> btDevicesList = new ArrayList<>();
        if (remoteDeviceList != null) {
            btDevicesList = remoteDeviceList.stream().map(BluetoothDevice::new).collect(Collectors.toList());
        }
        return btDevicesList;
    }

    /**
     * Initializes the Bluetooth Host on device.
     *
     * @param eventListener interface to update the Bluwettoth events
     */
    public void initializeBluetooth(BluetoothEventListener eventListener) {
        bluetoothEventListener = eventListener;
        btHost = BluetoothHost.getDefaultHost(mainSliceContext);
    }

    /**
     * UnSubscribe for Bluetooth Events
     */
    public void unSubscribeBluetoothEvents() {
        if (commonEventSubscriber != null) {
            try {
                CommonEventManager.unsubscribeCommonEvent(commonEventSubscriber);
            } catch (RemoteException e) {
                LogUtil.error(TAG, "RemoteException while unsubscribing bluetooth events.");
            }
            commonEventSubscriber = null;
        }
    }
}
