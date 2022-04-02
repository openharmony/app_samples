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

import MySequenceable from '../model/MySequenceable'
import Logger from '../model/Logger'

const TAG: string = '[ButtonClickModel]'

let context = globalThis.mainAbilityContext
let dmClass = globalThis.dmClass
const MSG_SEND_METHOD: string = 'CallSendMsg'

function getRemoteDeviceId() {
    Logger.log(TAG, 'getRemoteDeviceId start');
    if (typeof dmClass === 'object' && dmClass != null) {
        let list = dmClass.getTrustedDeviceListSync();
        if (!list || !list.length) {
            Logger.log(TAG, 'getRemoteDeviceId err: list is null');
            return;
        }
        Logger.log(TAG, `MainAbility onButtonClick getRemoteDeviceId success: ${(list[0].deviceId).str}`);
        return list[0].deviceId;
    } else {
        Logger.log(TAG, 'MainAbility onButtonClick getRemoteDeviceId err: dmClass is null');
    }
}

export default class ButtonClickModel {
    caller = undefined
    startingValue: number = 1

    // 在相同设备启动另一个Ability，CalleeAbility被调度到前台
    async onButtonStartSecondAbility() {
        try {
            await context.startAbility({
                bundleName: "ohos.samples.CallApplication",
                abilityName: "CalleeAbility"
            })
            Logger.log(TAG, 'start callee ability succeed')
        } catch (error) {
            Logger.error(TAG, `start callee ability failed with ${error.code}`)
        }
    }

    // 跨设备启动一个Ability
    async onButtonStartRemoteAbility() {
        try {
            await context.startAbility({
                deviceId: getRemoteDeviceId(),
                bundleName: "ohos.samples.CallApplication",
                abilityName: "MainAbility"
            })
            Logger.log(TAG, 'start remote ability succeed')
        } catch (error) {
            Logger.error(TAG, `start remote ability failed with ${error.code}`)
        }
    }

    // 注册caller的release监听
    private regOnRelease(caller) {
        try {
            caller.onRelease((msg) => {
                Logger.log(TAG, `caller onRelease is called ${msg}`)
            })
            Logger.log(TAG, 'caller register OnRelease succeed')
        } catch (error) {
            Logger.log(TAG, `caller register OnRelease failed with ${error}`)
        }
    }

    // 以call调用的形式启动CalleeAbility，获取caller通信接口。若CalleeAbility未运行，会将CallAbility拉起并在后台运行。
    async onButtonGetCaller() {
        try {
            this.caller = await context.startAbilityByCall({
                bundleName: 'ohos.samples.CallApplication',
                abilityName: 'CalleeAbility'
            })
            if (this.caller === undefined) {
                Logger.error(TAG, 'get caller failed')
                return
            }
            Logger.log(TAG, 'get caller success')
            this.regOnRelease(this.caller)
        } catch (error) {
            Logger.error(TAG, `get caller failed with ${error}`)
        }
    }

    // 以call调用的形式跨设备启动CalleeAbility，获取caller通信接口。若CalleeAbility未运行，会将CallAbility拉起并在后台运行。
    async onButtonGetRemoteCaller() {
        try {
            this.caller = await context.startAbilityByCall({
                deviceId: getRemoteDeviceId(),
                bundleName: 'ohos.samples.CallApplication',
                abilityName: 'CalleeAbility'
            })
            if (this.caller === undefined) {
                Logger.error(TAG, 'get remote caller failed')
                return
            }
            Logger.log(TAG, 'get remote caller success')
            this.regOnRelease(this.caller)
        } catch (error) {
            Logger.error(TAG, `get remote caller failed with ${error}`)
        }
    }

    // call调用，使用callee被调用端的'CalleeSendMsg'方法，发送序列化数据
    async onButtonCallWithResult(originMsg, backMsg) {
        if (this.caller === undefined) {
            Logger.error(TAG, `caller is ${this.caller}`)
            return
        }

        try {
            let msg = new MySequenceable(this.startingValue, originMsg)
            const data = await this.caller.callWithResult(MSG_SEND_METHOD, msg)
            Logger.log(TAG, 'caller callWithResult succeed')

            let result = new MySequenceable(0, '')
            data.readSequenceable(result)
            backMsg(result.str)
            Logger.log(TAG, `caller result is [${result.num}, ${result.str}]`)
        } catch (error) {
            Logger.error(TAG, `caller callWithResult failed with ${error}`)
        }
    }

    // 释放caller通信接口
    onButtonRelease() {
        if (this.caller === undefined) {
            Logger.error(TAG, `caller is ${this.caller}`)
            return
        }

        try {
            this.caller.release()
            this.caller = undefined
            Logger.log(TAG, 'caller release succeed')
        } catch (error) {
            Logger.error(TAG, `caller release failed with ${error}`)
        }
    }
}