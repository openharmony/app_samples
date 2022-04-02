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

import Ability from '@ohos.application.Ability'
import emitter from '@ohos.events.emitter'
import MySequenceable from '../model/MySequenceable'
import Logger from '../model/Logger'

const TAG: string = '[CalleeAbility]'
const MSG_SEND_METHOD: string = 'CallSendMsg'
const EVENT_ID: number = 1000

function sendMsgCallback(data) {
    Logger.log(TAG, 'CalleeSortFunc called')

    // 获取Caller发送的序列化数据
    let receivedData = new MySequenceable(0, '')
    data.readSequenceable(receivedData)
    Logger.log(TAG, `receiveData[${receivedData.num}, ${receivedData.str}]`)

    // 更新CalleeAbility界面显示的数据
    var innerEvent = { eventId: EVENT_ID }
    var eventData = {
        data: {
            receivedMsg: receivedData.str
        }
    }
    emitter.emit(innerEvent, eventData)

    // 返回序列化数据result给Caller
    return new MySequenceable(receivedData.num + 1, `send ${receivedData.str} succeed`)
}

export default class CalleeAbility extends Ability {
    onCreate(want, launchParam) {
        Logger.log(TAG, 'onCreate')

        try {
            this.callee.on(MSG_SEND_METHOD, sendMsgCallback)
        } catch (error) {
            Logger.error(TAG, `${MSG_SEND_METHOD} register failed with error ${JSON.stringify(error)}`)
        }
    }

    onDestroy() {
        Logger.log(TAG, 'onDestroy')

        try {
            this.callee.off(MSG_SEND_METHOD)
        } catch (error) {
            console.error(TAG, `${MSG_SEND_METHOD} unregister failed with error ${JSON.stringify(error)}`)
        }
    }

    onWindowStageCreate(windowStage) {
        Logger.log(TAG, "onWindowStageCreate")

        windowStage.loadContent("pages/second").then((data)=> {
            Logger.info(TAG, `load content succeed with data ${JSON.stringify(data)}`)
        }).catch((error)=>{
            Logger.error(TAG, `load content failed with error ${JSON.stringify(error)}`)
        })
    }

    onWindowStageDestroy() {
        Logger.log(TAG, "onWindowStageDestroy")
    }

    onForeground() {
        Logger.log(TAG, "onForeground")
    }

    onBackground() {
        Logger.log(TAG, "onBackground")
    }
};
