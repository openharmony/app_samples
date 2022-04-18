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
import { GetColor } from "../../../common/components/getColor"

@Entry
@Component
struct BlankSample {
  @State blankColor: string= '#eee'
  @State blankMin: number= 100

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: 'Blank' })

      Column() {
        Column() {
          Row() {
            Text('Bluetooth').fontSize('18fp')
            Blank(this.blankMin + 50).color(this.blankColor)
            Text('>').fontSize('18fp')
          }.backgroundColor(0xFFFFFF).borderRadius(15).padding(12).height(50)

          Row() {
            Text('Bluetooth').fontSize('18fp')
            Blank(this.blankMin).color(this.blankColor)
            Toggle({ type: ToggleType.Switch })
          }
          .backgroundColor(0xFFFFFF)
          .borderRadius(15)
          .padding(12)
          .margin({ top: 40 })
          .height(50)

        }
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .backgroundColor('#FFB6C1')

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('color')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
            Column() {
              GetColor({ colorVal: $blankColor })
            }.width(48)
          }
          .width('100%')
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('min')
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .lineHeight(28)
                .fontWeight(FontWeight.Medium)
              Text(`${this.blankMin.toFixed(0)}`).fontSize('16fp').lineHeight(28).fontWeight(FontWeight.Medium)
            }

            Slider({
              value: this.blankMin,
              min: 0,
              max: 150,
              step: 1,
              style: SliderStyle.OutSet
            })
              .blockColor('#FFFFFF')
              .trackColor('#183431')
              .selectedColor('#007DFF')
              .borderRadius(12)
              .borderColor('rgba(0,0,0,0.04)')
              .showSteps(true)
              .showTips(false)
              .onChange((value: number, mode: SliderChangeMode) => {
                this.blankMin = value
              })
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .padding('3%')
          .margin({ top: 8 })
          .borderRadius(24)
        }
      }
      .margin({ top: 24 })
    }
    .padding({ left: '3%', right: '3%' })
    .height('100%')
    .backgroundColor('#F1F3F5')
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
