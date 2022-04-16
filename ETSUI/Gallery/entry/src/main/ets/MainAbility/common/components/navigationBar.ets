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

@Component
export struct NavigationBar {
  title: string

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        // touch area
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          // icon 24 * 24
          Image($r("app.media.Back"))
            .width(24)
            .height(24)
            .focusable(false)
        }.width(48)
        .height(56)
        .onClick(() => {
          router.back()
        })

        Text(this.title)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .padding({ left: 2 })
          .fontColor("#000000")
          .focusable(false)
      }
      .width('100%')
    }
    .margin({ bottom: 8 })
  }
}