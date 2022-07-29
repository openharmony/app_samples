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

import Logger from './Logger'
import data from '@ohos.telephony.data'

const TAG: string = '[NetworkMobile]'

export class NetworkMobile {
  async getDefaultCellularDataSlotId() {
    let slotId = -1
    try {
      slotId = await data.getDefaultCellularDataSlotId()
      Logger.info(TAG, `getDefaultCellularDataSlotId slotId = ${slotId}`)
    } catch (err) {
      Logger.info(TAG, `getDefaultCellularDataSlotId failed err is ${JSON.stringify(err)}`)
    }
    return slotId
  }

  async isCellularDataEnabled() {
    let dataEnabled = undefined
    try {
      dataEnabled = await data.isCellularDataEnabled()
      Logger.info(TAG, `isCellularDataEnabled dataEnabled = ${dataEnabled}`)
    } catch (err) {
      Logger.info(TAG, `isCellularDataEnabled failed err is ${JSON.stringify(err)}`)
    }
    return dataEnabled
  }

  async isCellularDataRoamingEnabled(slotId: number) {
    let dataRoamingEnabled = undefined
    try {
      dataRoamingEnabled = await data.isCellularDataRoamingEnabled(slotId)
      Logger.info(TAG, `isCellularDataRoamingEnabled dataRoamingEnabled = ${dataRoamingEnabled}`)
    } catch (err) {
      Logger.info(TAG, `isCellularDataRoamingEnabled failed err is ${JSON.stringify(err)}`)
    }
    return dataRoamingEnabled
  }
}