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

import router from '@ohos.router'

@Component
export struct SearchBar {
  build() {
    Stack({ alignContent: Alignment.End }) {
      Text($r('app.string.search_tip'))
        .height('80%').width('94%')
        .fontSize(16)
        .padding({ left: 15 })
        .margin('3%')
        .backgroundColor('#F0F0F0')
        .border({ radius: 20 })
      Image($r('app.media.search_gray'))
        .height(40).width(40)
        .margin({ right: '5%' })
        .objectFit(ImageFit.Contain)
    }
    .height(50).width('100%')
    .backgroundColor('#F5F5F5')
    .onClick(() => {
      router.push({ url: 'pages/Query' })
    })
  }
}