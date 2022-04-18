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
struct TextAreaSample {
  @State placeholderColor: string = "rgba(0,0,0,1)";
  @State placeholderfontSize: number = 20;
  @State placeholderfontWeight: number = 200;
  @State placeholderfontFamily: string = "Microsoft YaHei";
  @State placeholderfontStyle: string = "Normal";
  @State textAlign: string = "Start"
  @State caretColor: string = "rgba(0,0,0,1)";
  @State bgColor: string = "#E6E6FA";
  @State textString: string = ""

  build() {

    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {

      NavigationBar({ title: 'TextArea' })

      Scroll() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Text('文本显示框')
            .fontSize(24)
            .margin({ bottom: 30 })
            .textAlign(TextAlign.Center)

          Text(this.textString)
            .fontSize(18).width("100%").textAlign(TextAlign.Start)
        }
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .width('100%')
      .backgroundColor('#eee')

      Text('textArea输入框')
        .width('100%')
        .height("4%")
        .fontSize(16)
        .fontColor("#111")
        .padding({ left: '3%' })
        .margin({ top: 8 })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        TextArea({ placeholder: 'input your word textArea' })
          .height("100%")
          .textAlign(TextAlign[this.textAlign])
          .placeholderColor(this.placeholderColor)
          .placeholderFont({
            size: this.placeholderfontSize,
            weight: this.placeholderfontWeight,
            family: this.placeholderfontFamily,
            style: FontStyle[this.placeholderfontStyle],
          })
          .caretColor(this.caretColor)
          .onChange((value: string) => {
            this.textString = value
          })
      }
      .height("6%")
      .padding({ right: 10 })

      Scroll() {
        Column() {

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('placeholderColor').fontSize(16).fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              GetColor({ colorVal: $placeholderColor })
            }.width(48)
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .height("15%")


          Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            Text("placeholderfontSize")
              .fontSize('16')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Row() {
              Slider({
                value: this.placeholderfontSize,
                min: 5,
                max: 26,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF')
                .trackColor('rgba(24,36,49,0.2)')
                .selectedColor('#007DFF')
                .borderRadius(12)
                .showTips(true)
                .onChange((value: number) => {
                  this.placeholderfontSize = value

                })
              Text(this.placeholderfontSize.toFixed(0)).fontSize(18)
            }.width("49%")
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height("15%")

          Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            Text("placeholderfontWeight")
              .fontSize('16')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Row() {
              Slider({
                value: this.placeholderfontWeight,
                min: 100,
                max: 900,
                step: 100,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF')
                .trackColor('rgba(24,36,49,0.2)')
                .selectedColor('#007DFF')
                .borderRadius(12)
                .showTips(true)
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.placeholderfontWeight = value
                  console.log(`${mode}`)
                })
              Text(this.placeholderfontWeight.toFixed(0)).fontSize(18)
            }.width("40%")
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height("15%")

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('placeholderfontFamily')
              .fontSize('16')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.placeholderfontFamily)
                .fontSize('16')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
            }
            .bindMenu([
              {
                value: 'Microsoft YaHei',
                action: () => {
                  this.placeholderfontFamily = "Microsoft YaHei"
                }
              },
              {
                value: 'FangSong',
                action: () => {
                  this.placeholderfontFamily = "FangSong"
                }
              },
              {
                value: 'SimHei',
                action: () => {
                  this.placeholderfontFamily = "SimHei"
                }
              },
              {
                value: 'KaiTi',
                action: () => {
                  this.placeholderfontFamily = "KaiTi"
                }
              }
            ])
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height("15%")

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('placeholderfontStyle')
              .fontSize('16')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.placeholderfontStyle)
                .fontSize('16')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
            }
            .bindMenu([
              {
                value: 'Normal',
                action: () => {
                  this.placeholderfontStyle = "Normal"
                }
              },
              {
                value: 'Italic',
                action: () => {
                  this.placeholderfontStyle = "Italic"
                }
              },
            ])
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height("15%")

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('textAlign')
              .fontSize('16')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.textAlign)
                .fontSize('16')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
            }
            .bindMenu([
              {
                value: 'Start',
                action: () => {
                  this.textAlign = "Start"
                }
              },
              {
                value: 'Center',
                action: () => {
                  this.textAlign = "Center"
                }
              },
              {
                value: 'End',
                action: () => {
                  this.textAlign = "End"
                }
              }
            ])
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height("15%")

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('caretColor')
              .fontSize('16')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              GetColor({ colorVal: $caretColor })
            }.width(48)
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height("15%")

        }
        .width('97%')
        .margin({ right: "3%" })
      }
      .width('100%')
      .height('45%')
      .margin({ top: 28 })
    }
    .height('100%')
    .padding({ left: '3%', right: '3%' })
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