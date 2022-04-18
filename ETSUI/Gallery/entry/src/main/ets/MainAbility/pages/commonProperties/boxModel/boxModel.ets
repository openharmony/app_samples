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
import { NavigationBar } from "../../../common/components/navigationBar"
import { SliderComponent } from "../../../common/components/sliderComponent"

@Entry
@Component
struct BoxModelSample {
  @State padding: number = 10
  @State margin: number = 20
  @State border: number = 2
  @State contentWidth: number = 120
  @State contentHeight: number = 80

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: '盒模型' })
      Column() {
        Text('width:' + `${this.contentWidth.toFixed(0)}` + '     ' + 'height:' + `${this.contentHeight.toFixed(0)}`)
          .width('100%')
          .height('20%')
          .lineHeight(20)
          .fontSize('16fp')
          .fontColor('#182431')
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
        Scroll() {
          Column() {
            if (this.margin >= 10) {
              Text('margin:' + this.margin.toFixed(0))
                .fontSize(12)
                .offset({ x: 0, y: 0 })
                .zIndex(1)
            } else {

            }

            Column() {
              if (this.padding >= 10) {
                Text('padding:' + this.padding.toFixed(0))
                  .fontSize(12)
                  .offset({ x: -(this.padding), y: -(this.padding) })
                  .zIndex(1)
              }

              Column() {
                Text('content')
                  .width('100%')
                  .height('100%')
                  .fontSize(12)
                  .textAlign(TextAlign.Center)
              }.backgroundColor('#66ccff')
            }
            .backgroundColor('#6EDF57')
            .padding(this.padding)
            .margin(this.margin)
            .border({ width: this.border, color: '#455108' })
            .width(this.contentWidth)
            .height(this.contentHeight)
          }.backgroundColor('#E1EEA4')
        }.width('100%').height('80%')

      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .backgroundColor(('#FFFFFF'))

      Scroll() {
        Column() {
          //控件写法
          SliderComponent({ name: 'Width', value: $contentWidth, min: 0, max: 260 })
          //原本写法
          //          Column() {
          //            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          //              Text('Width')
          //                .fontSize('16fp')
          //                .opacity(0.5)
          //                .fontColor('#182431')
          //                .fontWeight(FontWeight.Medium)
          //              Text('' + this.contentWidth.toFixed(0))
          //                .fontSize('16fp')
          //                .fontColor('#182431')
          //                .fontWeight(FontWeight.Medium)
          //                .width('50%')
          //                .textAlign(TextAlign.End)
          //            }.width('100%')
          //
          //            Slider({
          //              value: this.contentWidth,
          //              min: 0,
          //              max: 260,
          //              step: 1,
          //              style: SliderStyle.OutSet
          //            })
          //              .width('100%')
          //              .blockColor('#FFFFFF')
          //              .trackColor('#182431')
          //              .selectedColor('#007DFF')
          //              .showSteps(true)
          //              .showTips(false)
          //              .onChange((value: number) => {
          //                this.contentWidth = value
          //              })
          //          }
          //          .width('100%')
          //          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          //          .borderRadius(24)
          //          .backgroundColor('#FFFFFF')
          SliderComponent({ name: 'Height', value: $contentHeight, min: 0, max: 800, })
          SliderComponent({ name: 'padding', value: $padding, min: 0, max: 50, })
          SliderComponent({ name: 'margin', value: $margin, min: 0, max: 50 })
          SliderComponent({ name: 'border', value: $margin, min: 0, max: 50 })
        }.width('100%')
      }.width('100%').height('45%')
    }
    .width('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 10 })
  }

  pageTransition() {
    PageTransitionEnter({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)

    PageTransitionExit({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)
  }
}
