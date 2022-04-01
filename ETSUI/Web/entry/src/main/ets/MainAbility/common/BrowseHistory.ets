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
export struct BrowseHistory {
  @Link url: string
  @Link isWebError: boolean
  @Link webState: boolean
  @Link isHttpError: boolean
  @Link backToHome: boolean
  @Link browses: string[]
  @Link isLoading: boolean

  build() {
    Column() {
      Text($r('app.string.browse_history'))
        .width('90%')
        .fontSize(20)
        .margin({ top: 10 })
        .textAlign(TextAlign.Start)
      ForEach(this.browses, item => {
        Row() {
          Image($r('app.media.circle'))
            .width('15%')
            .height(30)
            .objectFit(ImageFit.ScaleDown)
          Text(item)
            .height(50)
            .fontSize(15)
            .layoutWeight(1)
            .fontWeight(FontWeight.Regular)
        }
        .onClick(() => {
          this.url = item
          this.webState = true
          this.isLoading = true
          this.backToHome = false
          this.isWebError = false
          this.isHttpError = false
        })
      }, item => item)
    }
  }
}