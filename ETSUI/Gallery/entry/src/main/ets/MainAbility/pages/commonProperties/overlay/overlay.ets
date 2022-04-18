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


@Entry
@Component
struct OverlaySample {
  @State align: string = "Top"
  @State offsetX: number= 50
  @State offsetY: number= 50

  build() {
    Flex({ direction: FlexDirection.Column }) {
      NavigationBar({ title: '浮层' })

      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Image('/common/test5.jpg')
              .width('80%').height('90%')
              .overlay('OpenHarmony', {
                align: Alignment[this.align],
                offset: { x: this.offsetX - 50, y: this.offsetY - 50 }
              })
          }
        }
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .backgroundColor('#696969')

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('align')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)

            Text(`${this.align}`)
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.End)
              .bindMenu([
                {
                  value: 'TopStart',
                  action: () => {
                    this.align = "TopStart"
                  }
                },
                {
                  value: 'Top',
                  action: () => {
                    this.align = "Top"
                  }
                },
                {
                  value: 'TopEnd',
                  action: () => {
                    this.align = "TopEnd"
                  }
                },
                {
                  value: 'Start',
                  action: () => {
                    this.align = "Start"
                  }
                },
                {
                  value: 'Center',
                  action: () => {
                    this.align = "Center"
                  }
                },
                {
                  value: 'End',
                  action: () => {
                    this.align = "End"
                  }
                },
                {
                  value: 'BottomStart',
                  action: () => {
                    this.align = "BottomStart"
                  }
                },
                {
                  value: 'Bottom',
                  action: () => {
                    this.align = "Bottom"
                  }
                },
                {
                  value: 'BottomEnd',
                  action: () => {
                    this.align = "BottomEnd"
                  }
                },
              ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ bottom: 10 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('offset(x)')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Column() {
              Row() {
                Slider({
                  value: this.offsetX,
                  min: 0,
                  max: 100,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .showSteps(true)
                  .showTips(true)
                  .width('97%')
                  .onChange((value: number) => {
                    this.offsetX = value
                  })
                Text(`${(this.offsetX - 50).toFixed(0)}`).fontSize(16)
              }.width('80%')
            }
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('offset(y)')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Column() {
              Row() {
                Slider({
                  value: this.offsetY,
                  min: 0,
                  max: 100,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .showSteps(true)
                  .showTips(true)
                  .width('97%')
                  .onChange((value: number) => {
                    this.offsetY = value
                  })
                Text(`${(this.offsetY - 50).toFixed(0)}`).fontSize(16)
              }.width('80%')
            }
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
        .width('100%')
      }
      .margin({ top: 24 })
    }
    .height('100%')
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
