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

import prompt from '@system.prompt'
import { Student } from '../model/Student'

@CustomDialog
export struct AddDialog {
  private editStudent: Student = null
  private controller: CustomDialogController
  private isInsert: boolean = false
  private action: (isInsert: boolean, student: Student) => void

  build() {
    Column() {
      Text($r('app.string.student_info'))
        .fontSize(20)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
      Row() {
        Text($r('app.string.student_name'))
          .width(65)
          .fontSize(20)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
        TextInput({ placeholder: 'input name', text: this.editStudent.name })
          .layoutWeight(1)
          .type(InputType.Normal)
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .maxLength(20)
          .margin({ left: 10 })
          .onChange((value: string) => {
            this.editStudent.name = value
          })
      }.margin({ top: '3%' })

      Row() {
        Text($r('app.string.student_age'))
          .fontSize(20)
          .width(65)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
        TextInput({ placeholder: 'input age', text: this.editStudent.age.toString() })
          .layoutWeight(1)
          .type(InputType.Number)
          .inputFilter('^[1-9][0-9]*$')
          .maxLength(3)
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .margin({ left: 10 })
          .onChange((value: string) => {
            this.editStudent.age = Number(value)
          })
      }.margin({ top: '3%' })

      Row() {
        Text($r('app.string.student_phone'))
          .fontSize(20)
          .width(65)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
        TextInput({ placeholder: 'input phone', text: this.editStudent.phone })
          .layoutWeight(1)
          .type(InputType.Number)
          .inputFilter('^1[0-9]*$')
          .maxLength(11)
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .margin({ left: 10 })
          .onChange((value: string) => {
            this.editStudent.phone = value
          })
      }.margin({ top: '3%' })

      Row() {
        Button() {
          Text($r('app.string.yes'))
            .fontColor(Color.Blue)
            .fontSize(17)
        }
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .margin(5)
        .onClick(() => {
          console.info(`[Rdb.dialog] editStudent = ${JSON.stringify(this.editStudent)}`)
          console.info(`[Rdb.dialog] isInsert = ${this.isInsert}`)
          if (this.editStudent.name === ''){
            prompt.showToast({ message: '姓名不能为空', duration: 1000 })
            return
          }
          if (this.editStudent.age > 0) {
            if(this.editStudent.phone === ''){
              prompt.showToast({ message: '电话不能为空', duration: 1000 })
              return
            }
            this.controller.close()
            this.action(this.isInsert, this.editStudent)
          } else {
            prompt.showToast({ message: '年龄不能为空', duration: 1000 })
            return
          }
        })

        Text()
          .width(1).height(35)
          .backgroundColor('#8F8F8F')
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
      }
      .width('100%')
      .margin({ top: '3%' })
    }
    .padding('3%')
  }
}