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

      this.newContact('姓名', $r('app.media.name'))
      this.newContact('地址', $r("app.media.address"))
      this.newContact('电话', $r('app.media.phone'))
      this.newContact('邮箱', $r('app.media.email'))
      this.newContact('备注', $r('app.media.nickname'))
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  newContact(editText: string, img: Resource) {
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
        .onChange(value => {
          switch (editText) {
            case '姓名':
              this.name = value;
              break
            case '备注':
              this.nickName = value
              break
            case '电话':
              this.phoneNumber = value
              break
            case '邮箱':
              this.email = value;
              break
            case '地址':
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
}