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
import prompt from '@ohos.prompt'

@CustomDialog
export struct RenameDialog {
  private controller: CustomDialogController
  private action: (title: string) => void
  @State title: string = ''

  build() {
    Column() {
      Text($r('app.string.rename_file'))
        .fontSize(20)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
      TextInput({ placeholder: 'input new name', text: this.title })
        .type(InputType.Normal)
        .placeholderColor(Color.Gray)
        .maxLength(20)
        .fontSize(19)
        .margin({ left: 10, top: 15 })
        .onChange((value: string) => {
          this.title = value
        })
      Row() {
        Button() {
          Text($r('app.string.yes'))
            .fontColor(Color.Red)
            .fontSize(17)
        }
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .margin(5)
        .onClick(() => {
          if (this.title === '') {
            prompt.showToast({ message: 'please input the file name', duration: 1000 })
            return
          }
          this.action(this.title)
        })

        Divider()
          .height(30)
          .vertical(true)
          .strokeWidth(1)
          .color('#8F8F8F')
        Button() {
          Text($r('app.string.cancel'))
            .fontColor(Color.Blue)
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
    }.padding(15)
  }
}