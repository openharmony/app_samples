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

@CustomDialog
export struct PasswordDialog {
  private scanInfo: any = null
  private psw: string = ''
  private controller: CustomDialogController
  private action: (scanInfo, psw) => void

  build() {
    Column() {
      Text(this.scanInfo.ssid)
        .fontSize(20)
        .width('95%')
      TextInput({ placeholder: 'input password' })
        .type(InputType.Password)
        .placeholderColor(Color.Gray)
        .fontSize(19)
        .margin({ top: 15 })
        .width('95%')
        .onChange((value: string) => {
          this.psw = value
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
          this.controller.close()
          this.action(this.scanInfo, this.psw)
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
    .padding(15)
  }
}