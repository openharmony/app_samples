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

import fileio from '@ohos.fileio'
import router from '@ohos.router'
import prompt from '@ohos.prompt'
import contact from '@ohos.contact'
import featureAbility from '@ohos.ability.featureAbility'
import Logger from '../data/Logger'

const TAG: string = '[Setting]'

@Entry
@Component
export struct Setting {
  @State contacts: contact.Contact[] = []

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(32)
          .height(32)
          .margin({ left: 32, top: 32 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
      }
      .width('100%')

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {

        Button($r('app.string.add_contact'))
          .margin(10)
          .width('48%')
          .height(48)
          .fontSize(20)
          .onClick(() => {
            router.push({
              url: 'pages/AddContact'
            })
          })

        Button($r('app.string.import_file'))
          .margin(10)
          .width('48%')
          .height(48)
          .fontSize(20)
          .onClick(() => {
          })

        Button($r('app.string.export_file'))
          .margin(10)
          .width('48%')
          .height(48)
          .fontSize(20)
          .onClick(async () => {
            await this.writeContact()
            prompt.showToast({
              message: 'Exporting the file Successfully',
              duration: 1500 // 提示弹窗持续时间，单位ms
            })
          })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#ffffffff')
    }
  }

  async aboutToAppear() {
    this.contacts = await contact.queryContacts()
    Logger.info(TAG, `this contacts is ${(JSON.stringify(this.contacts))}`)
  }

  async writeContact() {
    let context = featureAbility.getContext()
    let path = await context.getFilesDir()
    let fd = fileio.openSync(`${path}/Contact.json`, 0o2 | 0o100, 0o666)
    for (let i = 0; i < this.contacts.length; i++) {
      fileio.writeSync(fd, `${this.contacts[i]}\n`)
      fileio.closeSync(fd)
    }
  }

  async readContact() {

  }
}
