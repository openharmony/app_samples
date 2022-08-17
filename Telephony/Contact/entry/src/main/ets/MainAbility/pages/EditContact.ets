// @ts-nocheck
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
import prompt from '@ohos.prompt'
import contact from '@ohos.contact'
import Logger from '../data/Logger'
import { UpdateContact } from '../component/UpdateContact'
import ContactModel from '../data/ContactModel'

const TAG: string = '[EditContact]'

@Entry
@Component
struct EditContact {
  @State contact: contact.Contact = <contact.Contact> router.getParams()['data']

  build() {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.no'))
            .width(32)
            .height(32)
            .margin({ left: 32, right: 22 })
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.back()
            })
        }

        Text($r('app.string.editor_contact'))
          .fontSize(26)
          .fontWeight(400)
          .textAlign(TextAlign.End)
          .fontColor(Color.Black)

        Blank()

        Image($r('app.media.yes'))
          .width(32)
          .height(32)
          .margin({ right: 32 })
          .objectFit(ImageFit.Contain)
          .onClick(async () => {
            let test = /^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}/
            if (test.test(this.contact.phoneNumbers[0].phoneNumber) === true) {
              let id = await ContactModel.updateContact({
                name: { fullName: this.contact.name.fullName },
                nickName: { nickName: this.contact.nickName.nickName },
                phoneNumbers: [{ phoneNumber: this.contact.phoneNumbers[0].phoneNumber }],
                emails: [{ email: this.contact.emails[0].email }],
                postalAddresses: [{ postalAddress: this.contact.postalAddresses[0].postalAddress }]
              })
              router.push({
                url: 'pages/Index'
              })
            } else {
              prompt.showToast({
                message: 'Please input phone number.',
                duration: 2000,
              })
            }
          })
      }
      .height('6%')
      .width('100%')
      .margin({ top: 32 })
      .constraintSize({ minHeight: 50 })

      UpdateContact({ contact: $contact })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff5f5f5')
  }
}