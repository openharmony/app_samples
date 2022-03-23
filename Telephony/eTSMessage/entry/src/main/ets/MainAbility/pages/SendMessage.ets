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

import router from '@system.router'
import sms from '@ohos.telephony.sms'
import Contact from '../model/Contact'
import HiLog from '../model/HiLogUtil'
import SmsModel from '../model/SmsModel'
import DateTimeUtil from '../model/DateTimeUtil'

const TAG = '[SendMessage]'

@Entry
@Component
struct SendMessage {
  @State sendResult: string = ''
  @State serviceCenter: string = ''
  @State messages: Array<string> = []
  @State content: string= 'test send message'
  private slotId: number= 0
  private destinationPort: number= 1000
  private contact: Contact = null
  private smsModel: SmsModel = new SmsModel()
  private dateTimeUtil: DateTimeUtil = new DateTimeUtil()

  aboutToAppear() {
    this.contact = router.getParams().contact
    HiLog.info(TAG, `aboutToAppear name = ${this.contact.name}, destinationHost = ${this.contact.destinationHost}`)
    this.smsModel.getDefaultSmsSlotId().then((defaultSmsSlotId) => {
      this.slotId = defaultSmsSlotId
      this.smsModel.getSmscAddr(this.slotId).then((serviceCenter) => {
        this.serviceCenter = serviceCenter
      })
    })

    this.smsModel.createMessage()
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Row() {
        Image($r('app.media.back'))
          .width(40)
          .height(40)
          .margin({ left: 10 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
        Column() {
          Text(`${this.contact.name}`)
            .height(30)
            .fontSize(22)
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .margin({ right: 50 })
          Text(`${this.contact.destinationHost}`)
            .height(20)
            .fontSize(20)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.Center)
            .margin({ right: 50 })
        }
        .layoutWeight(1)

      }
      .height(60)
      .margin({ bottom: 10 })

      Scroll() {
        Column() {
          ForEach(this.messages, (item) => {
            Row() {
              Text(`${this.sendResult}`)
                .fontSize(20)
                .fontColor(Color.Red)
                .margin({ top: 20, right: 10 })
                .textAlign(TextAlign.Center)
              Column() {
                Text(`${this.dateTimeUtil.getDate()}  ${this.dateTimeUtil.getTime()}`)
                  .width('80%')
                  .fontSize(20)
                  .textAlign(TextAlign.End)
                  .margin({ top: 20 })
                Text(`${item}`)
                  .width('80%')
                  .fontSize(25)
                  .padding({ top: 20, bottom: 20, left: 20 })
                  .borderRadius(20)
                  .backgroundColor('#6bcfcdce')
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }

            }
          }, item => item)
        }
        .margin({ left: 40, right: 10, bottom: 10 })
      }
      .height('70%')
      .width('100%')
      .layoutWeight(1)


      Row() {
        TextArea({ placeholder: $r('app.string.message') })
          .placeholderColor('#92958C')
          .placeholderFont({ size: 20, weight: 100, family: 'cursive', style: FontStyle.Normal })
          .textAlign(TextAlign.Start)
          .width('80%')
          .height(50)
          .fontSize(20)
          .margin({ left: 10 })
          .fontWeight(FontWeight.Bold)
          .fontFamily('sans-serif')
          .onChange((value: string) => {
            this.content = value
          })
        Image($r('app.media.arrow'))
          .width(50)
          .height(50)
          .margin({ right: 10 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            HiLog.info(TAG, `onClick sendMessage`)
            this.messages.push(this.content)
            this.smsModel.sendMessage(this.slotId, this.content, this.contact.destinationHost, this.serviceCenter, this.destinationPort,
              (err, data) => {
                HiLog.info(TAG, `sendCallback--- data = ${JSON.stringify(data)},err = ${JSON.stringify(err)}`)
                if (err != undefined) {
                  this.sendResult = 'error'
                } else {
                  if (data.result == sms.SendSmsResult.SEND_SMS_SUCCESS) {
                    this.sendResult = ''
                  } else {
                    this.sendResult = 'fail'
                  }
                }
              },
              (err, data) => {
                HiLog.info(TAG, `deliveryCallback--- data = ${JSON.stringify(data)},err = ${JSON.stringify(err)}`)
                if (err != undefined) {
                  this.sendResult = 'error'
                } else {
                  if (data.result == sms.SendSmsResult.SEND_SMS_SUCCESS) {
                    this.sendResult = ''
                  } else {
                    this.sendResult = 'fail'
                  }
                }
              })
            HiLog.info(TAG, `onClick sendMessage done ${this.messages}`)
          })
      }
      .height(60)
    }
    .width('100%')
    .height('100%')
  }
}