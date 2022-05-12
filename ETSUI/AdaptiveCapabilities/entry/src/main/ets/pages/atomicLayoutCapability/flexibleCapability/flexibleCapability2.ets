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
struct FlexibleCapabilitySample2 {
  @State rate: number = 0.8;

  @Builder slider() {
    Slider({ value: this.rate * 100, min: 30, max: 80, style: SliderStyle.OutSet })
      .blockColor(Color.White)
      .width('60%')
      .onChange((value: number) => {
        this.rate = value / 100;
      })
      .position({ x: '20%', y: '80%' })
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Column() {
        Row() {
          Text('健康使用手机')
            .fontSize(16)
            .width(135)
            .height(22)
            .fontWeight(FontWeight.Medium)
            .lineHeight(22)
          Blank()
          Toggle({ type: ToggleType.Switch })
            .width(36)
            .height(20)
        }
        .height(55)
        .borderRadius(12)
        .padding({ left: 13, right: 13 })
        .backgroundColor('#FFFFFF')
        .width(this.rate * 100 + '%')
      }

      this.slider()
    }.width('100%').height('100%').backgroundColor('#F1F3F5')
  }
}