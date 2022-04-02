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
import rpc from '@ohos.rpc'
import Logger from '../model/Logger'

const BUNDLE_NAME = "ohos.samples.eTSServiceExtAbility";
const SERVICE_EXT_ABILITY_NAME = "ServiceExtAbility"
const REQUEST_CODE = 1;
const ERROR_CODE = -1;
const SUCCESS_CODE = 1;

export default class ServiceModel {
    connection = -1;
    firstLocalValue = 0;
    secondLocalValue = 0;
    remoteCallback = null;
    context = null;
    options = null;
    constructor(){
        this.context = globalThis.mainAbilityContext;
        this.options = {
            outObj: this,
            onConnect: function (elementName, proxy) {
                Logger.log(`onConnect success`);
                if (proxy === null) {
                    Logger.error(`onConnect proxy is null`);
                    return;
                }
                let option = new rpc.MessageOption();
                let data = new rpc.MessageParcel();
                let reply = new rpc.MessageParcel();
                data.writeInt(this.outObj.firstLocalValue);
                data.writeInt(this.outObj.secondLocalValue);
                proxy.sendRequest(REQUEST_CODE, data, reply, option).then((result) => {
                    Logger.log(`sendRequest: ${result}`);
                    let msg = reply.readInt();
                    Logger.log(`sendRequest:msg: ${msg}`);
                    this.outObj.remoteCallback(SUCCESS_CODE, msg);
                }).catch((e) => {
                    Logger.error(`sendRequest error: ${e}`);
                    this.outObj.remoteCallback(ERROR_CODE, ERROR_CODE);
                });

            },
            onDisconnect: function () {
                Logger.log(`onDisconnect`);
            },
            onFailed: function () {
                Logger.log(`onFailed`);
            }
        }
    }

    startServiceExtAbility(callback) {
        Logger.log(`startServiceExtAbility`);
        let want = {
            bundleName: BUNDLE_NAME,
            abilityName: SERVICE_EXT_ABILITY_NAME
        };
        this.context.startAbility(want).then((data) => {
            Logger.log(`startAbility success: ${ JSON.stringify(data)}`);
            callback(SUCCESS_CODE);
        }).catch((error) => {
            Logger.error(`startAbility failed: ${JSON.stringify(error)}`);
            callback(ERROR_CODE);
        })
    }

    connectServiceExtAbility(fir, sec, callback) {
        Logger.log(`connectServiceExtAbility`);
        this.firstLocalValue = fir;
        this.secondLocalValue = sec;
        this.remoteCallback = callback;
        let want = {
            bundleName: BUNDLE_NAME,
            abilityName: SERVICE_EXT_ABILITY_NAME
        };
        this.connection = this.context.connectAbility(want, this.options);
        Logger.log(`connectServiceExtAbility result:${this.connection}`);
    }

    disconnectServiceExtAbility(callback) {
        Logger.log(`disconnectServiceExtAbility`);
        this.context.disconnectAbility(this.connection).then((data) => {
            Logger.log(`disconnectAbility success:${JSON.stringify(data)}`);
            callback(SUCCESS_CODE);
        }).catch((error) => {
            Logger.error(`disconnectAbility failed:${JSON.stringify(error)}`);
            callback(ERROR_CODE);
        })
    }
}