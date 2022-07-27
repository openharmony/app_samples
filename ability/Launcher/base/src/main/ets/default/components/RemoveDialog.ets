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

@CustomDialog
export default struct RemoveDialog {
  private cardName: string = ''
  private controller: CustomDialogController
  private confirm: () => void

  build() {
    Column() {
      Row() {
        Text($r('app.string.whether_to_remove'))
          .fontSize(17)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
        Text(this.cardName)
          .fontSize(17)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
        Text($r('app.string.card'))
          .fontSize(17)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
      }
      .margin({ top: 10 })

      Text($r('app.string.card_remove_message'))
        .fontSize(16)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 10 })
      Row() {
        Button($r('app.string.cancel'))
          .layoutWeight(7)
          .fontColor(Color.Blue)
          .backgroundColor(Color.White)
          .margin(5)
          .onClick(() => {
            this.controller.close()
          })
        Divider()
          .width(1).height(35)
          .backgroundColor('#8F8F8F')
        Button($r('app.string.remove'))
          .layoutWeight(7)
          .fontColor(Color.Red)
          .backgroundColor(Color.White)
          .margin(5)
          .onClick(() => {
            this.controller.close()
            this.confirm()
          })
      }
      .margin({ top: 10 })
    }
    .width('80%')
    .borderRadius(15)
    .padding(16)
    .backgroundColor(Color.White)
  }
}