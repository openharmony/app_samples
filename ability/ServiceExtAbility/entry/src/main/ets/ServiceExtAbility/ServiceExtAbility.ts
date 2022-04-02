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

import Extension from '@ohos.application.ServiceExtensionAbility'
import rpc from '@ohos.rpc'
import Logger from '../model/Logger'

const REQUEST_VALUE = 1;

class StubTest extends rpc.RemoteObject {
    constructor(des) {
        super(des);
    }
    onRemoteRequest(code, data, reply, option) {
        Logger.log(`onRemoteRequest`);
        if (code === REQUEST_VALUE) {
            let optFir = data.readInt();
            let optSec = data.readInt();
            reply.writeInt(optFir + optSec);
            Logger.log(`onRemoteRequest: opt: ${optFir}, opt2: ${optSec}`);
        }
        return true;
    }
    queryLocalInterface(descriptor) {
        return null;
    }
    getInterfaceDescriptor() {
        return "";
    }
    sendRequest(code, data, reply, options) {
        return null;
    }
    getCallingPid() {
        return REQUEST_VALUE;
    }
    getCallingUid() {
        return REQUEST_VALUE;
    }
    attachLocalInterface(localInterface, descriptor){}
}

export default class ServiceExtAbility extends Extension {
    onCreate(want) {
        Logger.log(`onCreate, want: ${want.abilityName}`);
    }
    onRequest(want, startId) {
        Logger.log(`onRequest, want: ${want.abilityName}`);
    }
    onConnect(want) {
        Logger.log(`onConnect , want: ${want.abilityName}`);
        return new StubTest("test");
    }
    onDisconnect(want) {
        Logger.log(`onDisconnect, want: ${want.abilityName}`);
    }
    onDestroy() {
        Logger.log(`onDestroy`);
    }
}