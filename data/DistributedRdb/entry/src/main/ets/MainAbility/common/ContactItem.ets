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
import Contact from '../model/Contact'

const Gender = {
  MALE: 0,
  FEMALE: 1
}

@Component
export struct ContactItem {
  private contact: Contact = undefined
  @Link isMultiCheck: boolean

  build() {
    Row() {
      Image(this.contact.gender === Gender.MALE ? $r('app.media.contact_photo_male') : $r('app.media.contact_photo_female'))
        .height(80).width(80)
        .objectFit(ImageFit.Fill)
      Column() {
        Text(this.contact.name)
          .fontSize(30)
          .fontColor(Color.Black)
          .width('100%')

        Text(this.contact.phone)
          .fontSize(25)
          .fontColor(Color.Grey)
          .width('100%')
      }
      .margin({ left: 16 })
      .layoutWeight(1)

      if (this.isMultiCheck) {
        Checkbox({ name: 'contact' })
          .select(this.contact.isSelected)
          .selectedColor(0x39a2db)
          .size({ width: 25, height: 25 })
          .margin({ right: 5 })
          .onChange((value: boolean) => {
            this.contact.isSelected = value
          })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .gesture(
      LongPressGesture({ repeat: true })
        .onAction((event: GestureEvent) => {
          if (!this.isMultiCheck) {
            this.isMultiCheck = true
          }
        })
      )
  }
}