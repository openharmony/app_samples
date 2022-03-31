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

import rpc from "@ohos.rpc"

const TAG: string = '[ServiceAbility]'

class FirstServiceAbilityStub extends rpc.RemoteObject {
    constructor(des: any) {
        if (typeof des === 'string') {
            super(des)
        } else {
            return
        }
    }

    onRemoteRequest(code: number, data: any, reply: any, option: any) {
        console.log(`${TAG}onRemoteRequest called`)
        if (code === 1) {
            let string = data.readString()
            console.log(`${TAG} string=${string}`)
            let result = Array.from(string).sort().join('')
            console.log(`${TAG} result=${result}`)
            reply.writeString(result)
        } else {
            console.log(`${TAG} unknown request code`)
        }
        return true;
    }
}

export default {
    onStart() {
        console.info(`${TAG} onStart`)
    },
    onStop() {
        console.info(`${TAG} onStop`)
    },
    onConnect(want) {
        console.log(`${TAG} onConnect, want:${JSON.stringify(want)}`)
        return new FirstServiceAbilityStub("first ts service stub")
    },
    onDisconnect(want) {
        console.log(`${TAG} onDisconnect, want:${JSON.stringify(want)}`)
    },
    onCommand(want, startId) {
        console.log(`${TAG} onCommand, want:${JSON.stringify(want)},startId:${startId}`)
    }
}