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

import prompt from '@system.prompt'
import featureAbility from '@ohos.ability.featureAbility'
import rpc from "@ohos.rpc"

const localDeviceId: string = ''
let mRemote: any = null
let connection: number = -1
let TAG: string = '[ServiceAbility.ServiceModel]'

export class ServiceModel {
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

  async sortString(sortString, callback) {
    console.log(`${TAG} sortString begin`)
    if (mRemote === null) {
      prompt.showToast({
        message: 'please connect service'
      })
    }
    if (sortString.length === 0) {
      prompt.showToast({
        message: 'please input a string'
      })
    }
    let option = new rpc.MessageOption()
    let data = new rpc.MessageParcel()
    let reply = new rpc.MessageParcel()
    data.writeString(sortString)
    await mRemote.sendRequest(1, data, reply, option)
    let msg = reply.readString()
    callback(msg)
  }
}