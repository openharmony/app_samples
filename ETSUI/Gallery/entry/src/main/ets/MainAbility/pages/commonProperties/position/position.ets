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
struct PositionSample {
  @State direction: string = "Rtl"
  @State align: string = "Center"
  @State positionX: number = 0
  @State positionY: number = 0
  @State markX: number = 0
  @State markY: number = 0
  @State showX: string = '0'
  @State showY: string = '0'

  build() {
    Flex({ direction: FlexDirection.Column }) {
      NavigationBar({ title: '位置设置' })
      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Flex() {
              Text('1').height('100%').width('25%').fontSize(20).backgroundColor(0x317aff)
              Text('2').height('100%').width('25%').fontSize(20).backgroundColor('#FFFFFF')
              Text('3').height('100%').width('25%').fontSize(20).backgroundColor(0x317aff)
              Text('4').height('100%').width('25%').fontSize(20).backgroundColor('#FFFFFF')
            }
            .width('80%')
            .height('30%')
            .margin({ top: '30%', bottom: '30%' })
            .border({ width: 1, color: 0x317aff })
            .direction(Direction[this.direction])

            Row({ space: 20 }) {
              Text('position(' + `${this.showX}` + '%, ' + `${this.showY}` + '%)')
                .size({ width: '100%', height: '100%' }).backgroundColor(0x317aff)
                .fontSize(20).align(Alignment[this.align])
              Image($r('app.media.icon'))
                .size({ width: '12%', height: '50%' })
                .markAnchor({ x: `${this.markX}` + '%', y: `${this.markY}` + '%' })
                .position({ x: `${this.positionX}` + '%', y: `${this.positionY}` + '%' })
            }.width('80%').height('25%').backgroundColor(0x317aff)

          }
          .width('100%')
        }
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .width('100%')
      .backgroundColor('#FFFFFF')
      .padding(18)

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('direction')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              Text(`${this.direction}`)
                .fontWeight(FontWeight.Regular)
                .fontColor('#000000')
                .fontSize('10fp')
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'Rtl',
                action: () => {
                  this.direction = "Rtl"
                }
              },
              {
                value: 'Ltr',
                action: () => {
                  this.direction = "Ltr"
                }
              },
              {
                value: 'Auto',
                action: () => {
                  this.direction = "Auto"
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('align')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              Text(`${this.align}`)
                .fontWeight(FontWeight.Regular)
                .fontColor('#000000')
                .fontSize('10fp')
                .width('50%')
                .textAlign(TextAlign.End)
            }
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
          .margin({ top: 8 })

          Flex({ direction: FlexDirection.Column }) {
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
              Text('position(x)')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')

              Text(`${this.positionX.toFixed(0)}` + '%')
                .fontWeight(FontWeight.Regular)
                .fontColor('#000000')
                .fontSize('10fp')
            }

            Slider({
              value: this.positionX,
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
              .width('100%')
              .onChange((value: number, mode: SliderChangeMode) => {
                this.positionX = value
                this.showX = this.positionX.toFixed(0).toString()
                console.info('value:' + value + 'mode:' + mode.toString())
                console.info('value:' + value + 'mode:' + mode.toString())
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })


          Flex({ direction: FlexDirection.Column }) {
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
              Text('position(y)')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Text(`${this.positionY.toFixed(0)}` + '%')
                .fontWeight(FontWeight.Regular)
                .fontColor('#000000')
                .fontSize('10fp')
            }

            Slider({
              value: this.positionY,
              min: 0,
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
                this.positionY = value
                this.showY = this.positionY.toFixed(0).toString()
                console.info('value:' + value + 'mode:' + mode.toString())
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ direction: FlexDirection.Column }) {
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
              Text('markAnchor(x)')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')

              Text(`${this.markX.toFixed(0)}` + '%')
                .fontWeight(FontWeight.Regular)
                .fontColor('#000000')
                .fontSize('10fp')

            }

            Slider({
              value: this.markX,
              min: 0,
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
                this.markX = value
                console.info('value:' + value + 'mode:' + mode.toString())
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ direction: FlexDirection.Column }) {
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
              Text('markAnchor(y)')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')


              Text(`${this.markY.toFixed(0)}` + '%')
                .fontWeight(FontWeight.Regular)
                .fontColor('#000000')
                .fontSize('10fp')


            }

            Slider({
              value: this.markY,
              min: 0,
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
                this.markY = value
                console.info('value:' + value + 'mode:' + mode.toString())
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }.padding({ bottom: 150 })
      }
      .width('100%')
      .height('75%')
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

