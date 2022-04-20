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

import router from '@system.router';

@Entry
@Component
export struct NewsDetailTitle {
  build() {
    Row() {
      Flex({ alignItems: ItemAlign.Start }) {
        Image($r('app.media.back'))
          .width(21.8)
          .height(19.6)
        Text('新闻详情')
          .fontSize(20)
          .margin({ left: 17.4 })
      }
      .backgroundColor($r('app.color.colorSubBackground'))
      .height(50)
      .padding({ top: 13, bottom: 15, left: 20 })
      .onClick(() => {
        router.back()
      })
    }
  }
}