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
@Entry
@CustomDialog
export struct AuthCustomDialog {
  private confirm: () => void
  private content?: string
  public controller?: CustomDialogController

  build() {
    Column() {
      Text(this.content)
        .width('90%')
        .height(100)
        .fontSize(25)
        .textAlign(TextAlign.Center)
        .margin({ top: 10, bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            this.controller.close()
          })
          .backgroundColor(0xffffff)
          .fontColor(Color.Black)
        Button('confirm')
          .onClick(() => {
            this.controller.close()
            this.confirm()
          })
          .backgroundColor(0xffffff)
          .fontColor(Color.Red)
      }
      .margin({ bottom: 10 })
    }
  }
}