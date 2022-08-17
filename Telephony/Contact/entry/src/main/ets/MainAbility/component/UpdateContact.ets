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

import contact from '@ohos.contact'
import resourceManager from '@ohos.resourceManager'

@Component
export struct UpdateContact {
  @State name: string = ''
  @State email: string = ''
  @State nickName: string = ''
  @State phoneNumber: string = ''
  @State postalAddress: string = ''
  @State nameText: string = ''
  @State emailText: string = ''
  @State nickNameText: string = ''
  @State phoneNumberText: string = ''
  @State postalAddressText: string = ''
  @Link contact: contact.Contact

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

      this.updateContact(`${this.nameText} ${this.name}`, $r('app.media.name'))
      this.updateContact(`${this.nickNameText} ${this.nickName}`, $r('app.media.nickname'))
      this.updateContact(`${this.phoneNumberText} ${this.phoneNumber}`, $r('app.media.phone'))
      this.updateContact(`${this.emailText} ${this.email}`, $r('app.media.email'))
      this.updateContact(`${this.postalAddressText} ${this.postalAddress}`, $r('app.media.address'))
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  updateContact(editText: string, img: Resource) {
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
        .placeholderFont({ size: 22, weight: 450, family: 'cursive', style: FontStyle.Normal })
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
        })
    }
    .margin({ bottom: 16 })
    .width('94%')
    .height(84)
    .borderRadius(32)
    .backgroundColor(Color.White)
  }

  async aboutToAppear() {
    let resource = await resourceManager.getResourceManager()
    this.nameText = await resource.getString($r('app.string.name').id)
    this.emailText = await resource.getString($r('app.string.email').id)
    this.nickNameText = await resource.getString($r('app.string.note').id)
    this.phoneNumberText = await resource.getString($r('app.string.phone').id)
    this.postalAddressText = await resource.getString($r('app.string.address').id)
    this.name = this.contact.name.fullName
    this.phoneNumber = this.contact.phoneNumbers[0].phoneNumber
    this.nickName = this.contact.nickName.nickName
    this.email = this.contact.emails[0].email
    this.postalAddress = this.contact.postalAddresses[0].postalAddress
  }
}