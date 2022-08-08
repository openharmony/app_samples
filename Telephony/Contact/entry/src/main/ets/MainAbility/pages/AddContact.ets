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
import { NewContact } from '../component/NewContact'

const TAG: string = '[AddContact]'

@Entry
@Component
struct AddContact {
  @State name: string = ''
  @State email: string = ''
  @State nickName: string = ''
  @State phoneNumber: string = ''
  @State postalAddress: string = ''

  build() {
    Column() {
      Row() {
        Image($r('app.media.no'))
          .width(32)
          .height(32)
          .margin({ left: 32, right: 22 })
          .objectFit(ImageFit.Contain)

        Text($r('app.string.newContact'))
          .fontSize(26)
          .fontWeight(400)
          .textAlign(TextAlign.End)
          .fontColor(Color.Black)

          .onClick(() => {
            router.back({
              url: 'pages/Index'
            })
          })

        Blank()

        Image($r('app.media.yes'))
          .width(32)
          .height(32)
          .margin({ right: 32 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            Logger.info(TAG, `onClick start`)
            let contacts = {
              name: { fullName: this.name },
              nickName: { nickName: this.nickName },
              phoneNumbers: [{ phoneNumber: this.phoneNumber }],
              emails: [{ email: this.email }],
              postalAddresses: [{ postalAddress: this.postalAddress }]
            }
            Logger.info(TAG, `contacts = ${JSON.stringify(contacts)}`)
            try {
              contact.addContact(contacts, (id) => {
                Logger.info(TAG, `id = ${id}`)
              })
              router.back({
                url: 'pages/Index'
              })
            } catch (error) {
              Logger.info(TAG, `contact err = ${JSON.stringify(error)}`)
            }
          })
      }
      .height('6%')
      .width('100%')
      .margin({ top: 32 })
      .constraintSize({ minHeight: 50 })

      NewContact({
        name: $name,
        email: $email,
        postalAddress: $postalAddress,
        nickName: $nickName,
        phoneNumber: $phoneNumber
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff5f5f5')
  }
}