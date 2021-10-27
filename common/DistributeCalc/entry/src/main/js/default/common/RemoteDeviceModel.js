/*
 * Copyright (c) 2020 Huawei Device Co., Ltd.
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

import prompt from '@system.prompt';
import deviceManager from '@ohos.distributedHardware.deviceManager';

var SUBSCRIBE_ID = 100;

export default class RemoteDeviceModel {
    deviceList = [];
    discoverList = [];
    callback;
    authCallback;
    #deviceManager;

    constructor() {
    }

    registerDeviceListCallback(callback) {
        if (typeof (this.#deviceManager) == 'undefined') {
            console.log("Calc[RemoteDeviceModel] deviceManager.createDeviceManager begin");
            let self = this;
            deviceManager.createDeviceManager("com.example.distributedcalc", (error, value) => {
                if (error) {
                    console.error("Calc[RemoteDeviceModel] createDeviceManager failed.");
                    return;
                }
                self.#deviceManager = value;
                self.registerDeviceListCallback_(callback);
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
        if (this.#deviceManager == undefined) {
            console.error('Calc[RemoteDeviceModel] deviceManager has not initialized');
            this.callback();
            return;
        }

        console.info('Calc[RemoteDeviceModel] getTrustedDeviceListSync begin');
        var list = this.#deviceManager.getTrustedDeviceListSync();
        console.info('Calc[RemoteDeviceModel] getTrustedDeviceListSync end, deviceList=' + JSON.stringify(list));
        if (typeof (list) != 'undefined' && typeof (list.length) != 'undefined') {
            this.deviceList = list;
        }
        this.callback();
        console.info('Calc[RemoteDeviceModel] callback finished');

        let self = this;
        this.#deviceManager.on('deviceStateChange', (data) => {
            console.info('Calc[RemoteDeviceModel] deviceStateChange data=' + JSON.stringify(data));
            switch (data.action) {
                case 0:
                self.deviceList[self.deviceList.length] = data.device;
                console.info('Calc[RemoteDeviceModel] online, updated device list=' + JSON.stringify(self.deviceList));
                self.callback();
                if (self.authCallback != null) {
                    self.authCallback();
                    self.authCallback = null;
                }
                break;
                case 2:
                if (self.deviceList.length > 0) {
                    for (var i = 0; i < self.deviceList.length; i++) {
                        if (self.deviceList[i].deviceId == data.device.deviceId) {
                            self.deviceList[i] = data.device;
                            break;
                        }
                    }
                }
                console.info('Calc[RemoteDeviceModel] change, updated device list=' + JSON.stringify(self.deviceList));
                self.callback();
                break;
                case 1:
                if (self.deviceList.length > 0) {
                    var list = new Array();
                    for (var j = 0; j < self.deviceList.length; j++) {
                        if (self.deviceList[j].deviceId != data.device.deviceId) {
                            list[j] = data.device;
                        }
                    }
                    self.deviceList = list;
                }
                console.info('Calc[RemoteDeviceModel] offline, updated device list=' + JSON.stringify(data.device));
                self.callback();
                break;
                default:
                    break;
            }
        });
        this.#deviceManager.on('deviceFound', (data) => {
            console.info('Calc[RemoteDeviceModel] deviceFound data=' + JSON.stringify(data));
            console.info('Calc[RemoteDeviceModel] deviceFound self.discoverList=' + self.discoverList);
            for (var i = 0;i < self.discoverList.length; i++) {
                if (self.discoverList[i].deviceId == data.device.deviceId) {
                    console.info('Calc[RemoteDeviceModel] device founded ignored');
                    return;
                }
            }
            self.discoverList[self.discoverList.length] = data.device;
            console.info('Calc[RemoteDeviceModel] deviceFound self.discoverList=' + self.discoverList);
            self.callback();
        });
        this.#deviceManager.on('discoverFail', (data) => {
            prompt.showToast({
                message: 'discoverFail reason=' + data.reason,
                duration: 3000,
            });
            console.info('Calc[RemoteDeviceModel] discoverFail data=' + JSON.stringify(data));
        });
        this.#deviceManager.on('serviceDie', () => {
            prompt.showToast({
                message: 'serviceDie',
                duration: 3000,
            });
            console.error('Calc[RemoteDeviceModel] serviceDie');
        });

        SUBSCRIBE_ID = Math.floor(65536 * Math.random());
        var info = {
            subscribeId: SUBSCRIBE_ID,
            mode: 0xAA,
            medium: 2,
            freq: 2,
            isSameAccount: false,
            isWakeRemote: true,
            capability: 0
        };
        console.info('Calc[RemoteDeviceModel] startDeviceDiscovery ' + SUBSCRIBE_ID);
        this.#deviceManager.startDeviceDiscovery(info);
    }

    unregisterDeviceListCallback() {
        console.info('Calc[RemoteDeviceModel] stopDeviceDiscovery ' + SUBSCRIBE_ID);
        this.#deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID);
        this.#deviceManager.off('deviceStateChange');
        this.#deviceManager.off('deviceFound');
        this.#deviceManager.off('discoverFail');
        this.#deviceManager.off('serviceDie');
        this.deviceList = [];
    }

    authenticateDevice(device, callBack) {
        console.info('Calc[RemoteDeviceModel] authenticateDevice ' + JSON.stringify(device));
        for (var i = 0; i < this.discoverList.length; i++) {
            if (this.discoverList[i].deviceId === device.deviceId) {
                let extraInfo = {
                    'targetPkgName': 'com.example.distributedcalc',
                    'appName': 'Distributed Calc',
                    'appDescription': 'Distributed Calc',
                    'business': '0'
                }
                let authParam = {
                    'authType': 1,
                    'appIcon': '',
                    'appThumbnail': '',
                    'extraInfo': extraInfo
                }
                this.#deviceManager.authenticateDevice(device, authParam, (err, data) => {
                    if (err) {
                        console.info('Calc[RemoteDeviceModel] authenticateDevice error:' + JSON.stringify(err));
                        this.authCallback = null
                        return
                    }
                    console.info('Calc[RemoteDeviceModel] authenticateDevice succeed:' + JSON.stringify(data));
                    this.authCallback = callBack
                })

            }
        }
    }
}