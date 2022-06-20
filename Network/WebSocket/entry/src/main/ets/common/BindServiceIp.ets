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
export default struct BindServiceIp {
  @Link ipAddress: string
  private onBind: () => void

  build() {
    Column() {
      Text($r('app.string.welcome'))
        .fontSize(25)
        .margin({ top: 20 })
        .fontWeight(FontWeight.Bold)
      TextInput({ placeholder: $r('app.string.ip_placeholder') })
        .height(50)
        .fontSize(15)
        .width('70%')
        .margin({ top: 20 })
        .onChange((value: string) => {
          this.ipAddress = `ws://${value}/string`
        })
      Button() {
        Text($r('app.string.bind_ip'))
          .fontSize(20)
          .fontColor(Color.White)
      }
      .margin({ top: 20 })
      .width(200)
      .height(50)
      .type(ButtonType.Capsule)
      .onClick(() => {
        this.onBind()
      })
    }
    .width('100%')
  }
}