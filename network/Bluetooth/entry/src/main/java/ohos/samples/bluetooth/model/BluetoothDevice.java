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

package ohos.samples.bluetooth.model;

import ohos.bluetooth.BluetoothRemoteDevice;

import java.util.Optional;

/**
 * BluetoothDevice
 */
public class BluetoothDevice {
    /**
     * Bluetooth device name
     */
    private String name;

    private String address;

    private int pairState;

    /**
     * Constructor
     *
     * @param remoteDevice : BluetoothRemoteDevice object
     */
    public BluetoothDevice(BluetoothRemoteDevice remoteDevice) {
        name = getDeviceName(remoteDevice);
        address = remoteDevice.getDeviceAddr();
        pairState = remoteDevice.getPairState();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getPairState() {
        return pairState;
    }

    public void setPairState(int pairState) {
        this.pairState = pairState;
    }

    private String getDeviceName(BluetoothRemoteDevice remoteDevice) {
        Optional<String> optName = remoteDevice.getDeviceName();
        return optName.orElse(remoteDevice.getDeviceAddr());
    }
}
