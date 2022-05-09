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
import prompt from '@ohos.prompt'
import featureAbility from '@ohos.ability.featureAbility'
import rpc from "@ohos.rpc"

const localDeviceId: string = ''
let mRemote: rpc.IRemoteObject = null
let connection: number = -1
let TAG: string = '[ServiceAbility.ServiceModel]'

export class ServiceModel {
    private sendMessage: string = ''

    onConnectCallback(element, remote) {
        console.log(`${TAG}onConnectLocalService onConnectDone element:${element}`)
        console.log(`${TAG}onConnectLocalService onConnectDone remote:${remote}`)
        mRemote = remote
        if (mRemote === null) {
            prompt.showToast({
                message: 'onConnectLocalService not connected yet'
            })
            return
        }
        prompt.showToast({
            message: 'connect service success',
        })
    }

    onDisconnectCallback(element) {
        console.log(`${TAG}onConnectLocalService onDisconnectDone element:${element}`)
    }

    onFailedCallback(code) {
        console.log(`${TAG}onConnectLocalService onFailed errCode:${code}`)
        prompt.showToast({
            message: `onConnectLocalService onFailed:${code}`
        })
    }

    connectService() {
        console.log(`${TAG} onCconnectService begin`)
        connection = featureAbility.connectAbility(
            {
                deviceId: localDeviceId,
                bundleName: 'ohos.samples.etsserviceability',
                abilityName: 'ohos.samples.etsserviceability.ServiceAbility',
            },
            {
                onConnect: this.onConnectCallback,
                onDisconnect: this.onDisconnectCallback,
                onFailed: this.onFailedCallback,
            },
        )
    }

    disconnectService() {
        console.log(`${TAG} onDisconnectService begin`)
        mRemote = null
        if (connection === -1) {
            prompt.showToast({
                message: 'onDisconnectService not connected yet'
            })
            return
        }
        featureAbility.disconnectAbility(connection)
        connection = -1
        prompt.showToast({
            message: 'onDisconnectService disconnect done'
        })
    }

    getRemoteObject(){
        return mRemote
    }
}