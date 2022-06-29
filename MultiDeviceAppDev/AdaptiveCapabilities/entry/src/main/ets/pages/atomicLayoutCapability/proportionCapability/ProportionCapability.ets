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
struct ProportionCapability {
  @State rate: number = 0.5

  @Builder slider() {
    Slider({ value: 100, min: 25, max: 50, style: SliderStyle.OutSet })
      .blockColor(Color.White)
      .width('60%')
      .height(50)
      .onChange((value: number) => {
        this.rate = value / 100
      })
      .position({ x: '20%', y: '80%' })
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Column() {
        Row() {
          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Image($r("app.media.down"))
              .width(48)
              .height(48)
          }
          .height(96)
          .width('33%')

          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Image($r("app.media.pause"))
              .width(48)
              .height(48)
          }
          .height(96)
          .width('34%')
          .backgroundColor('#66F1CCB8')

          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Image($r("app.media.next"))
              .width(48)
              .height(48)
          }
          .height(96)
          .width('33%')
        }
        .width(this.rate * 100 + '%')
        .height(96)
        .borderRadius(16)
        .backgroundColor('#FFFFFF')
      }

      this.slider()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}