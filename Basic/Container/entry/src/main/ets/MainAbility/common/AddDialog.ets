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

import prompt from '@system.prompt';
import Information from '../model/Information'
import Logger from '../model/Logger'

const TAG = 'addDialog'

@CustomDialog
export struct AddDialog {
  private writeInformation: Information = new Information(0, '', NaN, '')
  private isInserted: boolean = false
  private saveData: (isInserted: boolean, information: Information) => void
  private controller: CustomDialogController

  build() {
    Column() {
      Text($r('app.string.contact_information'))
        .fontSize(24)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
        .margin({ top: '3%' })
      Row() {
        Text($r('app.string.contact_name'))
          .width(65)
          .fontSize(20)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 10 })

        TextInput({ placeholder: $r('app.string.input_name'), text: this.writeInformation.name })
          .layoutWeight(1)
          .type(InputType.Normal)
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .maxLength(20)
          .inputFilter('^[A-Za-z0-9]*$')
          .onChange((value: string) => {
            this.writeInformation.name = value
          })
      }
      .width('100%')
      .margin({ top: '3%' })

      Row() {
        Text($r('app.string.contact_age'))
          .width(65)
          .fontSize(20)
          .margin({ left: 10 })
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
        TextInput({ placeholder: $r('app.string.input_age'), text: this.writeInformation.age.toString() })
          .layoutWeight(1)
          .type(InputType.Number)
          .inputFilter('^[1-9][0-9]*$')
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .maxLength(3)
          .margin({ right: 10 })
          .onChange((value: string) => {
            this.writeInformation.age = +value
          })
      }
      .margin({ top: '3%' })

      Row() {
        Text($r('app.string.contact_phone'))
          .width(65)
          .fontSize(20)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 10 })

        TextInput({ placeholder: $r('app.string.input_phone'), text: this.writeInformation.phone })
          .layoutWeight(1)
          .type(InputType.Number)
          .inputFilter('^1[0-9]*$')
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .maxLength(11)
          .margin({ right: 10 })
          .onChange((value: string) => {
            this.writeInformation.phone = value
          })

      }.margin({ top: '3%' })

      Row() {
        Button() {
          Text($r("app.string.button_confirm"))
            .fontColor(Color.Blue)
            .fontSize(17)
        }
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .margin(5)
        .onClick(() => {
          if (this.writeInformation.name === '') {
            prompt.showToast({ message: '姓名不能为空', duration: 1000 })
            return
          }
          if (this.writeInformation.age === 0) {
            prompt.showToast({ message: '年龄不能为空', duration: 1000 })
            return
          }
          if (this.writeInformation.phone === '') {
            prompt.showToast({ message: '电话号码不能为空', duration: 1000 })
            return
          }
          if (this.writeInformation.name !== '' && this.writeInformation.phone !== '' && this.writeInformation.age > 0) {
            this.isInserted = true
            Logger.log(`${TAG}, isInserted= ${this.isInserted}`)
            Logger.log(`${TAG}, writeInformation= ${this.writeInformation}`)
            this.saveData(this.isInserted, this.writeInformation)
          }
          this.controller.close()
        })

        Divider().height(30).vertical(true).strokeWidth(2).color('#999999')

        Button() {
          Text($r('app.string.button_cancel'))
            .fontColor(Color.Red)
            .fontSize(17)
        }
        .margin(5)
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .onClick(() => {
          this.controller.close()
        })
      }
    }
    .padding('3%')
  }
}