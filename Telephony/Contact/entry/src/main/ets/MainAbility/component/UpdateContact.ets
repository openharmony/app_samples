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

@Component
export struct UpdateContact {
  @State name: string = ''
  @State email: string = ''
  @State nickName: string = ''
  @State phoneNumber: string = ''
  @State postalAddress: string = ''
  @Link contact: contact.Contact

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Image($r('app.media.touxiang'))
        .width('20%')
        .height('15%')
        .margin({ top: '2%' })
        .objectFit(ImageFit.Contain)

      Text($r('app.string.save_phone'))
        .fontSize(20)
        .margin('2%')

      this.updateContact(`姓名: ${this.name}`, $r('app.media.name'))
      this.updateContact(`昵称: ${this.nickName}`, $r('app.media.nickname'))
      this.updateContact(`电话: ${this.phoneNumber}`, $r('app.media.phone'))
      this.updateContact(`邮箱: ${this.email}`, $r('app.media.email'))
      this.updateContact(`地址: ${this.postalAddress}`, $r('app.media.address'))
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  updateContact(editText: string, img: Resource) {
    Row() {
      Image(img)
        .width('18%')
        .height('36%')
        .margin({ right: 2 })
        .objectFit(ImageFit.Contain)

      TextInput({ placeholder: editText })
        .width('70%')
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
        .placeholderFont({ size: 22, weight: 450, family: 'cursive', style: FontStyle.Normal })
        .onChange(value => {
          switch (editText) {
            case '姓名:':
              this.name = value
              break
            case '昵称:':
              this.nickName = value
              break
            case '电话:':
              this.phoneNumber = value
              break
            case '邮箱:':
              this.email = value
              break
            case '地址:':
              this.postalAddress = value
              break
            default:
              break
          }
        })
    }
    .width('80%')
    .margin({ top: 10 })
  }

  aboutToAppear() {
    this.name = this.contact.name.fullName
    this.phoneNumber = this.contact.phoneNumbers[0].phoneNumber
    this.nickName = this.contact.nickName.nickName
    this.email = this.contact.emails[0].email
    this.postalAddress = this.contact.postalAddresses[0].postalAddress
  }
}