/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import { Student } from '../model/student'
import { DeleteDialog } from '../common/deleteDialog'

@Component
export struct StudentView {
  private student: Student = null
  private deleteCallBack = null
  private deleteDialogController: CustomDialogController = new CustomDialogController({
    builder: DeleteDialog({ student: this.student, deleteCallback: this.deleteCallBack }),
    autoCancel: true
  })

  build() {
    Row() {
      Image($r('app.media.student'))
        .width('25%').height(60)
        .objectFit(ImageFit.Contain)
      Flex({ direction: FlexDirection.Column }) {
        Row() {
          Text($r('app.string.student_name'))
            .fontColor(Color.Black)
            .fontSize(18)
          Text(this.student.name)
            .fontColor(Color.Black)
            .fontSize(18)
        }

        Row() {
          Text($r('app.string.student_age'))
            .fontColor(Color.Black)
            .fontSize(18)
          Text(this.student.age.toString())
            .fontColor(Color.Black)
            .fontSize(18)
        }

        Row() {
          Text($r('app.string.student_phone'))
            .fontColor(Color.Black)
            .fontSize(18)
          Text(this.student.phone)
            .fontColor(Color.Black)
            .fontSize(18)
        }
      }
      .layoutWeight(1)

      if (this.deleteCallBack !== null) {
        Button() {
          Text($r('app.string.delete'))
            .fontColor(Color.Red)
            .fontSize(19)
            .width('100%')
            .textAlign(TextAlign.Center)
        }
        .type(ButtonType.Capsule)
        .backgroundColor('#F5F5F5')
        .height(50)
        .width(120)
        .onClick(() => {
          this.deleteDialogController.open()
        })
      }
    }
    .width('100%')
    .padding(10)
  }
}