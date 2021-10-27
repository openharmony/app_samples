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
import {calc, isOperator} from '../../common/calculator.js';
import app from '@system.app';
import router from '@system.router';
import distributedDataKit from '@ohos.data.distributedData';
import RemoteDeviceModel from '../../common/RemoteDeviceModel.js';
import featureAbility from '@ohos.ability.featureAbility';


let pressedEqual = false;
let kvManager, kvStore;
const store_id = 'distributedCalc';

export default {
    data: {
        title: '计算器',
        expression: '',
        result: '',
        selectedIndex: -1,
        isPush: false,
        isDistributed: false,
        remoteDeviceModel: new RemoteDeviceModel(),
        deviceList: []
    },
    onInit() {
        this.$watch("expression", (value) => {
            if (value !== '') {
                this.result = calc(value).toString();
                if (this.isDistributed && kvStore != null && !this.isPush) {
                    console.log('Calc[IndexPage] put key start');
                    this.dataChange('expression', value);
                }
            }
        });
    },
    onShow() {
        featureAbility.getWant((error, want) => {
            console.info('Calc[IndexPage] featureAbility.getWant =' + JSON.stringify(want.parameters));
            if (want.parameters.isFA === 'FA') {
                router.replace({
                    uri: 'pages/calc/calc'
                });
            } else {
                this.initKVManager(() => {
                })
            }
        });
    },
    dataChange(key, value) {
        kvStore.put(key, value).then(() => {
            console.log('Calc[IndexPage] put key value successed value:' + value);
        }).catch((err) => {
            console.log('Calc[IndexPage] put key value failed:' + err);
        });
    },
    initKVManager(done) {
        if (kvStore != null) {
            this.isDistributed = true;
            this.startDataListener();
            done();
            return;
        }
        console.log('Calc[IndexPage] get kv manager start');
        const config =
            {
                userInfo: {
                    userId: '0',
                    userType: 0
                },
                bundleName: 'com.example.distributedcalc'
            };
        const promise = distributedDataKit.createKVManager(config);
        promise.then((manager) => {
            if (manager == null) {
                console.log('Calc[IndexPage] get kv manager failed');
                return;
            }
            kvManager = manager;
            console.log('Calc[IndexPage] get kv manager successed');
            const options =
                {
                    createIfMissing: true,
                    encrypt: false,
                    backup: false,
                    autoSync: true,
                    kvStoreType: 1,
                    schema: '',
                    securityLevel: 3
                };
            kvManager.getKVStore(store_id, options).then((store) => {
                if (store == null) {
                    console.log("Calc[IndexPage] get kv store failed");
                    return;
                }
                kvStore = store;
                console.log("Calc[IndexPage] get kv store successed");
                this.startDataListener();
                done();
            }).catch((err) => {
                console.log("Calc[IndexPage] get kv store failed:" + err);
            });
        }).catch((err) => {
            console.log('Calc[IndexPage] get kv manager failed:' + err);
        });
        console.log('Calc[IndexPage] get kv manager end');
    },
    startDataListener() {
        if (kvStore == null) {
            console.info('Calc[IndexPage] startDataListener kvstore is null');
            return;
        }
        let that = this;
        kvStore.on('dataChange', 1, function (data) {
            console.info('Calc[IndexPage] dataChange, ' + JSON.stringify(data));
            console.info('Calc[IndexPage] dataChange, insert ' + data.insertEntries.length + " udpate " + data.updateEntries.length);
            if (data) {
                let arr = data.insertEntries.concat(data.updateEntries);
                console.info('Calc[IndexPage] arr ' + JSON.stringify(arr));
                for (let i = 0;i < arr.length; i++) {
                    let entry = arr[i];
                    if (entry.key === 'expression') {
                        that.isPush = true;
                        if (entry.value.value == "clear") {
                            console.log("Calc[IndexPage] data expression:clear");
                            that.expression = '';
                            that.result = '';
                            continue;
                        } else if (entry.value.value == "equal") {
                            if (that.result !== '') {
                                console.log("Calc[IndexPage] data expression:equal");
                                that.expression = that.result;
                                that.result = '';
                                //pressedEqual = true;
                            }
                            continue;
                        }
                        that.expression = entry.value.value;
                        pressedEqual = false;
                        console.log("Calc[IndexPage] data expression:" + that.expression);
                        console.log("Calc[IndexPage] data changed:" + entry.value.value);
                    }
                }
            }
        });
    },
    stopDataListener() {
        console.log("Calc[IndexPage] stopDataListener");
    },
    onDestroy() {
        this.remoteDeviceModel.unregisterDeviceListCallback();
        if (this.isDistributed && kvStore != null) {
            this.stopDataListener();
            this.isDistributed = false;
        }
        router.clear()
    },
    showDialog() {
        console.info('Calc[IndexPage] showDialog start');
        this.deviceList = [];
        let self = this;
        this.remoteDeviceModel.registerDeviceListCallback(() => {
            console.info('Calc[IndexPage] registerDeviceListCallback, callback entered');
            console.info('Calc[IndexPage] on remote device updated, count=' + self.remoteDeviceModel.deviceList.length);
            var list = new Array();
            list[0] = {
                deviceId: '0',
                deviceName: '本机',
                deviceType: 0,
                checked: false
            }
            var deviceList_;
            if (self.remoteDeviceModel.discoverList.length > 0) {
                deviceList_ = self.remoteDeviceModel.discoverList;
            } else {
                deviceList_ = self.remoteDeviceModel.deviceList;
            }
            for (var i = 0; i < deviceList_.length; i++) {
                console.info('Calc[IndexPage] device ' + i + '/' + deviceList_.length +
                ' deviceId=' + deviceList_[i].deviceId + ' deviceName=' + deviceList_[i].deviceName
                + ' deviceType=' + deviceList_[i].deviceType);
                list[i + 1] = {
                    deviceId: deviceList_[i].deviceId,
                    deviceName: deviceList_[i].deviceName,
                    deviceType: deviceList_[i].deviceType,
                    checked: false
                }
            }
            for (let i = 0; i < list.length; i++) {
                list[i].checked = (this.selectedIndex === i);
                console.info('Calc[IndexPage] list[i].checked:' + list[i].checked);
            }
            self.deviceList = list;
            this.$element('showDialog').show();
        });
    },
    cancelDialog() {
        this.$element('showDialog').close();
        this.remoteDeviceModel.unregisterDeviceListCallback();
    },
    selectDevice(index, e) {
        console.log("Calc[IndexPage] select e.value:" + e.value)
        console.log("Calc[IndexPage] select index:" + index)
        console.log("Calc[IndexPage] select selectedIndex:" + this.selectedIndex)
        if (this.deviceList[index].deviceName != e.value) {
            console.log("Calc[IndexPage] index != e.value")
            console.log("Calc[IndexPage] value:" + e.value)
            return
        }
        if (!e.checked) {
            console.log("Calc[IndexPage] !e.checked")
            return;
        }
        if (index === this.selectedIndex) {
            console.log("Calc[IndexPage] index === this.selectedIndex")
            return;
        }
        if (index == 0) {
            console.log("Calc[IndexPage] stop ability")
            this.dataChange('expression', 'exit');
            this.isDistributed = false;
            this.stopDataListener();
            this.deviceList = []
            this.$element('showDialog').close()
        } else {
            console.log("Calc[IndexPage] start ability ......")
            this.isDistributed = true
            let needAuth;
            if (this.remoteDeviceModel.discoverList.length > 0) {
                needAuth = true
            } else {
                needAuth = false
            }
            console.log("Calc[IndexPage] start ability1, needAuth：" + needAuth)
            if (needAuth) {
                console.log("Calc[IndexPage] continue auth device:" + JSON.stringify(this.deviceList[index]))
                this.remoteDeviceModel.authenticateDevice(this.deviceList[index], () => {
                    console.log("Calc[IndexPage] auth and online finished")
                    for (var i = 0; i < this.remoteDeviceModel.deviceList.length; i++) {
                        if (this.remoteDeviceModel.deviceList[i].deviceName === this.deviceList[index].deviceName) {
                            this.startAbility(this.remoteDeviceModel.deviceList[i].deviceId)
                        }
                    }
                })
            } else {
                console.log("Calc[IndexPage] continue unauthed device:" + JSON.stringify(this.deviceList))
                this.startAbility(this.deviceList[index].deviceId)
            }
            console.log("Calc[IndexPage] start ability2 ......")
            this.deviceList = []
            this.$element('showDialog').close()
            console.log("Calc[IndexPage] start ability end....")
        }
        this.selectedIndex = index;
    },
    startAbility(deviceId) {
        console.log("Calc[IndexPage] startAbility deviceId:" + deviceId);
        featureAbility.startAbility({
            want: {
                bundleName: 'com.example.distributedcalc',
                abilityName: 'com.example.distributedcalc.MainAbility',
                deviceId: deviceId,
                parameters: {
                    isFA: 'FA'
                }
            }
        }).then((data) => {
            console.log("Calc[IndexPage] start ability finished:" + JSON.stringify(data));
            this.dataChange('expression', this.expression);
        });
        console.log("Calc[IndexPage] startAbility end");
    },
    handleClear() {
        this.expression = '';
        this.result = '';
        if (this.isDistributed && kvStore != null) {
            console.log('Calc[IndexPage] handleClear');
            this.dataChange('expression', 'clear');
        }
    },
    handleInput(value) {
        console.log("Calc[IndexPage] handle input value:" + value);
        this.isPush = false;
        if (isOperator(value)) {
            if (pressedEqual) {
                pressedEqual = false;
            } else {
                const size = this.expression.length;
                if (size) {
                    const last = this.expression.charAt(size - 1);
                    if (isOperator(last)) {
                        this.expression = this.expression.slice(0, -1);
                    }
                }
            }
            if (!this.expression && (value == '*' || value == '/')) {
                return;
            }
            this.expression += value;
        } else {
            if (pressedEqual) {
                this.expression = value;
                pressedEqual = false;
            } else {
                console.log("Calc[IndexPage] handle input:" + value)
                this.expression += value;
            }
        }

    },
    handleBackspace() {
        if (pressedEqual) {
            this.expression = '';
            this.result = '';
            pressedEqual = false;
            if (this.isDistributed && kvStore != null) {
                console.log('Calc[IndexPage] handleBackspace1');
                this.dataChange('expression', 'clear');
            }
        } else {
            this.isPush = false;
            this.expression = this.expression.slice(0, -1);
            if (!this.expression.length) {
                this.result = '';
                if (this.isDistributed && kvStore != null) {
                    console.log('Calc[IndexPage] handleBackspace2');
                    this.dataChange('expression', 'clear');
                }
            }
        }
    },
    handleEqual() {
        if (this.result !== '') {
            this.isPush = true;
            this.expression = this.result;
            this.result = '';
            pressedEqual = true;
            if (this.isDistributed && kvStore != null) {
                console.log('Calc[IndexPage] handleEqual');
                this.dataChange('expression', 'equal');
            }
        }
    },
    handleTerminate(e) {
        if (e.direction === 'right') {
            app.terminate();
        }
    },
    handleExist() {
        app.terminate();
    }
}