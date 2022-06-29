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
@Entry
@Component
struct DiversionSample {
  build() {
    Row() {
      GridContainer() {
        Flex({
          direction: FlexDirection.Row,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Center,
          wrap: FlexWrap.Wrap
        }) {
          Row() {
            Image($r('app.media.illustrator'))
          }
          .aspectRatio(1)
          .useSizeType({ xs: 2, sm: 4, md: 4, lg: 6 })

          Flex({
            direction: FlexDirection.Column,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center
          }) {
            Text($r('app.string.user_improvement'))
              .textAlign(TextAlign.Center)
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
            Text($r('app.string.user_improvement_tips'))
              .textAlign(TextAlign.Center)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
          }
          .height(100)
          .useSizeType({ xs: 2, sm: 4, md: 4, lg: 6 })
        }
      }
    }
    .height('100%')
    .alignItems((VerticalAlign.Center))
    .backgroundColor('#F1F3f5')
  }
}