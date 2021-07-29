import prompt from '@system.prompt';
import deviceManager from '@ohos.distributedHardware.deviceManager';

var SUBSCRIBE_ID = 100;

export default class RemoteDeviceModel {
    deviceList = new Array();
    callback;
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
        this.#deviceManager.on('deviceFound', (data) => {
            console.info('Calc[RemoteDeviceModel] deviceFound data=' + JSON.stringify(data));
            prompt.showToast({
                message: 'deviceFound device=' + JSON.stringify(data.device),
                duration: 3000,
            });
            console.info('Calc[RemoteDeviceModel] deviceFound self.deviceList=' + self.deviceList);
            console.info('Calc[RemoteDeviceModel] deviceFound self.deviceList.length=' + self.deviceList.length);
//            for (var i = 0; i < self.deviceList.length; i++) {
//                if (self.deviceList[i].deviceId == data.device.deviceId) {
//                    console.info('Calc[RemoteDeviceModel] device founded, ignored');
//                    return;
//                }
//            }

            console.info('Calc[RemoteDeviceModel] authenticateDevice ' + JSON.stringify(data.device));
            self.#deviceManager.authenticateDevice(data.device);
            var list = self.#deviceManager.getTrustedDeviceListSync();
            console.info('Calc[RemoteDeviceModel] getTrustedDeviceListSync end, deviceList=' + JSON.stringify(list));
            if (typeof (list) != 'undefined' && typeof (list.length) != 'undefined') {
                self.deviceList = list;
            }
        });
        this.#deviceManager.on('discoverFail', (data) => {
            prompt.showToast({
                message: 'discoverFail reason=' + data.reason,
                duration: 3000,
            });
            console.info('Calc[RemoteDeviceModel] discoverFail data=' + JSON.stringify(data));
        });
        this.#deviceManager.on('authResult', (data) => {
            prompt.showToast({
                message: 'authResult data=' + JSON.stringify(data),
                duration: 3000,
            });
            console.info('Calc[RemoteDeviceModel] authResult data=' + JSON.stringify(data));
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
        console.info('Calc[RemoteDeviceModel] startDeviceDiscover ' + SUBSCRIBE_ID);
        this.#deviceManager.startDeviceDiscover(info);
    }

    unregisterDeviceListCallback() {
        console.info('Calc[RemoteDeviceModel] stopDeviceDiscover ' + SUBSCRIBE_ID);
        this.#deviceManager.stopDeviceDiscover(SUBSCRIBE_ID);
        this.#deviceManager.off('deviceStateChange');
        this.#deviceManager.off('deviceFound');
        this.#deviceManager.off('discoverFail');
        this.#deviceManager.off('authResult');
        this.#deviceManager.off('serviceDie');
        this.deviceList = new Array();
    }
}