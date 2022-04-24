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
import Message from '../model/Message'
import Logger from '../model/Logger'
import SmsModel from '../model/SmsModel'
import DateTimeUtil from '../model/DateTimeUtil'

const TAG: string = '[SendMessage]'
const NO_SIM_STATE: number = -1

@Entry
@Component
struct SendMessage {
  @State clickable: boolean = false
  @State sendResult: string = ''
  @State serviceCenter: string = ''
  @State deliveryResult: string = ''
  @State content: string = ''
  @State messages: Array<Message> = []
  private slotId: number = 0
  private destinationPort: number= 1000
  private contact: Contact
  private smsModel: SmsModel = new SmsModel()
  private dateTimeUtil: DateTimeUtil = new DateTimeUtil()

  aboutToAppear() {
    this.contact = <Contact> router.getParams().contact
    Logger.info(`${TAG}, aboutToAppear name = ${this.contact.name} destinationHost = ${this.contact.destinationHost}`)
    this.getData()
  }

  async getData() {
    Logger.info(`${TAG}, getData start`)
    sms.getDefaultSmsSlotId((err, data) => {
      Logger.info(`${TAG}, getData getDefaultSmsSlotId: err = ${JSON.stringify(err)} data = ${JSON.stringify(data)}`)
      if (err !== undefined) {
        this.clickable = false
        if (err.code === NO_SIM_STATE) {
          this.showDialog()
        }
      } else {
        this.clickable = true
        this.slotId = data
        sms.getSmscAddr(this.slotId, (err, data) => {
          this.serviceCenter = data
          Logger.info(`${TAG}, getData getSmscAddr: err = ${JSON.stringify(err)} data = ${JSON.stringify(data)}`)
        })
      }
      Logger.info(`${TAG}, getData getDefaultSmsSlotId: clickable = ${this.clickable}`)
    })

    this.smsModel.createMessage()
    Logger.info(`${TAG}, getData end`)
  }

  showDialog() {
    AlertDialog.show(
      {
        title: $r('app.string.no_sim'),
        message: $r('app.string.insert_sim'),
        confirm: {
          value: $r('app.string.determine'),
          action: () => {
            Logger.info(`${TAG}, insert sim AlertDialog confirm`)
          }
        }
      }
    )
  }

  sendMessage() {
    this.smsModel.sendMessage(this.slotId, this.content, this.contact.destinationHost, this.serviceCenter, this.destinationPort,
      (err, data) => {
        Logger.info(`${TAG}, sendCallback--- data = ${JSON.stringify(data)} err = ${JSON.stringify(err)}`)
        if (err !== undefined) {
          this.sendResult = 'error'
          Logger.info(`${TAG}, sendCallback--- error`)
        } else {
          if (data.result === sms.SendSmsResult.SEND_SMS_SUCCESS) {
            this.sendResult = ''
            Logger.info(`${TAG}, sendCallback--- success`)
          } else {
            this.sendResult = 'fail'
            Logger.info(`${TAG}, sendCallback--- fail`)
          }
        }
        this.messages.push(new Message(this.content, this.sendResult))
        this.content = ''
        Logger.info(`${TAG}, sendCallback--- push message`)
      },
      (err, data) => {
        Logger.info(`${TAG}, deliveryCallback--- data = ${JSON.stringify(data)} err = ${JSON.stringify(err)}`)
        if (err !== undefined) {
          this.sendResult = 'error'
          Logger.info(`${TAG}, deliveryCallback--- error`)
        } else {
          this.sendResult = ''
          Logger.info(`${TAG}, deliveryCallback--- success`)
        }
      })
    Logger.info(`${TAG}, onClick sendMessage done ${JSON.stringify(this.messages)}`)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Row() {
        Image($r('app.media.back'))
          .width(150)
          .height(50)
          .margin({ left: 20 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
        Column() {
          Text(`${this.contact.name}`)
            .height(40)
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
      .height(70)
      .margin({ bottom: 10 })

      Scroll() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
          ForEach(this.messages, (item) => {
            Row() {
              Text(`${item.sendResult}`)
                .fontSize(20)
                .fontColor(Color.Red)
                .margin({ top: 20, right: 10 })
                .textAlign(TextAlign.Center)
              Column() {
                Text(`${this.dateTimeUtil.getDate()}  ${this.dateTimeUtil.getTime()}`)
                  .width('70%')
                  .fontSize(20)
                  .textAlign(TextAlign.End)
                  .margin({ top: 20 })
                Text(`${item.content}`)
                  .width('70%')
                  .fontSize(25)
                  .padding({ top: 20, bottom: 20, left: 20 })
                  .borderRadius(20)
                  .backgroundColor('#6bcfcdce')
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .alignSelf(ItemAlign.End)
            }
          }, item => item.content)
        }
      }
      .height('70%')
      .width('100%')
      .layoutWeight(1)


      Row() {
        TextArea({ placeholder: $r('app.string.message'), text: this.content })
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
            Logger.info(`${TAG}, onClick sendMessage`)
            if (this.content === '') {
              Logger.info(`${TAG}, onClick this.content===''`)
              this.clickable = false
              AlertDialog.show(
                {
                  title: $r('app.string.no_message'),
                  message: $r('app.string.input_message'),
                  confirm: {
                    value: $r('app.string.determine'),
                    action: () => {
                      Logger.info(`${TAG}, input message AlertDialog confirm`)
                    }
                  }
                }
              )
            } else {
              if (this.clickable) {
                this.sendMessage()
              } else {
                this.showDialog()
              }
            }
          })
      }
      .height(60)
    }
    .width('100%')
    .height('100%')
  }
}