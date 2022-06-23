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
export struct TitleBar {
  private handlerClickButton: () => void

  build() {
    Row() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(40)
          .height(30)
          .onClick(() => {
            this.handlerClickButton()
          })
        Text($r('app.string.UploadDownload'))
          .fontSize(30)
          .width(150)
          .height(50)
          .margin({ left: 15 })
          .fontColor('#ffa2a3a4')
      }
      .width('100%')
      .height(60)
      .padding({ left: 20 })
      .backgroundColor('#ff2d30cb')
      .constraintSize({ minHeight: 50 })
    }
  }
}