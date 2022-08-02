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
struct ScaleCapability {
  @State sliderWidth: number = 400
  @State sliderHeight: number = 400

  @Builder slider() {
    Slider({ value: this.sliderWidth, min: 100, max: 400, style: SliderStyle.OutSet })
      .blockColor(Color.White)
      .width('60%')
      .height(50)
      .onChange((value: number) => {
        this.sliderWidth = value
      })
      .position({ x: '20%', y: '80%' })
    Slider({ value: this.sliderHeight, min: 100, max: 400, style: SliderStyle.OutSet })
      .blockColor(Color.White)
      .width('60%')
      .height(50)
      .onChange((value: number) => {
        this.sliderHeight = value
      })
      .position({ x: '20%', y: '87%' })
  }

  build() {
    Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Column() {
          Image($r("app.media.illustrator")).width('100%').height('100%')
        }
        .aspectRatio(1)
        .border({ width: 2, color: "#66F1CCB8" })
      }
      .backgroundColor("#FFFFFF")
      .height(this.sliderHeight)
      .width(this.sliderWidth)

      this.slider()
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#F1F3F5")
  }
}