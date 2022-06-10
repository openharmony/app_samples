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
import TitleBar from '../common/TitleBar'

@Entry
@Component
struct Home {
  build() {
    Column() {
      TitleBar()
      Stack() {
        Image($r('app.media.home'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Fill)
          .opacity(0.3)
        Text($r('app.string.message_unlock'))
          .fontSize(35)
          .fontWeight(FontWeight.Bold)
          .padding(20)
          .alignSelf(ItemAlign.Center)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F0F0F0')
  }
}