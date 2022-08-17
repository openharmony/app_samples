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

import Logger from '../data/Logger'

const TAG: string = 'NewContact'

@Component
export struct NewContact {
  @Link name: string
  @Link email: string
  @Link nickName: string
  @Link phoneNumber: string
  @Link postalAddress: string

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Image($r('app.media.touxiang'))
        .width(76)
        .height(74)
        .margin({ top: 52 })
        .objectFit(ImageFit.Contain)

      Text($r('app.string.save'))
        .fontSize(22)
        .margin({ top: 22, bottom: 32 })

      this.newContact($r('app.string.name'), $r('app.media.name'))
      this.newContact($r('app.string.address'), $r('app.media.address'))
      this.newContact($r('app.string.phone'), $r('app.media.phone'))
      this.newContact($r('app.string.email'), $r('app.media.email'))
      this.newContact($r('app.string.note'), $r('app.media.nickname'))
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  newContact(editText: Resource, img: Resource) {
    Row() {
      Image(img)
        .width(32)
        .height(32)
        .margin({ left: 16, right: 18 })
        .objectFit(ImageFit.Contain)

      TextInput({ placeholder: editText })
        .width('80%')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(Color.White)
        .placeholderFont({ size: 24, weight: 450, family: 'cursive', style: FontStyle.Normal })
        .onChange((value: string) => {
          switch (JSON.stringify(editText)) {
            case JSON.stringify($r('app.string.name')):
              this.name = value
              break
            case JSON.stringify($r('app.string.note')):
              this.nickName = value
              break
            case JSON.stringify($r('app.string.phone')):
              this.phoneNumber = value
              break
            case JSON.stringify($r('app.string.email')):
              this.email = value
              break
            case JSON.stringify($r('app.string.address')):
              this.postalAddress = value
              break
            default:
              break
          }
          Logger.info(TAG, `this name is ${this.name} this number is ${this.phoneNumber}`)
        })
    }
    .margin({ bottom: 16 })
    .width('94%')
    .height(84)
    .borderRadius(32)
    .backgroundColor(Color.White)
  }
}