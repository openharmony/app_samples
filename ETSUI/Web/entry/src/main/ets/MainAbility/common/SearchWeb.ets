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

@Component
export struct SearchBar {
  private controller: WebController = null
  @Link url: string
  @Link isWebError: boolean
  @Link webState: boolean
  @Link isHttpError: boolean
  @Link backToHome: boolean
  @Link isLoading: boolean

  build() {
    Row() {
      Image(this.webState === true ? this.isLoading === true ? $r('app.media.stop') : $r('app.media.refresh') : $r('app.media.search'))
        .width('20%')
        .height(40)
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          if (!this.isLoading) { // 如果加载完成则刷新页面
            this.controller.refresh()
            prompt.showToast({ message: '页面已刷新', duration: 2000 })
          } else { // 停止页面加载
            this.controller.stop()
            prompt.showToast({ message: '页面已停止加载', duration: 2000 })
            this.isLoading = false
          }
        })
      Row() {
        TextInput({ placeholder: this.url })
          .width('100%')
          .fontSize(25)
          .type(InputType.Normal)
          .fontWeight(FontWeight.Regular)
          .placeholderFont({ size: 25, style: FontStyle.Italic })
          .onClick(() => {
            this.webState = false
            this.backToHome = false
          })
          .onChange((value: string) => {
            this.url = value
          })
      }
      .height(70)
      .width('50%')

      Button() {
        Text($r('app.string.search'))
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
      }
      .width('25%')
      .height(40)
      .margin({ left: 10, right: 10 })
      .type(ButtonType.Capsule)
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        this.webState = true
        this.isLoading = true
        this.isWebError = false
        this.isHttpError = false
      })
    }
    .width('100%')
    .height(50)
    .borderRadius(15)
    .margin({ top: 10, bottom: 10 })
  }
}