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
struct GaugeSample {
  @State color: Color = Color.Black
  @State minVal: number = 0
  @State maxVal: number = 100
  @State outSetValue: number = 15
  @State startAngle: number = 15
  @State endAngle: number = 359
  @State strokeWidth: number = 10
  @State colorList: Object[] = [[0xAEE1E1, 1], [0xD3E0DC, 1], [0xFCD1D1, 1]]
  scroller: Scroller = new Scroller()

  build() {
    Column() {
      NavigationBar({ title: 'Gauge' })

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Gauge({ value: this.outSetValue, min: this.minVal, max: this.maxVal })
          .startAngle(this.startAngle)
          .endAngle(this.endAngle)
          .colors(this.colorList)
          .strokeWidth(this.strokeWidth)
          .width('100%')
          .height('80%')
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .width('100%')
      .padding(18)
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('min')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Column() {
                Counter() {
                  Text(this.minVal.toString())
                    .fontWeight(FontWeight.Regular)
                    .fontColor('#000000')
                    .fontSize('10fp')
                }
                .onInc(() => {
                  this.minVal < this.maxVal - 1 && this.minVal++
                })
                .onDec(() => {
                  this.minVal > 0 && this.minVal--
                })
                .height(24)
              }
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('max')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Column() {
                Counter() {
                  Text(this.maxVal.toString())
                    .fontWeight(FontWeight.Regular)
                    .fontColor('#000000')
                    .fontSize('10fp')
                }
                .onInc(() => {
                  this.maxVal++
                })
                .onDec(() => {
                  this.maxVal - 1 > this.minVal && this.maxVal--
                  this.outSetValue > this.maxVal && (this.outSetValue = this.maxVal)
                })
                .height(24)
              }
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })

            Flex({ direction: FlexDirection.Column }) {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
                Text('value')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')
                Text(this.outSetValue.toFixed(0))
                  .fontSize('16fp')
                  .fontWeight(FontWeight.Medium)
                  .width('50%')
                  .textAlign(TextAlign.End)
              }

              Slider({
                value: this.outSetValue,
                min: this.minVal,
                max: this.maxVal,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF')
                .trackColor('#182431')
                .selectedColor('#007DFF')
                .width('100%')
                .showSteps(true)
                .showTips(true)
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.outSetValue = value
                })
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })

            Flex({ direction: FlexDirection.Column }) {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
                Text('startAngle:')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')

                Text(this.startAngle.toFixed(0))
                  .fontSize('16fp')
                  .fontWeight(FontWeight.Medium)
              }

              Slider({
                value: this.startAngle,
                min: 0,
                max: 359,
                step: 1,
                style: SliderStyle.OutSet
              })
                .margin({ right: '3%' })
                .blockColor('#FFFFFF')
                .trackColor('#182431')
                .selectedColor('#007DFF')
                .width('100%')
                .showSteps(true)
                .showTips(true)
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.startAngle = value
                })
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })

            Flex({ direction: FlexDirection.Column }) {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
                Text('endAngle')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')

                Text(this.endAngle.toFixed(0))
                  .fontSize('16fp')
                  .fontWeight(FontWeight.Medium)
              }

              Slider({
                value: this.endAngle,
                min: 0,
                max: 359,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF')
                .trackColor('#182431')
                .selectedColor('#007DFF')
                .width('100%')
                .showSteps(true)
                .showTips(true)
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.endAngle = value
                })
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })

            Flex({ direction: FlexDirection.Column }) {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
                Text('width')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')
                Text(this.strokeWidth.toFixed(0))
                  .fontSize('16fp')
                  .fontWeight(FontWeight.Medium)
              }

              Slider({
                value: this.strokeWidth,
                min: 1,
                max: 100,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF')
                .trackColor('#182431')
                .selectedColor('#007DFF')
                .width('100%')
                .showSteps(true)
                .showTips(true)
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.strokeWidth = value
                })
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }

          Column() {

            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text('Color')
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')
                  .fontWeight(FontWeight.Medium)
                Button({ type: ButtonType.Circle, stateEffect: true }) {
                  Text('+').fontColor('#ffffff').fontSize('16fp').fontWeight(FontWeight.Medium)
                }
                .width(22)
                .height(22)
                .backgroundColor('#000000')
                .onClick(() => {
                  let randomR = Math.floor(Math.random() * 255)
                  let randomG = Math.floor(Math.random() * 255)
                  let randomB = Math.floor(Math.random() * 255)
                  let rgb = `rgb(${randomR},${randomG},${randomB})`
                  this.colorList.push([rgb, 1])
                })
              }
              .width('100%')
              .height(24)

              Divider().color('#f2f2f2').margin({ top: 6, bottom: 6 })
              //show colorlist
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
                ForEach(this.colorList, (item, index) => {
                  Button() {
                    Row() {
                      Flex({ direction: FlexDirection.RowReverse, alignItems: ItemAlign.Center }) {
                        Text('X')
                          .fontSize('10fp')
                          .width(11)
                          .lineHeight(11)
                          .borderRadius(11)
                          .backgroundColor('rgba(0,0,0,0.2)')
                          .textAlign(TextAlign.Center)
                          .fontColor('#ffffff')
                          .onClick(() => {
                            if (this.colorList.length != 1) {
                              this.colorList.splice(index, 1)
                            } else {
                              AlertDialog.show({ message: 'at least one' })
                            }
                          })
                      }
                      .padding({ right: 2 })
                      .width('100%')
                      .height('100%')
                      .borderWidth(2)
                      .borderColor('#ffffff')
                      .borderRadius(24)
                    }
                    .width('100%')
                    .height('100%')
                    .borderWidth(2)
                    .borderColor(item[0])
                    .borderRadius(24)
                  }
                  .backgroundColor(item[0])
                  .fontColor('#ffffff')
                  .width(48)
                  .height(24)
                  .margin(2)
                })
              }
              .width('100%')
            }
            .width('100%')
            .padding(12)
            .borderRadius(24)
            .backgroundColor('#fff')
            .margin({ top: 8, bottom: 8 })
          }
        }
        .width('100%')
      }
      .height('35%')
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