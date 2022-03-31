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

import { Student } from '../model/Student'

@CustomDialog
export struct DeleteDialog {
  private controller: CustomDialogController
  private student:Student = null
  private deleteCallback: (student:Student) => void

  build() {
    Column() {
      Text($r('app.string.delete_by_student'))
        .fontSize(17)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
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
          this.controller.close()
          this.deleteCallback(this.student)
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