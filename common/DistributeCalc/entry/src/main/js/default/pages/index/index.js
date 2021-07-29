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
import distributedDataKit from '@ohos.data.distributeddata';
import RemoteDeviceModel from '../../common/RemoteDeviceModel.js'
import featureAbility from '@ohos.ability.featureability';


let pressedEqual = false;
let kvManager,kvStore;
const store_id = 'distributedCalc';

export default {
    data: {
        title:'计算器',
        expression : '',
        result : '',
        selectedIndex: -1,
        isPush:false,
        isDistributed:false,
        remoteDeviceModel: new RemoteDeviceModel(),
        deviceList:[]
    },
    onInit() {
        this.$watch("expression", (value)=> {
            if (value !== '') {
                this.result = calc(value).toString();
                if(this.isDistributed && kvStore != null && !this.isPush) {
                    console.log('Calc[IndexPage] data changed');
                    this.dataChange('expression',value);
                }
            }
        });
    },
    onReady(){
        featureAbility.getWant((error, want) => {
            console.info('Calc[IndexPage] featureAbility.getWant =' + JSON.stringify(want.parameters));
            if (want.parameters.isFA && want.parameters.isFA === 'FA') {
                router.replace({
                    uri:'pages/calc/calc'
                });
            }
        });
    },
    dataChange(key, value){
        kvStore.put(key,value).then((data)=>{
            console.log('Calc[IndexPage] put key value successed value:'+value);
        }).catch((err)=>{
            console.log('Calc[IndexPage] put key value failed:'+err);
        });
    },
    initKVManager(done){
        if(kvStore != null) {
            this.isDistributed = true;
            this.startDataListener();
            done();
            return;
        }
        console.log('Calc[IndexPage] get kv manager start');
        const config =
        {
            userInfo : {
                userId : '0',
                userType : 0
            },
            bundleName : 'com.example.distributedcalc'
        };
        const promise =  distributedDataKit.createKVManager(config);
        promise.then((manager)=>{
            if(manager == null) {
                console.log('Calc[IndexPage] get kv manager failed');
                return;
            }
            kvManager = manager;
            console.log('Calc[IndexPage] get kv manager successed');
            const options =
                {
                    createIfMissing : true,
                    encrypt : false,
                    backup : false,
                    autoSync : true,
                    kvStoreType : 1,
                    schema : '',
                    securityLevel : 3
                };
            kvManager.getKVStore(store_id,options).then((store)=>{
                if(store == null) {
                    console.log("Calc[IndexPage] get kv store failed");
                    return;
                }
                kvStore = store;
                console.log("Calc[IndexPage] get kv store successed");
                this.isDistributed = true;
                this.startDataListener();
                done();
            }).catch((err)=>{
                console.log("Calc[IndexPage] get kv store failed:"+err);
            });
        }).catch((err)=>{
            console.log('Calc[IndexPage] get kv manager failed:'+err);
        });
        console.log('Calc[IndexPage] get kv manager end');
    },

    startDataListener(){
        if(kvStore == null) {
            console.info('Calc[IndexPage] startDataListener kvstore is null');
            return;
        }
        let that = this;
        kvStore.on('dataChange', 1, function (data) {
            console.info('Calc[IndexPage] dataChange, ' + JSON.stringify(data));
            console.info('Calc[IndexPage] dataChange, insert ' + data.insertEntries.length + " udpate " + data.updateEntries.length);
            if(data) {
                let arr = data.insertEntries.concat(data.updateEntries);
                console.info('Calc[IndexPage] arr ' + JSON.stringify(arr));
                for(let i=0;i< arr.length;i++){
                    let entry = arr[i];
                    if(entry.key === 'expression') {
                        that.isPush = true;
                        if(entry.value.value == "clear") {
                            console.log("Calc[IndexPage] data expression:clear");
                            that.expression = '';
                            that.result = '';
                            continue;
                        }
                        that.expression = entry.value.value;
                        console.log("Calc[IndexPage] data expression:" + that.expression);
                        console.log("Calc[IndexPage] data changed:" + entry.value.value);
                    }
                }
            }
        });
    },

    stopDataListener(){
        console.log("Calc[IndexPage] stopDataListener");
    },
    onDestroy(){
        this.remoteDeviceModel.unregisterDeviceListCallback();
        if(this.isDistributed && kvStore != null) {
            this.stopDataListener();
            this.isDistributed = false;
        }
    },
    showDialog(){
        console.info('Calc[IndexPage] onContinueAbilityClick');
        let self = this;
        this.remoteDeviceModel.registerDeviceListCallback(() => {
            console.info('Calc[IndexPage] registerDeviceListCallback, callback entered');
            var list = new Array();
            list[0] = {
                    deviceId: '0',
                    deviceName: '本机',
                    checked: (self.selectedIndex == 0)
                };
            console.info('Calc[IndexPage] on remote device updated, count=' + self.remoteDeviceModel.deviceList.length);
            for (var i = 0; i < self.remoteDeviceModel.deviceList.length; i++) {
                console.info('Calc[IndexPage] device ' + i + '/' + self.remoteDeviceModel.deviceList.length +
                ' deviceId=' + self.remoteDeviceModel.deviceList[i].deviceId + ' deviceName=' + self.remoteDeviceModel.deviceList[i].deviceName
                + ' deviceType=' + self.remoteDeviceModel.deviceList[i].deviceType);
                list[i + 1] = {
                    deviceName: self.remoteDeviceModel.deviceList[i].deviceName,
                    deviceId: self.remoteDeviceModel.deviceList[i].deviceId,
                    checked: (self.selectedIndex == (i + 1))
                };
            }
            self.deviceList = list;
        });
        this.$element('showDialog').show();
    },
    cancelDialog(){
        this.$element('showDialog').close();
        this.remoteDeviceModel.unregisterDeviceListCallback();
    },
    selectDevice(index,e){
        if(!e.checked) {
            return;
        }
        if(index === this.selectedIndex) {
            return;
        }
        console.log("Calc[IndexPage] select index:"+index)
        if (index == 0) {
            console.log("Calc[IndexPage] stop ability")
            this.dataChange('expression', 'exit');
            this.isDistributed = false;
            this.stopDataListener();
        } else {
            this.initKVManager(()=>{
                console.log("Calc[IndexPage] start ability deviceID:"+this.deviceList[index].deviceId);
                featureAbility.startAbility({
                    want:{
                        bundleName: 'com.example.distributedcalc',
                        abilityName: 'com.example.distributedcalc.MainAbility',
                        deviceId:this.deviceList[index].deviceId,
                        parameters: {
                            isFA: 'FA'
                        }
                    }
                }).then((data)=>{
                    console.log("Calc[IndexPage] start ability finished:" + JSON.stringify(data));
                });
                console.log("Calc[IndexPage] start ability end")
            });
        }
        this.selectedIndex = index;
        this.cancelDialog();
    },
    handleClear() {
        this.expression = '';
        this.result = '';
        if(this.isDistributed && kvStore != null) {
            console.log('Calc[IndexPage] data changed');
            this.dataChange('expression','clear');
        }
    },
    handleInput(value) {
        console.log("Calc[IndexPage] handle input value:"+value)
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
                console.log("Calc[IndexPage] handle input:"+value)
                this.expression += value;
            }
        }
        this.isPush = false;
    },
    handleBackspace() {
        if(pressedEqual) {
            this.expression = '';
            this.result = '';
            pressedEqual = false;
        } else {
            this.expression = this.expression.slice(0, -1);
            if (!this.expression.length) {
                this.result = '';
            }
        }
    },
    handleEqual() {
        if (this.result !== '') {
            this.expression = this.result;
            this.result = '';
            pressedEqual = true;
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