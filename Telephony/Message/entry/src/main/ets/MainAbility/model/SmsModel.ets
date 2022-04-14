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

import sms from '@ohos.telephony.sms'
import Logger from '../model/Logger'

const TAG: string = `[SmsModel]`

export default class SmsModel {
  async createMessage() {
    const specification = '3gpp'
    const pdu = [0x08, 0x91] // 以数组的形式显示协议数据单元（PDU），类型为number
    const shortMessage = await sms.createMessage(pdu, specification)
    Logger.info(`${TAG}, createMessageCallback: shortMessage = ${JSON.stringify(shortMessage)}`)
    return shortMessage
  }

  sendMessage(slotId, content, destinationHost, serviceCenter, destinationPort, handleSend, handleDelivery) {
    Logger.info(`${TAG}, sendMessage start ${slotId} ${content} ${destinationHost} ${serviceCenter} ${destinationPort}`)
    const options =
      {
        slotId: slotId,
        content: content,
        destinationHost: destinationHost,
        serviceCenter: serviceCenter,
        destinationPort: destinationPort,
        sendCallback(err, data) {
          Logger.info(`${TAG}, sendCallback: data = ${JSON.stringify(data)} err = ${JSON.stringify(err)}`)
          handleSend(err, data)
        },
        deliveryCallback(err, data) {
          Logger.info(`${TAG}, deliveryCallback: data = ${JSON.stringify(data)} err = ${JSON.stringify(err)}`)
          handleDelivery(err, data)
        }
      }

    sms.sendMessage(options)
    Logger.info(`${TAG}, sendMessage end`)
  }

  async getDefaultSmsSlotId() {
    const defaultSmsSlotId = await sms.getDefaultSmsSlotId()
    Logger.info(`${TAG}, getDefaultSmsSlotId: defaultSmsSlotId = ${defaultSmsSlotId}`)
    return defaultSmsSlotId
  }

  async setSmscAddr(slotId, smscAddr) {
    const serviceCenter = await sms.setSmscAddr(slotId, smscAddr)
    Logger.info(`${TAG}, setSmscAddr: serviceCenter = ${JSON.stringify(serviceCenter)}`)
    return serviceCenter
  }

  async getSmscAddr(slotId) {
    const serviceCenter = await sms.getSmscAddr(slotId)
    Logger.info(`${TAG}, getSmscAddr: serviceCenter = ${JSON.stringify(serviceCenter)}`)
    return serviceCenter
  }
}


