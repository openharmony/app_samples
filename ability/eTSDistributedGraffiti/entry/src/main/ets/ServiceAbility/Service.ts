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

import rpc from "@ohos.rpc";

let CODE_CONNECT_REMOTE = 1;
let CODE_CONNECT_LOCAL = 2;
let CODE_CONTROL_FA = 3;

class FirstServiceAbilityStub extends rpc.RemoteObject {
    mainAbilityStub;

    constructor(des) {
        if (typeof des === 'string') {
            super(des);
        } else {
            return null;
        }
    }

    async sendMessageToFa(x : number, y : number, touchType : number) : Promise<void> {
        let option = new rpc.MessageOption();
        let data = new rpc.MessageParcel();
        let reply = new rpc.MessageParcel();
        data.writeInt(x);
        data.writeInt(y);
        data.writeInt(touchType);
        await this.mainAbilityStub.sendRequest(CODE_CONTROL_FA, data, reply, option);
    }

    onRemoteRequest(code : number, data : any, reply : any, options : any) : boolean {
        if (code === CODE_CONNECT_REMOTE) {
            let x = data.readInt();
            let y = data.readInt();
            let touchType = data.readInt();
            if (this.mainAbilityStub == null) {
                console.info('ServiceAbility mainAbilityStub_ is null');
                return;
            }
            this.sendMessageToFa(x, y, touchType);
        } else if (code === CODE_CONNECT_LOCAL) {
            this.mainAbilityStub = data.readRemoteObject();
        }
        else {
            console.log("ServiceAbility unknown request code");
            return false;
        }
        return true;
    }
}

export default {
    onStart() {
        console.info('ServiceAbility onStart');
    },
    onStop() {
        console.info('ServiceAbility onStop');
    },
    onConnect(want) {
        console.log("ServiceAbility onConnect");
        try {
            let value = JSON.stringify(want);
        } catch (error) {
            console.log("ServiceAbility error:" + error);
        }
        return new FirstServiceAbilityStub("first ts service stub");
    },
    onDisconnect(want) {
        console.log("ServiceAbility onDisconnect");
        let value = JSON.stringify(want);
    },
    onCommand(want, startId) {
        console.info('ServiceAbility onCommand');
        let value = JSON.stringify(want);
    }
};