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
import { calc, isOperator } from '../../common/calculator.js';
import app from '@system.app';
import RemoteDeviceModel from '../../common/RemoteDeviceModel.js';
import featureAbility from '@ohos.ability.featureAbility';
import { KvStoreModel } from '../../common/kvstoreModel.js';

let pressedEqual = false;
let kvStoreModel = new KvStoreModel();

export default {
    data: {
        title: '计算器',
        expression: '',
        result: '',
        selectedIndex: 0,
        isFA: false,
        isPush: false,
        isDistributed: false,
        remoteDeviceModel: new RemoteDeviceModel(),
        deviceList: []
    },
    onInit() {
        this.grantPermission()
        this.$watch('expression', (value) => {
            if (value !== '') {
                console.info('Calc[IndexPage] value  ' + value);
                this.result = calc(value);
                console.info('Calc[IndexPage] result =  ' + this.result);
                console.log('Calc[IndexPage] put key start');
                this.dataChange('expression', value);
            }
        });
        this.initKVManager();
    },
    onShow() {
        featureAbility.getWant((error, want) => {
            console.info('Calc[IndexPage] featureAbility.getWant =' + JSON.stringify(want.parameters));
            if (want.parameters.isFA === 'FA') {
                this.isFA = true;
                this.isDistributed = true;
            }
        });
    },
    grantPermission() {
        console.info('Calc[IndexPage] grantPermission')
        let context = featureAbility.getContext()
        context.requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'], 666, function (result) {
            console.info(`Calc[IndexPage] grantPermission,requestPermissionsFromUser,result.requestCode=${result}`)
        })
    },
    dataChange(key, value) {
        console.log('Calc[IndexPage] dataChange isDistributed = ' + this.isDistributed);
        if (this.isDistributed && kvStoreModel != null) {
            kvStoreModel.put(key, value);
        }
    },
    initKVManager() {
        kvStoreModel.setOnMessageReceivedListener('expression', (value) => {
            console.log('Calc[IndexPage] data changed:' + value);
            if (value === 'exit') {
                console.info('Calc[CalcPage] app exit! ');
                app.terminate();
                return;
            }
            if (value === 'clear') {
                console.log('Calc[IndexPage] data expression:clear');
                this.expression = '';
                this.result = '';
                return;
            }
            if (value === 'equal') {
                if (this.result !== '') {
                    console.log('Calc[IndexPage] data expression:equal');
                    this.expression = this.result;
                    this.result = '';
                    pressedEqual = true;
                }
                return;
            }
            this.expression = value;
            pressedEqual = false;
            console.log('Calc[IndexPage] data expression:' + this.expression);
        });
        setInterval(() => {
            if (this.isDistributed) {
                let temp = this.expression;
                this.expression = temp;
            }
        }, 200);
    },
    stopDataListener() {
        console.log('Calc[IndexPage] stopDataListener');
    },
    onDestroy() {
        this.remoteDeviceModel.unregisterDeviceListCallback();
        if (this.isDistributed && kvStoreModel != null) {
            this.stopDataListener();
            this.isDistributed = false;
        }
    },
    showDialog() {
        console.info('Calc[IndexPage] showDialog start');
        this.deviceList = [];
        this.remoteDeviceModel.registerDeviceListCallback(() => {
            console.info('Calc[IndexPage] registerDeviceListCallback on remote device updated, count='
            + this.remoteDeviceModel.deviceList.length);
            let list = [];
            list.push({
                deviceId: '0',
                deviceName: 'Local device',
                deviceType: 0,
                networkId: '',
                checked: this.selectedIndex === 0
            });
            let tempList = this.remoteDeviceModel.discoverList.length > 0 ? this.remoteDeviceModel.discoverList : this.remoteDeviceModel.deviceList;
            for (let i = 0; i < tempList.length; i++) {
                console.info('Calc[IndexPage] device ' + i + '/' + tempList.length
                + ' deviceId=' + tempList[i].deviceId + ' deviceName=' + tempList[i].deviceName
                + ' deviceType=' + tempList[i].deviceType);
                list.push({
                    deviceId: tempList[i].deviceId,
                    deviceName: tempList[i].deviceName,
                    deviceType: tempList[i].deviceType,
                    networkId: tempList[i].networkId,
                    checked: this.selectedIndex === (i + 1)
                });
            }
            this.deviceList = list;
            this.$element('showDialog').close();
            this.$element('showDialog').show();
        });
    },
    cancelDialog() {
        this.$element('showDialog').close();
        this.remoteDeviceModel.unregisterDeviceListCallback();
    },

    selectDevice(item) {
        let index = this.deviceList.indexOf(item);
        console.log('Calc[IndexPage] select index:' + index);
        console.log('Calc[IndexPage] select selectedIndex:' + this.selectedIndex);
        if (index === this.selectedIndex) {
            console.log('Calc[IndexPage] index === this.selectedIndex');
            return;
        }
        this.selectedIndex = index;
        if (index === 0) {
            console.log('Calc[IndexPage] stop ability');
            this.dataChange('expression', 'exit');
            this.isDistributed = false;
            this.stopDataListener();
            this.clearSelectState();
            return;
        }
        console.log('Calc[IndexPage] start ability ......');
        this.isDistributed = true;
        if (this.remoteDeviceModel === null || this.remoteDeviceModel.discoverList.length <= 0) {
            console.log('Calc[IndexPage] continue device:' + JSON.stringify(this.deviceList));
            this.startAbility(this.deviceList[index].deviceId);
            this.clearSelectState();
            return;
        }
        console.log('Calc[IndexPage] start ability1, needAuth');
        this.remoteDeviceModel.authenticateDevice(this.deviceList[index], () => {
            console.log('Calc[IndexPage] auth and online finished');
            this.startAbility(this.deviceList[index].deviceId);
        });
        this.clearSelectState();
        console.log('Calc[IndexPage] start ability end....');
    },
    clearSelectState() {
        this.deviceList = [];
        this.$element('showDialog').close();
    },
    async startAbility(deviceId) {
        console.log('Calc[IndexPage] startAbility deviceId:' + deviceId);
        await featureAbility.startAbility({
            want: {
                bundleName: 'ohos.samples.distributedcalc',
                abilityName: 'ohos.samples.distributedcalc.MainAbility',
                deviceId: deviceId,
                parameters: {
                    isFA: 'FA'
                }
            }
        })
        console.log('Calc[IndexPage] start ability finished');
        this.dataChange('expression', this.expression);
        console.log('Calc[IndexPage] startAbility end');
    },
    handleClear() {
        this.expression = '';
        this.result = '';
        console.log('Calc[IndexPage] handleClear');
        this.dataChange('expression', 'clear');
    },
    handleInput(value) {
        console.log('Calc[IndexPage] handle input value:' + value);
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
            if (!this.expression && (value === '*' || value === '/')) {
                return;
            }
            this.expression += value;
        } else {
            if (pressedEqual) {
                pressedEqual = false;
            }
            this.expression += value;
        }

    },
    handleBackspace() {
        if (pressedEqual) {
            this.expression = '';
            this.result = '';
            pressedEqual = false;
            console.log('Calc[IndexPage] handleBackspace1');
            this.dataChange('expression', 'clear');
        } else {
            this.isPush = false;
            this.expression = this.expression.slice(0, -1);
            if (!this.expression.length) {
                this.result = '';
                console.log('Calc[IndexPage] handleBackspace2');
                this.dataChange('expression', 'clear');
            }
        }
    },
    handleEqual() {
        if (this.result !== '') {
            this.isPush = true;
            this.expression = this.result;
            this.result = '';
            pressedEqual = true;
            console.log('Calc[IndexPage] handleEqual');
            this.dataChange('expression', 'equal');
        }
    },
    handleExist() {
        console.log('Calc[IndexPage] handleExist');
        app.terminate();
    }
};