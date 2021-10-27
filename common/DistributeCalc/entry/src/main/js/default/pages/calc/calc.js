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
import distributedDataKit from '@ohos.data.distributedData';
import router from '@system.router';

let pressedEqual = false;
let kvManager, kvStore;
const store_id = 'distributedCalc';

export default {
    data: {
        expression: '',
        isPush: false,
        result: ''
    },
    onInit() {
        this.$watch("expression", (value) => {
            if (value !== '') {
                this.result = calc(value).toString();
                if (kvStore != null && !this.isPush) {
                    console.log('Calc[CalcPage] put key start');
                    this.dataChange('expression', value);
                }
            }
        });
    },
    dataChange(key, value) {
        kvStore.put(key, value).then(() => {
            console.log('Calc[CalcPage] put key value successed! value:' + value);
        }).catch((err) => {
            console.log('Calc[CalcPage] put key value failed:' + err);
        });
    },
    initKVManager() {
        let that = this;
        console.log('Calc[CalcPage] get kv manager start');
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
                console.log('Calc[CalcPage] get kv manager failed');
                return;
            }
            kvManager = manager;
            console.log('Calc[CalcPage] get kv manager successed');
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
                    console.log("Calc[CalcPage] get kv store failed");
                    return;
                }
                kvStore = store;
                console.log("Calc[CalcPage] get kv store successed");
                kvStore.on('dataChange', 1, function (data) {
                    console.info('Calc[CalcPage] dataChange, ' + JSON.stringify(data));
                    console.info('Calc[CalcPage] dataChange, insert ' + data.insertEntries.length + " udpate " + data.updateEntries.length);
                    if (data) {
                        let arr = data.insertEntries.concat(data.updateEntries);
                        console.info('Calc[CalcPage] arr ' + JSON.stringify(arr));
                        for (let i = 0;i < arr.length; i++) {
                            let entry = arr[i];
                            if (entry.key === 'expression') {
                                if (entry.value.value === 'exit') {
                                    console.info('Calc[CalcPage] app exit! ');
                                    app.terminate();
                                    return;
                                }
                                that.isPush = true;
                                if (entry.value.value == "clear") {
                                    console.log("Calc[CalcPage] data expression:clear");
                                    that.expression = '';
                                    that.result = '';
                                    continue;
                                } else if (entry.value.value == "equal") {
                                    if (that.result !== '') {
                                        console.log("Calc[CalcPage] data expression:equal");
                                        that.expression = that.result;
                                        that.result = '';
                                        //pressedEqual = true;
                                    }
                                    continue;
                                }
                                pressedEqual = false;
                                that.expression = entry.value.value;
                                console.log("Calc[CalcPage] data changed:" + entry.value.value);
                            }
                        }
                    }
                });
            }).catch((err) => {
                console.log("Calc[CalcPage] get kv store failed:" + err);
            });
        }).catch((err) => {
            console.log('Calc[CalcPage] get kv manager failed:' + err);
        });
        console.log('Calc[CalcPage] get kv manager end');
    },
    stopDataListener() {
        console.log("Calc[CalcPage] stopDataListener");
    },
    onReady() {
        console.log("Calc[CalcPage] on Ready");
        this.initKVManager();
    },
    onDestroy() {
        this.stopDataListener();
        router.clear()
    },
    handleClear() {
        this.expression = '';
        this.result = '';
        if (kvStore != null) {
            this.dataChange('expression', 'clear');
        }
    },
    handleInput(value) {
        console.log('Calc[CalcPage] handleInput:' + value);
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
                console.log("Calc[CalcPage] handleinput value:" + value)
                this.expression += value;
            }
        }
    },
    handleBackspace() {
        if (pressedEqual) {
            this.expression = '';
            this.result = '';
            pressedEqual = false;
            if (kvStore != null) {
                console.log('Calc[CalcPage] handleBackspace1');
                this.dataChange('expression', 'clear');
            }
        } else {
            this.isPush = false;
            this.expression = this.expression.slice(0, -1);
            if (!this.expression.length) {
                this.result = '';
                if (kvStore != null) {
                    console.log('Calc[CalcPage] handleBackspace2');
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
            if (kvStore != null) {
                console.log('Calc[CalcPage] handleEqual');
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
    },
}