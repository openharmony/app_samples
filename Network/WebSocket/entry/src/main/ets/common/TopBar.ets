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
export default struct TopBar {
  @Link isConnect: boolean
  private connect: () => void

  build() {
    Row() {
      Text($r('app.string.server'))
        .width('20%')
        .fontSize(20)
        .margin({ left: '40%' })
        .textAlign(TextAlign.Center)

      Button() {
        Text($r('app.string.connect'))
          .margin(10)
          .fontSize(15)
          .fontColor(Color.White)
      }
      .width(70)
      .height(40)
      .margin({ left: '20%' })
      .type(ButtonType.Capsule)
      .backgroundColor(this.isConnect ? Color.Green : Color.Grey)
      .onClick(() => {
        this.connect()
      })
    }
    .height(50)
    .width('100%')
    .backgroundColor('#e5e5e5')
  }
}