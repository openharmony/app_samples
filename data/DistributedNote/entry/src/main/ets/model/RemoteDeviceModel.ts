/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import deviceManager from '@ohos.distributedHardware.deviceManager'
import { BUNDLE } from '../model/Const'
import Logger from '../model/Logger'

let SUBSCRIBE_ID: number = 100
const TAG: string = 'RemoteDeviceModel'

class RemoteDeviceModel {
    public devices: Array<deviceManager.DeviceInfo> = []
    public discoverDevices: Array<deviceManager.DeviceInfo> = []
    private stateChangeCallback?: () => void
    private authCallback?: (device: deviceManager.DeviceInfo) => void
    private deviceManager?: deviceManager.DeviceManager

    registerDeviceListCallback(stateChangeCallback: () => void) {
        if (typeof (this.deviceManager) !== 'undefined') {
            this.registerDeviceListCallbackImplement(stateChangeCallback)
            return
        }
        Logger.info(TAG, 'deviceManager.createDeviceManager begin')
        deviceManager.createDeviceManager(BUNDLE, (error, value) => {
            if (error) {
                Logger.error(TAG, 'createDeviceManager failed.')
                return
            }
            this.deviceManager = value
            this.registerDeviceListCallbackImplement(stateChangeCallback)
            Logger.info(TAG, `createDeviceManager callback returned,value=${value}`)
        })
        Logger.info(TAG, 'deviceManager.createDeviceManager end')
    }

    onDeviceStateChangeActionOnline(device) {
        this.devices[this.devices.length] = device
        Logger.info(TAG, `online, device list=${JSON.stringify(this.devices)}`)
        if (this.authCallback !== null) {
            this.authCallback(device)
            this.authCallback = null
        }
    }

    onDeviceStateChangeActionReady(device) {
        if (this.devices.length <= 0) {
            this.stateChangeCallback()
            return
        }

        let list = this.devices.filter((value) => {
            return value !== device.deviceId
        })

        this.devices = list
        Logger.info(TAG, `ready, device list=${JSON.stringify(this.devices)}`)
        this.stateChangeCallback()
    }

    getLocalDevice() {
        Logger.info(TAG, `getLocalDevice`)
        let deviceInfo: deviceManager.DeviceInfo = this.deviceManager.getLocalDeviceInfoSync()
        Logger.info(TAG, `local deviceInfo=${JSON.stringify(deviceInfo)}`)
        return deviceInfo.deviceId
    }

    registerDeviceListCallbackImplement(stateChangeCallback: () => void) {
        Logger.info(TAG, 'registerDeviceListCallback')
        this.stateChangeCallback = stateChangeCallback
        if (this.deviceManager === undefined) {
            Logger.error(TAG, 'deviceManager has not initialized')
            this.stateChangeCallback()
            return
        }
        Logger.info(TAG, 'getTrustedDeviceListSync begin')
        let list = this.deviceManager.getTrustedDeviceListSync()
        Logger.info(TAG, `getTrustedDeviceListSync end, devices=${JSON.stringify(list)}`)
        if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
            this.devices = list
        }
        this.stateChangeCallback()
        Logger.info(TAG, 'callback finished')
        this.deviceManager.on('deviceStateChange', (data) => {
            if (data === null) {
                return
            }
            Logger.info(TAG, `deviceStateChange data = ${JSON.stringify(data)}`)
            switch (data.action) {
                case deviceManager.DeviceStateChangeAction.ONLINE:
                    this.onDeviceStateChangeActionOnline(data.device)
                    break
                case deviceManager.DeviceStateChangeAction.READY:
                    this.onDeviceStateChangeActionReady(data.device)
                    break
                default:
                    break
            }
        })
        this.deviceManager.on('deviceFound', (data) => {
            if (data === null) {
                return
            }
            Logger.info(TAG, `deviceFound data=${JSON.stringify(data)}`)
            this.onDeviceFound(data)
        })
        this.deviceManager.on('discoverFail', (data) => {
            Logger.info(TAG, `discoverFail data=${JSON.stringify(data)}`)
        })
        this.deviceManager.on('serviceDie', () => {
            Logger.info(TAG, 'serviceDie')
        })
        this.startDeviceDiscovery()
    }

    onDeviceFound(data) {
        for (let i = 0;i < this.discoverDevices.length; i++) {
            if (this.discoverDevices[i].deviceId === data.device.deviceId) {
                Logger.info(TAG, 'device founded ignored')
                return
            }
        }
        this.discoverDevices[this.discoverDevices.length] = data.device
        Logger.info(TAG, `deviceFound self.discoverDevices=${this.discoverDevices}`)
        this.stateChangeCallback()
    }

    startDeviceDiscovery() {
        SUBSCRIBE_ID = Math.floor(65536 * Math.random())
        var info = {
            subscribeId: SUBSCRIBE_ID,
            mode: 0xAA,
            medium: 2,
            freq: 2,
            isSameAccount: false,
            isWakeRemote: true,
            capability: 0
        }
        Logger.info(TAG, `startDeviceDiscovery${SUBSCRIBE_ID}`)
        this.deviceManager.startDeviceDiscovery(info)
    }

    unregisterDeviceListCallback() {
        Logger.info(TAG, `stopDeviceDiscovery${SUBSCRIBE_ID}`)
        this.deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID)
        this.deviceManager.off('deviceStateChange')
        this.deviceManager.off('deviceFound')
        this.deviceManager.off('discoverFail')
        this.deviceManager.off('serviceDie')
        this.devices = []
        this.discoverDevices = []
    }

    authenticateDevice(device, callBack) {
        Logger.info(TAG, `authenticateDevice ${JSON.stringify(device)}`)
        for (let i = 0; i < this.discoverDevices.length; i++) {
            if (this.discoverDevices[i].deviceId !== device.deviceId) {
                continue
            }
            let extraInfo = {
                'targetPkgName': BUNDLE,
                'appName': 'Distributed rdb',
                'appDescription': 'Distributed rdb',
                'business': '0'
            }
            let authParam = {
                'authType': 1,
                'appIcon': '',
                'appThumbnail': '',
                'extraInfo': extraInfo
            }
            this.deviceManager.authenticateDevice(device, authParam, (err, data) => {
                if (err) {
                    Logger.info(TAG, `authenticateDevice error: ${JSON.stringify(err)}`)
                }
                Logger.info(TAG, `authenticateDevice succeed: ${JSON.stringify(data)}`)
                this.authCallback = callBack
            })
        }
    }
}

export default new RemoteDeviceModel()