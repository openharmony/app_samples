// @ts-nocheck
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
import ServiceExtension from '@ohos.application.ServiceExtensionAbility'
import rpc from '@ohos.rpc'
import {KeyboardController} from '../model/KeyboardController.ets'
import Want from "@ohos.application.Want"

class StubTest extends rpc.RemoteObject {
    constructor(des) {
        if (typeof des === 'string') {
            super(des);
        } else {
            return null;
        }
    }

    queryLocalInterface(descriptor){
        return null;
    }

    getInterfaceDescriptor(){
        return "";
    };

    sendRequest(code, data, reply, options){
        return null;
    };

    getCallingPid(){
        return 0;
    };

    getCallingUid(){
        return 0;
    };

    attachLocalInterface(localInterface, descriptor){

    };

    onRemoteRequest(code, data, reply, option) {
        console.info('kikaInput: ' + 'onRemoteRequest')
        if (code === 1) {
            console.info('kikaInput: ' + 'code 1 begin');
            let op1 = data.readInt();
            let op2 = data.readInt();
            reply.writeInt(op1 + op2);
        } else {
            console.info('kikaInput: ' + 'onRemoteRequest code: ' + code);
        }
        return true;
    }
}

class ServiceExtAbility extends ServiceExtension {
    keyboardController: any;

    onCreate(want) {
        this.addLog('onCreate want: ' + want.abilityName);
        this.keyboardController = new KeyboardController(this.context);
        this.keyboardController.onCreate();
    }

    onRequest(want:any, startId:any) {
        this.addLog('onRequest want: ' + want.abilityName + ',startId: ' + startId);
    }

    onConnect(want:Want) {
        this.addLog('onConnect want: ' + want.abilityName);
        return new StubTest('test');
    }

    onDisconnect(want:any) {
        this.addLog('onDisconnect want: ' + want.abilityName);
    }

    onDestroy() {
        this.addLog('onDestroy');
        this.keyboardController.onDestroy();
    }

    addLog(message: string) {
        console.info('kikaInput-new: ' + message);
    }
}

export default ServiceExtAbility