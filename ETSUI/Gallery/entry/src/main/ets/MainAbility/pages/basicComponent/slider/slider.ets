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
struct SliderSample {
  @State setValue: number = 10;
  @State blockColor: string = 'rgba(225,225,225,1)';
  @State trackColor: string = 'rgba(88,87,86,0.8)';
  @State selectColor: string = 'rgba(0,125,225,1)';
  @State direction: Axis = Axis.Horizontal;
  @State directionStyle: string = 'Horizontal';
  @State setSliderShowSteps: boolean = true;
  @State setSliderShowTips: boolean = true;
  @State setSliderStep: number = 1;
  @State setSliderStyle: SliderStyle = SliderStyle.OutSet;
  @State sliderstyle: string = 'Outset'

  build() {
    Flex({ direction: FlexDirection.Column }) {
      NavigationBar({ title: 'Slider' })

      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Text('slider')
              .fontSize('24fp')
              .fontWeight(FontWeight.Medium)
              .margin({ right: '10%' })
            Row() {
              Slider({
                value: this.setValue,
                min: 0,
                max: 100,
                step: this.setSliderStep,
                style: this.setSliderStyle,
                direction: this.direction
              })
                .width('90%')
                .blockColor(this.blockColor)
                .trackColor(this.trackColor)
                .selectedColor(this.selectColor)
                .showTips(this.setSliderShowTips)
                .showSteps(this.setSliderShowSteps)
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.setValue = value
                  console.info('value:' + value + 'mode:' + mode.toString())
                })
              Text(this.setValue.toFixed(0)).fontSize('16fp')
            }
            .width('100%')
          }
          .width('100%')
          .height('100%')
        }
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .width('100%')
      .padding(18)
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {

            Text('blockColor')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              GetColor({ colorVal: $blockColor })
            }.width(48)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('trackColor')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              GetColor({ colorVal: $trackColor })
            }.width(48)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('selectColor')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              GetColor({ colorVal: $selectColor })
            }.width(48)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('slider step')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              Text(`${this.setSliderStep}`)
                .fontWeight(FontWeight.Regular)
                .fontColor('#000000')
                .fontSize('10fp')
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: '1',
                action: () => {
                  console.info('handle Menu1 select')
                  this.setSliderStep = 1
                }
              },
              {
                value: '10',
                action: () => {
                  console.info('handle Menu2 select')
                  this.setSliderStep = 10
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('slider showSteps')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Toggle({ type: ToggleType.Switch, isOn: this.setSliderShowSteps })
              .width(35)
              .height(20)
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                console.info('Component status:' + isOn)
                this.setSliderShowSteps = !this.setSliderShowSteps
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('slider showTips')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Toggle({ type: ToggleType.Switch, isOn: this.setSliderShowTips })
              .width(35)
              .height(20)
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                console.info('Component status:' + isOn)
                this.setSliderShowTips = !this.setSliderShowTips
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('slider style')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              Text(`${this.sliderstyle}`)
                .fontWeight(FontWeight.Regular)
                .fontColor('#000000')
                .fontSize('10fp')
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'InSet',
                action: () => {
                  console.info('handle Menu1 select')
                  this.setSliderStyle = SliderStyle.InSet
                  this.sliderstyle = 'Inset'

                }
              },
              {
                value: 'OutSet',
                action: () => {
                  console.info('handle Menu2 select')
                  this.setSliderStyle = SliderStyle.OutSet
                  this.sliderstyle = 'OutSet'
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('direction')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              Text(`${this.directionStyle}`)
                .fontWeight(FontWeight.Regular)
                .fontColor('#000000')
                .fontSize('10fp')
            }
            .bindMenu([
              {
                value: 'Horizontal',
                action: () => {
                  console.info('handle Menu1 select')
                  this.direction = Axis.Horizontal
                  this.directionStyle = 'Horizontal'
                }
              },
              {
                value: 'Vertical',
                action: () => {
                  console.info('handle Menu2 select')
                  this.direction = Axis.Vertical
                  this.directionStyle = 'Vertical'
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8, bottom: 16 })
        }
      }
      .width('100%')
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