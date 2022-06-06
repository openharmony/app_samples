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

import prompt from '@ohos.prompt';
import deviceManager from '@ohos.distributedHardware.deviceManager';

let SUBSCRIBE_ID = 100;

export default class RemoteDeviceModel {
    deviceList = [];
    discoverList = [];
    callback;
    authCallback;
    deviceManager = undefined;

    constructor() {
    }

    registerDeviceListCallback(callback) {
        if (typeof (this.deviceManager) == 'undefined') {
            console.log("Calc[RemoteDeviceModel] deviceManager.createDeviceManager begin");
            deviceManager.createDeviceManager("ohos.samples.distributedcalc", (error, value) => {
                if (error) {
                    console.error("Calc[RemoteDeviceModel] createDeviceManager failed.");
                    return;
                }
                this.deviceManager = value;
                this.registerDeviceListCallback_(callback);
                console.log("Calc[RemoteDeviceModel] createDeviceManager callback returned, error=" + error + " value=" + value);
            });
            console.log("Calc[RemoteDeviceModel] deviceManager.createDeviceManager end");
        } else {
            this.registerDeviceListCallback_(callback);
        }
    }

    registerDeviceListCallback_(callback) {
        console.info('Calc[RemoteDeviceModel] registerDeviceListCallback');
        this.callback = callback;
        if (this.deviceManager == undefined) {
            console.error('Calc[RemoteDeviceModel] deviceManager has not initialized');
            this.callback();
            return;
        }

        console.info('Calc[RemoteDeviceModel] getTrustedDeviceListSync begin');
        let list = this.deviceManager.getTrustedDeviceListSync();
        console.info('Calc[RemoteDeviceModel] getTrustedDeviceListSync end, deviceList=' + JSON.stringify(list));
        if (typeof (list) != 'undefined' && typeof (list.length) != 'undefined') {
            this.deviceList = list;
        }
        this.callback();
        console.info('Calc[RemoteDeviceModel] callback finished');


        this.deviceManager.on('deviceStateChange', (data) => {
            console.info('Calc[RemoteDeviceModel] deviceStateChange data=' + JSON.stringify(data));
            switch (data.action) {
                case 0:
                this.deviceList[this.deviceList.length] = data.device;
                console.info('Calc[RemoteDeviceModel] online, updated device list=' + JSON.stringify(this.deviceList));
                this.callback();
                if (this.authCallback != null) {
                    this.authCallback();
                    this.authCallback = null;
                }
                break;
                case 2:
                if (this.deviceList.length > 0) {
                    for (let i = 0; i < this.deviceList.length; i++) {
                        if (this.deviceList[i].deviceId == data.device.deviceId) {
                            this.deviceList[i] = data.device;
                            break;
                        }
                    }
                }
                console.info('Calc[RemoteDeviceModel] change, updated device list=' + JSON.stringify(this.deviceList));
                this.callback();
                break;
                case 1:
                if (this.deviceList.length > 0) {
                    let list = new Array();
                    for (let j = 0; j < this.deviceList.length; j++) {
                        if (this.deviceList[j].deviceId != data.device.deviceId) {
                            list[j] = data.device;
                        }
                    }
                    this.deviceList = list;
                }
                console.info('Calc[RemoteDeviceModel] offline, updated device list=' + JSON.stringify(data.device));
                this.callback();
                break;
                default:
                    break;
            }
        });
        this.deviceManager.on('deviceFound', (data) => {
            console.info('Calc[RemoteDeviceModel] deviceFound data=' + JSON.stringify(data));
            console.info('Calc[RemoteDeviceModel] deviceFound this.discoverList=' + this.discoverList);
            for (let i = 0;i < this.discoverList.length; i++) {
                if (this.discoverList[i].deviceId == data.device.deviceId) {
                    console.info('Calc[RemoteDeviceModel] device founded ignored');
                    return;
                }
            }
            this.discoverList[this.discoverList.length] = data.device;
            console.info('Calc[RemoteDeviceModel] deviceFound this.discoverList=' + this.discoverList);
            this.callback();
        });
        this.deviceManager.on('discoverFail', (data) => {
            prompt.showToast({
                message: 'discoverFail reason=' + data.reason,
                duration: 3000,
            });
            console.info('Calc[RemoteDeviceModel] discoverFail data=' + JSON.stringify(data));
        });
        this.deviceManager.on('serviceDie', () => {
            prompt.showToast({
                message: 'serviceDie',
                duration: 3000,
            });
            console.error('Calc[RemoteDeviceModel] serviceDie');
        });

        SUBSCRIBE_ID = Math.floor(65536 * Math.random());
        let info = {
            subscribeId: SUBSCRIBE_ID,
            mode: 0xAA,
            medium: 2,
            freq: 2,
            isSameAccount: false,
            isWakeRemote: true,
            capability: 0
        };
        console.info('Calc[RemoteDeviceModel] startDeviceDiscovery ' + SUBSCRIBE_ID);
        this.deviceManager.startDeviceDiscovery(info);
    }

    unregisterDeviceListCallback() {
        console.info('Calc[RemoteDeviceModel] stopDeviceDiscovery ' + SUBSCRIBE_ID);
        this.deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID);
        this.deviceManager.off('deviceStateChange');
        this.deviceManager.off('deviceFound');
        this.deviceManager.off('discoverFail');
        this.deviceManager.off('serviceDie');
        this.deviceList = [];
    }

    authenticateDevice(device, callBack) {
        console.info('Calc[RemoteDeviceModel] authenticateDevice ' + JSON.stringify(device));
        for (let i = 0; i < this.discoverList.length; i++) {
            if (this.discoverList[i].deviceId === device.deviceId) {
                let extraInfo = {
                    'targetPkgName': 'ohos.samples.distributedcalc',
                    'appName': 'Distributed Calc',
                    'appDescription': 'Distributed Calc',
                    'business': '0'
                };
                let authParam = {
                    'authType': 1,
                    'extraInfo': extraInfo
                };
                this.deviceManager.authenticateDevice(device, authParam, (err, data) => {
                    if (err) {
                        console.info('Calc[RemoteDeviceModel] authenticateDevice error:' + JSON.stringify(err));
                        this.authCallback = null;
                        return;
                    }
                    console.info('Calc[RemoteDeviceModel] authenticateDevice succeed:' + JSON.stringify(data));
                    this.authCallback = callBack;
                })

            }
        }
    }
}