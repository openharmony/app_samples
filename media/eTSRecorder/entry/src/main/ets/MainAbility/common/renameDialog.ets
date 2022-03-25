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
import prompt from '@ohos.prompt'
import { Record } from '../model/record'

@CustomDialog
export struct RenameDialog {
  private controller: CustomDialogController
  private record: Record = null
  private newName: string = ''
  private renameCallback: (record: Record, newName: string) => void

  aboutToAppear() {
    this.newName = this.record.fileName
  }

  build() {
    Column() {
      TextInput({ placeholder: 'input name', text: this.record.fileName })
        .type(InputType.Normal)
        .placeholderColor(Color.Gray)
        .maxLength(18)
        .fontSize(19)
        .onChange((value: string) => {
          this.newName = value
        })
      Row() {
        Button() {
          Text($r('app.string.sure'))
            .fontColor(Color.Blue)
            .fontSize(17)
        }
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .margin(5)
        .onClick(() => {
          if (this.newName === '') {
            prompt.showToast({ message: 'input name' })
            return
          }
          this.controller.close()
          if (this.newName != this.record.fileName) {
            this.renameCallback(this.record, this.newName)
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