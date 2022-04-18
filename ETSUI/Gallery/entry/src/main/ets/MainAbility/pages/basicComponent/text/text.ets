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
struct TextSpanSample {
  @State textAlign: string = "Center";
  @State textOverflow: string = "None";
  @State maxLines: number = 20;
  @State lineHeight: number = 25;
  @State decoration: string = "None";
  @State decorationLineColor: string = "rgba(0,0,0,1)";
  @State baselineOffset: number = 10;
  @State textCase: string = "Normal";
  @State fontSize: number = 20;
  @State fontWeight: number = 200;
  @State fontColor: string = "rgba(0,0,0,1)";
  @State fontstyle: string = "Normal";
  @State fontFamily: string = "Microsoft YaHei";

  build() {
    Flex({ direction: FlexDirection.Column }) {

      NavigationBar({ title: 'Text' })

      Scroll() {
        Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Column }) {
          Text("我能吞下玻璃而不伤身体。我能吞下玻璃而不伤身体。我能吞下玻璃而不伤身体。我能吞下玻璃而不伤身体。"
          + "我能吞下玻璃而不伤身体。我能吞下玻璃而不伤身体。我能吞下玻璃而不伤身体。我能吞下玻璃而不伤身体。" +
          "我能吞下玻璃而不伤身体。我能吞下玻璃而不伤身体。我能吞下玻璃而不伤身体。我能吞下玻璃而不伤身体。")
            .width("100%")
            .height("60%")
            .textAlign(TextAlign[this.textAlign])
            .textOverflow({ overflow: TextOverflow[this.textOverflow] })
            .maxLines(this.maxLines)
            .lineHeight(this.lineHeight)
            .decoration({ type: TextDecorationType[this.decoration], color: this.decorationLineColor })
            .fontSize(this.fontSize)
            .fontWeight(this.fontWeight)
            .fontColor(this.fontColor)
            .fontStyle(FontStyle[this.fontstyle])
            .fontFamily(this.fontFamily)
            .baselineOffset(this.baselineOffset)

          Text("I can eat glass, it doesn't hurt me.")
            .textAlign(TextAlign[this.textAlign])
            .textOverflow({ overflow: TextOverflow[this.textOverflow] })
            .maxLines(this.maxLines)
            .lineHeight(this.lineHeight)
            .decoration({ type: TextDecorationType[this.decoration], color: this.decorationLineColor })
            .fontSize(this.fontSize)
            .fontWeight(this.fontWeight)
            .fontColor(this.fontColor)
            .fontStyle(FontStyle[this.fontstyle])
            .fontFamily(this.fontFamily)
            .textCase(TextCase[this.textCase])
            .baselineOffset(this.baselineOffset)
            .margin({ top: 20 })
        }
        .height("100%")
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .backgroundColor('#E6E6FA')

      Scroll() {
        Column() {

          Text('Text组件属性')
            .fontSize(20)
            .width("100%")
            .padding({ left: '3%', right: '3%' })
            .border({ width: 1, color: "#eee", radius: 10 })
            .margin({ top: 40, bottom: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {

            Text('textAlign')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.textAlign)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
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
              },
            ])
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height("15%")

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('textOverflow')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.textOverflow)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: 'None',
                action: () => {
                  this.textOverflow = "None"
                  this.maxLines = 3
                }
              },
              {
                value: 'Clip',
                action: () => {
                  this.textOverflow = "Clip"
                  this.maxLines = 1
                }
              },
              {
                value: 'Ellipsis',
                action: () => {
                  this.textOverflow = "Ellipsis"
                  this.maxLines = 1
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
            Text('maxLines')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text("" + this.maxLines)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: '1',
                action: () => {
                  this.maxLines = 1
                }
              },
              {
                value: '2',
                action: () => {
                  this.maxLines = 2
                }
              },
              {
                value: '3',
                action: () => {
                  this.maxLines = 3
                }
              },
              {
                value: '20',
                action: () => {
                  this.maxLines = 20
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
            Text('lineHeight')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text('' + this.lineHeight)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: '25',
                action: () => {
                  this.lineHeight = 25
                }
              },
              {
                value: '30',
                action: () => {
                  this.lineHeight = 30
                }
              },
              {
                value: '35',
                action: () => {
                  this.lineHeight = 35
                }
              },
              {
                value: '40',
                action: () => {
                  this.lineHeight = 40
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
            Text('textDecoration')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.decoration)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: 'Overline',
                action: () => {
                  this.decoration = "Overline"
                }
              },
              {
                value: 'LineThrough',
                action: () => {
                  this.decoration = "LineThrough"
                }
              },
              {
                value: 'Underline',
                action: () => {
                  this.decoration = "Underline"
                },
              },
              {
                value: 'None',
                action: () => {
                  this.decoration = "None"
                },
              }
            ])
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height("15%")

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('lineColor')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              GetColor({ colorVal: $decorationLineColor })
            }.width(48)
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height("15%")

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('textCase')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.textCase)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
            }
            .bindMenu([
              {
                value: 'Normal',
                action: () => {
                  this.textCase = "Normal"
                }
              },
              {
                value: 'LowerCase',
                action: () => {
                  this.textCase = "LowerCase"
                }
              },
              {
                value: 'UpperCase',
                action: () => {
                  this.textCase = "UpperCase"
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
            Text('baselineOffset')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text('' + this.baselineOffset)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: '-10',
                action: () => {
                  this.baselineOffset = -10
                }
              },
              {
                value: '10',
                action: () => {
                  this.baselineOffset = 10
                }
              },
            ])
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height("15%")


          Text('文本通用属性')
            .fontSize(20)
            .width("100%")
            .padding({ left: '3%', right: '3%' })
            .border({ width: 1, color: "#eee", radius: 10 })
            .margin({ top: 24, bottom: 10 })

          Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            Text("fontSize")
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Row() {
              Slider({
                value: this.fontSize,
                min: 14,
                max: 30,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF ')
                .trackColor('rgba(24,36,49,0.2)')
                .selectedColor('#007DFF')
                .borderRadius(12)
                .showTips(true)
                .onChange((value: number) => {
                  this.fontSize = value
                })
              Text(this.fontSize.toFixed(0)).fontSize(16)
            }.width("70%")
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height("15%")

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('fontWeight')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text('' + this.fontWeight)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: '300',
                action: () => {
                  this.fontWeight = 300
                }
              },
              {
                value: '500',
                action: () => {
                  this.fontWeight = 500
                }
              },
              {
                value: '700',
                action: () => {
                  this.fontWeight = 700
                }
              },
              {
                value: '900',
                action: () => {
                  this.fontWeight = 900
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
            Text('fontColor')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              GetColor({ colorVal: $fontColor })
            }.width(48)
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height("15%")

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('fontStyle')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.fontstyle)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: 'Normal',
                action: () => {
                  this.fontstyle = "Normal"
                }
              },
              {
                value: 'Italic',
                action: () => {
                  this.fontstyle = "Italic"
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
            Text('fontFamily')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.fontFamily)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: 'Microsoft YaHei',
                action: () => {
                  this.fontFamily = "Microsoft YaHei"
                }
              },
              {
                value: 'FangSong',
                action: () => {
                  this.fontFamily = "FangSong"
                }
              },
              {
                value: 'SimHei',
                action: () => {
                  this.fontFamily = "SimHei"
                }
              },
              {
                value: 'KaiTi',
                action: () => {
                  this.fontFamily = "KaiTi"
                }
              }
            ])
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8, bottom: 13 })
          .height("15%")
        }
        .width('97%')
        .margin({ right: "3%", bottom: 5 })
      }
      .width('100%')
      .height('60%')
      .margin({ top: 24 })
    }
    .padding({ left: '3%', right: '3%', bottom: 10 })
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
