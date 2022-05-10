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
import router from '@ohos.router';

@Component
export struct SliderComponent {
  @Link value: number
  @Prop name: string
  @Prop min: number
  @Prop max: number
  @State step: number= 1

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Text(this.name)
          .fontSize('16fp')
          .opacity(0.5)
          .fontColor('#182431')
          .fontWeight(FontWeight.Medium)
        Text('' + this.value.toFixed(0))
          .fontSize('16fp')
          .fontColor('#182431')
          .fontWeight(FontWeight.Medium)
          .width('50%')
          .textAlign(TextAlign.End)
      }.width('100%')

      Slider({
        value: this.value,
        min: this.min,
        max: this.max,
        step: this.step,
        style: SliderStyle.OutSet
      })
        .width('100%')
        .blockColor('#FFFFFF')
        .trackColor('#182431')
        .selectedColor('#007DFF')
        .showSteps(true)
        .showTips(false)
        .onChange((value: number) => {
          this.value = value
        })
    }
    .width('100%')
    .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
    .borderRadius(24)
    .backgroundColor('#FFFFFF')
    .margin({  bottom: 8 })
  }
}