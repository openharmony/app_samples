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
    deviceList = new Array();
    callback;
    deviceManager_;

    constructor() {
    }

    registerDeviceListCallback(callback) {
        if (typeof (this.deviceManager_) == 'undefined') {
            console.log("Calc[RemoteDeviceModel] deviceManager.createDeviceManager begin");
            let self = this;
            deviceManager.createDeviceManager("com.example.distributedcalc", (error, value) => {
                if (error) {
                    console.error("Calc[RemoteDeviceModel] createDeviceManager failed.");
                    return;
                }
                self.deviceManager_ = value;
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
        if (this.deviceManager_ == undefined) {
            console.error('Calc[RemoteDeviceModel] deviceManager has not initialized');
            this.callback();
            return;
        }

        console.info('Calc[RemoteDeviceModel] getTrustedDeviceListSync begin');
        var list = this.deviceManager_.getTrustedDeviceListSync();
        console.info('Calc[RemoteDeviceModel] getTrustedDeviceListSync end, deviceList=' + JSON.stringify(list));
        if (typeof (list) != 'undefined' && typeof (list.length) != 'undefined') {
            this.deviceList = list;
        }
        this.callback();
        console.info('Calc[RemoteDeviceModel] callback finished');

        let self = this;
        this.deviceManager_.on('deviceStateChange', (data) => {
            console.info('Calc[RemoteDeviceModel] deviceStateChange data=' + JSON.stringify(data));
            switch (data.action) {
                case 0:
                    self.deviceList[self.deviceList.length] = data.device;
                    console.info('Calc[RemoteDeviceModel] online, updated device list=' + JSON.stringify(self.deviceList));
                    self.callback();
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
                        for (var i = 0; i < self.deviceList.length; i++) {
                            if (self.deviceList[i].deviceId != data.device.deviceId) {
                                list[i] = data.device;
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
        this.deviceManager_.on('deviceFound', (data) => {
            console.info('Calc[RemoteDeviceModel] deviceFound data=' + JSON.stringify(data));
            prompt.showToast({
                message: 'deviceFound device=' + JSON.stringify(data.device),
                duration: 3000,
            });
            console.info('Calc[RemoteDeviceModel] deviceFound self.deviceList=' + self.deviceList);
            console.info('Calc[RemoteDeviceModel] deviceFound self.deviceList.length=' + self.deviceList.length);
            console.info('Calc[RemoteDeviceModel] authenticateDevice ' + JSON.stringify(data.device));
            self.deviceManager_.authenticateDevice(data.device);
            var list = self.deviceManager_.getTrustedDeviceListSync();
            console.info('Calc[RemoteDeviceModel] getTrustedDeviceListSync end, deviceList=' + JSON.stringify(list));
            if (typeof (list) != 'undefined' && typeof (list.length) != 'undefined') {
                self.deviceList = list;
            }
        });
        this.deviceManager_.on('discoverFail', (data) => {
            prompt.showToast({
                message: 'discoverFail reason=' + data.reason,
                duration: 3000,
            });
            console.info('Calc[RemoteDeviceModel] discoverFail data=' + JSON.stringify(data));
        });
        this.deviceManager_.on('authResult', (data) => {
            prompt.showToast({
                message: 'authResult data=' + JSON.stringify(data),
                duration: 3000,
            });
            console.info('Calc[RemoteDeviceModel] authResult data=' + JSON.stringify(data));
        });
        this.deviceManager_.on('serviceDie', () => {
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
        console.info('Calc[RemoteDeviceModel] startDeviceDiscover ' + SUBSCRIBE_ID);
        this.deviceManager_.startDeviceDiscover(info);
    }

    unregisterDeviceListCallback() {
        console.info('Calc[RemoteDeviceModel] stopDeviceDiscover ' + SUBSCRIBE_ID);
        this.deviceManager_.stopDeviceDiscover(SUBSCRIBE_ID);
        this.deviceManager_.off('deviceStateChange');
        this.deviceManager_.off('deviceFound');
        this.deviceManager_.off('discoverFail');
        this.deviceManager_.off('authResult');
        this.deviceManager_.off('serviceDie');
        this.deviceList = new Array();
    }
}