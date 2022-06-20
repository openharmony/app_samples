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

@Component
export default struct SendMessage {
  @Link message: string
  private sendMessage: () => void

  build() {
    Row() {
      TextArea({ placeholder: this.message, text: this.message })
        .height(50)
        .fontSize(25)
        .layoutWeight(3)
        .backgroundColor(Color.White)
        .margin({ left: 2, right: 2 })
        .onChange((value: string) => {
          this.message = value
        })

      Button() {
        Text($r('app.string.send_message'))
          .fontSize(23)
          .fontColor(Color.White)
      }
      .height(50)
      .layoutWeight(1)
      .borderRadius(10)
      .type(ButtonType.Normal)
      .backgroundColor('#ffadf58e')
      .margin({ left: 2, right: 2 })
      .onClick(() => {
        this.sendMessage()
      })
    }
    .height(70)
    .width('100%')
    .backgroundColor('#f5f5f5')
  }
}