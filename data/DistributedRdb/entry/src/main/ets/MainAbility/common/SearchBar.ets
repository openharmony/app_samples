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
import router from '@ohos.router'

@Component
export struct SearchBar {
  build() {
    Row() {
      Image($r('app.media.search_gray'))
        .height('100%').width(40)
        .margin({ left: 16 })
        .objectFit(ImageFit.Contain)
      Text($r('app.string.search_placeholder'))
        .height('100%')
        .width('80%')
        .fontSize(25)
        .margin({ right: 10 })
        .backgroundColor('#FAFAFA')
    }
    .width('100%')
    .height('7%')
    .backgroundColor('#FAFAFA')
    .constraintSize({ minHeight: 60 })
    .border({ radius: 45 })
    .margin({ top: 10 })
    .onClick(() => {
      router.push({
        url: 'pages/SearchPage'
      })
    })
  }
}