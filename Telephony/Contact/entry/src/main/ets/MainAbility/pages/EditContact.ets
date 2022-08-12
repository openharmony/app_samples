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
import contact from '@ohos.contact'
import Logger from '../data/Logger'
import { UpdateContact } from '../component/UpdateContact'

const TAG: string = '[EditContact]'

@Entry
@Component
struct EditContact {
  private contact = <contact.Contact> router.getParams()['data']

  build() {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.no'))
            .width('20%')
            .height('40%')
            .margin({ right: '2%' })
            .objectFit(ImageFit.Contain)

          Text($r('app.string.editor_contact'))
            .fontSize(18)
            .textAlign(TextAlign.End)
            .fontColor(Color.White)
        }
        .layoutWeight(1)
        .onClick(() => {
          router.back({
            url: 'pages/Index'
          })
        })

        Blank()

        Image($r('app.media.yes'))
          .width('10%')
          .height('10%')
          .objectFit(ImageFit.Contain)
          .onClick(async () => {
            try {
              let id = await contact.addContact({
                name: { fullName: this.contact.name.fullName },
                nickName: { nickName: this.contact.nickName.nickName },
                phoneNumbers: [{ phoneNumber: this.contact.phoneNumbers[0].phoneNumber }],
                emails: [{ email: this.contact.emails[0].email }],
                postalAddresses: [{ postalAddress: this.contact.postalAddresses[0].postalAddress }]
              })
              Logger.info(TAG, `id = ${id}`)
            } catch (err) {
              Logger.info(TAG, `edit contact err = ${JSON.stringify(err)}`)
            }
            router.back({
              url: 'pages/Index'
            })
          })
      }
      .height('6%')
      .width('100%')
      .padding({ left: 16 })
      .backgroundColor('#0D9FFB')
      .constraintSize({ minHeight: 50 })

      UpdateContact({ contact: $contact })
    }
  }
}