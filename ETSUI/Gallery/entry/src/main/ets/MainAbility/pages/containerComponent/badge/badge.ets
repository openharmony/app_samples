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
struct BadgeSample {
  @State showType: string = "1"
  @State position: number = 0
  @State fontSize: number = 40
  @State badgeSize: number = 80
  @State count: number = 1
  @State maxCount: number = 99
  @State message: string = 'new'
  @State changeColor: string = 'rgba(255,255,255,1)'
  @State badgeColor: string = 'red'

  build() {
    Flex({ direction: FlexDirection.Column }) {
      NavigationBar({ title: 'Badge' })
      Scroll() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          if (this.showType == '1') {
            Badge({
              position: this.position,
              count: this.count,
              maxCount: this.maxCount,
              style: {
                color: this.changeColor,
                fontSize: this.fontSize,
                badgeSize: this.badgeSize,
                badgeColor: this.badgeColor
              }
            }) {
              Button('message')
                .onClick(() => {
                  this.count++
                })
                .width('100%')
                .height('100%')
                .backgroundColor(0x317aff)
                .fontSize(40)
            }.width('40%').height('30%')
          } else if (this.showType == '2') {
            Badge({
              position: this.position,
              value: this.message,
              style: {
                color: this.changeColor,
                fontSize: this.fontSize,
                badgeSize: this.badgeSize,
                badgeColor: Color.Blue,
              }
            }) {
              Text('message')
                .width('100%')
                .height('100%')
                .fontSize(40)
                .lineHeight(37)
                .borderRadius(15)
                .textAlign(TextAlign.Center)
                .backgroundColor(0xF3F4ED)
                .fontSize(40)

            }.width('40%').height('25%')
          } else if (this.showType == '3') {
            Badge({
              value: '',
              position: this.position,
              style: { badgeSize: this.badgeSize, badgeColor: this.badgeColor }
            }) {
              Text('message')
                .width('100%')
                .height('100%')
                .fontSize(this.fontSize)
                .lineHeight(37)
                .borderRadius(15)
                .textAlign(TextAlign.Center)
                .backgroundColor(0xF3F4ED)
            }.width('40%').height('25%')
          }
        }.width('100%').height('100%')
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .width('100%')
      .height('40%')
      .backgroundColor('#FFB6C1')

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('type')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.showType}`)
                .width('50%')
                .textAlign(TextAlign.End)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
            }
            .bindMenu([
              {
                value: '1',
                action: () => {
                  this.showType = "1"
                  this.showType = '1'
                  this.fontSize = 40
                  this.badgeSize = 80
                  this.badgeColor = 'red'
                  this.position = 0
                }
              },
              {
                value: '2',
                action: () => {
                  this.showType = "2"
                  this.showType = '2'
                  this.fontSize = 40
                  this.badgeSize = 60
                  this.badgeColor = 'blue'
                  this.position = 0
                }
              },
              {
                value: '3',
                action: () => {
                  this.showType = "3"
                  this.showType = '3'
                  this.position = 1
                  this.badgeColor = 'red'
                  this.badgeSize = 30
                }
              },
            ])
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('position')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.position}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'RightTop',
                action: () => {
                  this.position = 0
                }
              },
              {
                value: 'Right',
                action: () => {
                  this.position = 1
                }
              },
              {
                value: 'Left',
                action: () => {
                  this.position = 2
                }
              }
            ])
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })


          if (this.showType == '1') {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('count')
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
              Column() {
                Row() {
                  Slider({
                    value: this.count,
                    min: 0,
                    max: 100,
                    step: 1,
                    style: SliderStyle.OutSet
                  })
                    .blockColor('#FFFFFF')
                    .trackColor('#183431')
                    .selectedColor('#007DFF')
                    .borderRadius(12)
                    .borderColor('rgba(0,0,0,0.04)')
                    .showSteps(true)
                    .showTips(true)
                    .width('95%')
                    .onChange((value: number) => {
                      this.count = value
                    })
                  Text(this.count.toFixed(0))
                    .fontSize('16fp')
                    .fontColor('#182431')
                    .fontWeight(FontWeight.Medium)
                }
                .width('80%')
              }
            }
            .padding('3%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('maxCount')
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
              Column() {
                Row() {
                  Slider({
                    value: this.maxCount,
                    min: 0,
                    max: 100,
                    step: 1,
                    style: SliderStyle.OutSet
                  })
                    .blockColor('#FFFFFF')
                    .trackColor('#183431')
                    .selectedColor('#007DFF')
                    .borderRadius(12)
                    .showSteps(true)
                    .showTips(true)
                    .width('95%')
                    .onChange((value: number) => {
                      this.maxCount = value
                    })
                  Text(this.maxCount.toFixed(0)).fontSize(16)
                }.width('80%')
              }
            }
            .padding('3%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }

          if (this.showType == '2') {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('value')
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
              Column() {
                TextInput({ placeholder: '' })
                  .type(InputType.Normal)
                  .placeholderColor(Color.Blue)
                  .placeholderFont({ size: 25, weight: FontWeight.Normal, family: "Arial", style: FontStyle.Normal })
                  .enterKeyType(EnterKeyType.Next)
                  .caretColor(Color.Green)
                  .height('60%')
                  .width('20%')
                  .fontSize(25)
                  .fontWeight(FontWeight.Bold)
                  .fontFamily("cursive")
                  .fontStyle(FontStyle.Italic)
                  .borderRadius('50%')
                  .fontColor(Color.Red)
                  .maxLength(20)
                  .onChange((value: string) => {
                    this.message = value
                  })
              }
            }
            .width('100%')
            .height(70)
            .padding({ left: '3%', right: '3%' })
            .borderRadius(10)
            .backgroundColor('#B0E0E6')
            .margin({ bottom: 8 })
          }

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('fontSize')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Row() {
                Slider({
                  value: this.fontSize,
                  min: 0,
                  max: 100,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#183431')
                  .selectedColor('#007DFF')
                  .borderRadius(12)
                  .showSteps(true)
                  .showTips(true)
                  .width('95%')
                  .onChange((value: number) => {
                    this.fontSize = value
                    if (this.fontSize > this.badgeSize - 10) {
                      this.fontSize = this.badgeSize - 10
                    }
                  })
                Text(this.fontSize.toFixed(0)).fontSize(16)
              }.width('80%')
            }
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('badgeSize')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Row() {
                Slider({
                  value: this.badgeSize,
                  min: 0,
                  max: 100,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#183431')
                  .selectedColor('#007DFF')
                  .borderRadius(12)
                  .showSteps(true)
                  .showTips(true)
                  .width('95%')
                  .onChange((value: number) => {
                    this.badgeSize = value
                  })
                Text(this.badgeSize.toFixed(0)).fontSize(16)
              }.width('80%')
            }
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          if (this.showType !== '3') {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('color')
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)
              Row() {
                GetColor({ colorVal: $changeColor })
              }.width('20%')
            }
            .width('100%')
            .height(70)
            .padding('3%')
            .borderRadius(10)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('badgeColor')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Row() {
              GetColor({ colorVal: $badgeColor })
            }.width('20%')
          }
          .height(70)
          .padding('3%')
          .borderRadius(10)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
      }
      .width('100%')
      .height('45%')
      .margin({ top: 24 })
    }
    .height('100%')
    .padding({ left: '3%', right: '3%', bottom: 10 })
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
