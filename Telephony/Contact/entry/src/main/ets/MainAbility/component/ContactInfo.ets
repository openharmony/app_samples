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

import router from '@ohos.router'
import contact from '@ohos.contact'
import Logger from '../data/Logger'

const TAG: string = '[ContactInfo]'

@Preview
@Component
export struct ContactInfo {
  @State phone: string = ''
  @State email: string = ''
  @State address: string = ''
  private contact: contact.Contact

  build() {
    Column() {
      Column() {
        Text(this.contact.name.fullName.substring(0, 1)
          .toUpperCase())
          //Text('l')
          .width(130)
          .height(130)
          .fontSize(30)
          .fontColor('#ffffff')
          .borderRadius(100)
          .margin({ top: 62, bottom: 22 })
          .textAlign(TextAlign.Center)
          .backgroundColor('#B6C5D1')

        Text(this.contact.name.fullName)
          //Text('qazwsx')
          .fontSize(32)
          .margin({ bottom: 16 })

        Column() {
          Row() {
            Text(this.contact.phoneNumbers[0].phoneNumber)
              //Text('12649643435')
              .width('50%')
              .fontSize(22)
              .margin({ left: 16 })

            Blank()

            Image($r('app.media.phone2'))
              .width(32)
              .height(32)
              .margin({ right: 24 })
              .objectFit(ImageFit.Contain)

            Image($r('app.media.note'))
              .width(32)
              .height(32)
              .margin({ right: 24 })
              .objectFit(ImageFit.Contain)
          }
          .width('100%')
          .height('50%')

          Divider()
            .width('90%')
            .strokeWidth(1)
            .color('#ffefefef')

          Row() {
            Column() {
              Text($r('app.string.defaults'))
                .fontSize(22)
                .margin({ left: 16 })
              Text($r('app.string.phone_ring'))
                .fontSize(20)
                .fontColor(Color.Gray)
                .margin({ left: 16 })
            }
            .alignItems(HorizontalAlign.Start)
            .width('30%')

            Blank()
              .width('52%')

            Image($r('app.media.right'))
              .width(16)
              .height(32)
              .margin({ right: 24 })
          }
          .width('100%')
          .height('50%')
        }
        .width('90%')
        .height(178)
        .borderRadius(30)
        .backgroundColor(Color.White)
      }

      Blank()

      Divider()
        .strokeWidth(0.65)
        .color('#000000')
        .opacity(0.05)

      Row() {
        Column() {
          Image($r('app.media.editor'))
            .width(32)
            .height(32)
            .margin({ top: 6 })
            .objectFit(ImageFit.Contain)

          Text($r('app.string.editor'))
            .fontSize(14)
            .fontColor(Color.Black)
            .margin(4)
            .borderRadius(10)
            .onClick(() => {
              router.push({
                url: 'pages/EditContact',
                params: { data: this.contact }
              })
            })
        }
        .layoutWeight(1)

        Column() {
          Image($r('app.media.delete'))
            .width(32)
            .height(32)
            .margin({ top: 6 })
            .objectFit(ImageFit.Contain)


          Text($r('app.string.delete'))
            .fontSize(14)
            .fontColor(Color.Black)
            .borderRadius(10)
            .onClick(async () => {
              AlertDialog.show(
                {
                  title: '警告',
                  message: '您正在删除该联系人，请确认是否删除',
                  primaryButton: {
                    value: '确认',
                    action: async () => {
                      try {
                        await contact.deleteContact(this.contact.key)
                        Logger.info(TAG, `delete contact successed`)
                      } catch (err) {
                        Logger.info(TAG, `delete contact failed, err = ${JSON.stringify(err)}`)
                      }
                      router.back({
                        url: 'pages/Index'
                      })
                    }
                  },
                  secondaryButton: {
                    value: '取消',
                    action: () => {
                      Logger.info(TAG, `AlertDialog enter`)
                    }
                  },
                  cancel: () => {
                    Logger.info(TAG, `AlertDialog close`)
                  }
                })
            })
        }
        .layoutWeight(1)
      }
      .width('100%')
      .height('20%')
      .margin({ bottom: 10 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }

  aboutToAppear() {
    try {
      this.phone = this.contact.phoneNumbers[0].phoneNumber
    } catch (err) {
      this.phone = '未填写'
    }
    try {
      this.email = this.contact.emails[0].email
    } catch (err) {
      this.email = '未填写'
    }
    try {
      this.address = this.contact.postalAddresses[0].postalAddress
    } catch (err) {
      this.address = '未填写'
    }
  }
}