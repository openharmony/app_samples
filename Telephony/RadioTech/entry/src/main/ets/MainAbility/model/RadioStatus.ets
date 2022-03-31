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

import sim from '@ohos.telephony.sim'
import radio from '@ohos.telephony.radio'

const TAG = '[RadioStatus]'

export class RadioStatus {
  constructor() {
  }

  getSimSpn(slotId, callback) {
    sim.getSimSpn(slotId, (err, data) => {
      console.log(`${TAG} SimSpn callback: err->${(err)}, data->${data}`)
      this.setCallback(callback, data)
    })
  }

  getRadioTech(slotId, callback) {
    radio.getRadioTech(slotId, (err, data) => {
      console.log(`${TAG} RadioTech callback: err->${JSON.stringify(err)}, data->${JSON.stringify(data)}`)
      callback(JSON.stringify(data))
    })
  }

  getSignalInformation(slotId, callback) {
    radio.getSignalInformation(slotId, (err, data) => {
      console.log(`${TAG} SignalInformation callback: err->${JSON.stringify(err)}, data->${JSON.stringify(data)}`)
      callback(JSON.stringify(data))
    })
  }

  getNetworkSelectionMode(slotId, callback) {
    radio.getNetworkSelectionMode(slotId, (err, data) => {
      console.log(`${TAG} NetworkSelectionMode callback: err->${err}, data->${data}`)
      this.setCallback(callback, data)
    })
  }

  getISOCountryCodeForNetwork(slotId, callback) {
    radio.getISOCountryCodeForNetwork(slotId, (err, data) => {
      console.log(`${TAG} ISOCountryCode callback: err->${err}, data->${data}`)
      if (data == '') {
        callback('not available')
      } else {
        callback(data)
      }
    })
  }

  getNetworkState(callback) {
    radio.getNetworkState((err, data) => {
      console.log(`${TAG} NetworkState callback: err->${JSON.stringify(err)}, data->${JSON.stringify(data)}`)
      if (typeof (JSON.stringify(data)) == `undefined`) {
        callback('not available')
      } else {
        const networkState: string = `longOperatorName:${JSON.stringify(data.longOperatorName)}\n` +
        `shortOperatorName:${JSON.stringify(data.shortOperatorName)}\n` +
        `plmnNumeric:${JSON.stringify(data.plmnNumeric)}\n` +
        `isRoaming:${JSON.stringify(data.isRoaming)}\n` +
        `regState:${JSON.stringify(data.regState)}\n` +
        `nsaState:${JSON.stringify(data.nsaState)}\n` +
        `isCaActive:${JSON.stringify(data.isCaActive)}\n` +
        `isEmergency:${JSON.stringify(data.isEmergency)}\n`
        callback(networkState)
      }
    })
  }

  getRadioOn(callback) {
    radio.isRadioOn((err, data) => {
      console.log(`${TAG} IsRadioOn callback: err->${err}, data->${data}`)
      this.setCallback(callback, data)
    })
  }

  setCallback(callback, data) {
    if (typeof (JSON.stringify(data)) == `undefined`) {
      callback('not available')
    } else {
      callback(data)
    }
  }
}