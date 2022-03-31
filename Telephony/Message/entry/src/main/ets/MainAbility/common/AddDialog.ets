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
import HiLog from '../model/HiLogUtil'

const TAG: string = '[AddDialog]'

@CustomDialog
export struct AddDialog {
  private editContact: Contact = null
  private controller: CustomDialogController
  private action: (contact: Contact) => void

  build() {
    Column() {
      Text($r('app.string.contact'))
        .fontSize(20)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
      Row() {
        Text($r('app.string.full_name'))
          .width(65)
          .fontSize(20)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
        TextInput({ placeholder: 'input name', text: this.editContact.name })
          .layoutWeight(1)
          .type(InputType.Normal)
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .margin({ left: 10 })
          .onChange((value: string) => {
            this.editContact.name = value
          })
      }.margin({ top: '3%' })

      Row() {
        Text($r('app.string.telephone'))
          .fontSize(20)
          .width(65)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
        TextInput({ placeholder: 'input phone', text: this.editContact.destinationHost })
          .layoutWeight(1)
          .maxLength(11)
          .type(InputType.Number)
          .inputFilter('^1[0-9]*$')
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .margin({ left: 10 })
          .onChange((value: string) => {
            this.editContact.destinationHost = value
          })
      }.margin({ top: '3%' })

      Row() {
        Button() {
          Text($r('app.string.cancel'))
            .fontColor(Color.Red)
            .fontSize(17)
        }
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .margin(5)
        .onClick(() => {
          this.controller.close()
        })

        Text()
          .width(1).height(35)
          .backgroundColor('#8F8F8F')
        Button() {
          Text($r('app.string.determine'))
            .fontColor(Color.Blue)
            .fontSize(17)
        }
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .margin(5)
        .onClick(() => {
          HiLog.info(TAG, `editContact = ${JSON.stringify(this.editContact)}`)
          this.controller.close()
          if (this.editContact.name !== '' || this.editContact.destinationHost !== '') {
            this.action(this.editContact)
          }
        })
      }
      .width('100%')
      .margin({ top: '3%' })
    }
    .padding('3%')
  }
}