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

import router from '@system.router';
import { NavigationBar } from "../../../common/components/navigationBar"

@Entry
@Component
struct ImageSample {
  private on: string = 'http://image.xtep.com.cn/util/upload/product/202112172037/20211217203719485D6769491555162288862AC9594BC346E.jpg'
  @State src: string = this.on;
  @State width: number = 0;
  @State height: number= 0;
  @State xWidth: number = 0;
  @State yHeight: number = 0;
  @State colOpacity: number = 1;
  @State Visibility1: string= 'Visible'
  @State Visibility2: string= 'None'
  @State Visibility3: string= 'None'
  @State Visibility4: string= 'None'
  @State Visibility5: string= 'None'
  @State Visibility6: string= 'None'
  @State objectFit: ImageFit = ImageFit.None
  @State objectRepeat: ImageRepeat = ImageRepeat.NoRepeat
  @State interpolation: ImageInterpolation = ImageInterpolation.None
  @State renderMode: ImageRenderMode = ImageRenderMode.Original
  @State borderStyle: BorderStyle = BorderStyle.Dashed
  @State align: Alignment = Alignment.Bottom

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: 'Image' })
      Column() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Column() {
            Row({ space: 4 }) {
              Image('/common/test1.jpg')
                .width('30%')
                .height('35%')
                .border({ width: 1 })
                .objectFit(ImageFit.Fill)
              Image('/common/test2.jpg')
                .alt('/common/test5.jpg')
                .width('30%')
                .height('35%')
                .border({ width: 1 })
                .objectFit(ImageFit.Fill)
                .syncLoad(false)
            }.margin({ bottom: 10 })

            Row({ space: 4 }) {
              Image($r("app.media.svg1a"))
                .width('30%')
                .height('35%')
                .border({ width: 1 })
                .objectFit(ImageFit.Fill)
              Image(this.src)
                .width('30%')
                .height('35%')
                .border({ width: 1 })
                .objectFit(ImageFit.Fill)
            }
          }.visibility(Visibility[this.Visibility1])

          Row({ space: 5 }) {
            Image('/common/test1.jpg')
              .border({ width: 1 })
              .borderStyle(BorderStyle.Dashed)
              .objectFit(this.objectFit)
              .width('50%')
              .height('50%')
          }.visibility(Visibility[this.Visibility2])

          Row({ space: 5 }) {
            Image('/common/test3.png')
              .border({ width: 1 })
              .borderStyle(BorderStyle.Dashed)
              .renderMode(this.renderMode)
              .width('30%')
              .height('30%')
            Image('/common/test3.png')
              .border({ width: 1 })
              .borderStyle(BorderStyle.Dashed)
              .sourceSize({ height: this.yHeight, width: this.xWidth })
              .objectFit(ImageFit.ScaleDown)
              .aspectRatio(1)
              .width('40%')
          }.visibility(Visibility[this.Visibility3])

          Row({ space: 5 }) {
            Image('/common/test3.png')
              .border({ width: 1 })
              .borderStyle(BorderStyle.Dashed)
              .interpolation(this.interpolation)
              .width('90%')
              .height('60%')
          }.visibility(Visibility[this.Visibility4])

          Row({ space: 5 }) {
            Image('')
              .alt($r("app.media.icon"))
              .border({ width: 1 })
              .borderStyle(BorderStyle.Dashed)
              .objectRepeat(this.objectRepeat)
              .objectFit(ImageFit.ScaleDown)
              .width('40%')
              .height('50%')
          }.visibility(Visibility[this.Visibility5])

          Row({ space: 5 }) {
            Image('/common/test5.jpg')
              .objectFit(ImageFit.Cover)
              .sourceSize({ width: 100, height: 100 })
              .width('30%')
              .height('30%')
              .onComplete((msg: {
                width: number,
                height: number
              }) => {
                this.width = msg.width
                this.height = msg.height
              })
              .onError(() => {
                console.info('load image fail')
              })
            Image($r("app.media.svg2a"))
              .border({ width: 1 })
              .borderStyle(BorderStyle.Dashed)
              .width('30%')
              .height('40%')
              .objectFit(ImageFit.Contain)
              .opacity(this.colOpacity)
              .onFinish(() => {
                this.colOpacity = 0.3
              })
          }.visibility(Visibility[this.Visibility6])
        }.width('100%')
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround }) {
        Button('default')
          .onClick(() => {
            this.Visibility1 = 'Visible', this.Visibility2 = 'None', this.Visibility3 = 'None',
            this.Visibility4 = 'None', this.Visibility5 = 'None', this.Visibility6 = 'None'
          })
          .fontSize('12fp')
          .borderRadius(14)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 12 })
        Button('objectFit')
          .onClick(() => {
            this.Visibility2 = 'Visible', this.Visibility1 = 'None', this.Visibility3 = 'None',
            this.Visibility4 = 'None', this.Visibility5 = 'None', this.Visibility6 = 'None'
          })
          .fontSize('12fp')
          .borderRadius(14)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 12 })
        Button('renderMode')
          .onClick(() => {
            this.Visibility3 = 'Visible', this.Visibility2 = 'None', this.Visibility1 = 'None',
            this.Visibility4 = 'None', this.Visibility5 = 'None', this.Visibility6 = 'None'
          })
          .fontSize('12fp')
          .borderRadius(14)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 12 })
        Button('interpolation')
          .onClick(() => {
            this.Visibility4 = 'Visible', this.Visibility2 = 'None', this.Visibility3 = 'None',
            this.Visibility1 = 'None', this.Visibility5 = 'None', this.Visibility6 = 'None'
          })
          .fontSize('12fp')
          .borderRadius(14)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 12 })
        Button('objectRepeat')
          .onClick(() => {
            this.Visibility5 = 'Visible', this.Visibility2 = 'None', this.Visibility3 = 'None',
            this.Visibility1 = 'None', this.Visibility4 = 'None', this.Visibility6 = 'None'
          })
          .fontSize('12fp')
          .borderRadius(14)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 12 })
        Button('event')
          .onClick(() => {
            this.Visibility6 = 'Visible', this.Visibility2 = 'None', this.Visibility3 = 'None',
            this.Visibility1 = 'None', this.Visibility5 = 'None', this.Visibility4 = 'None'
          })
          .fontSize('12fp')
          .borderRadius(14)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 12 })
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .borderRadius(24)
      .padding(12)
      .margin({ top: 24 })

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('width')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text('20%')
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .visibility(Visibility[this.Visibility1])
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('height')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text('30%')
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .visibility(Visibility[this.Visibility1])

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('objectFit')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.objectFit == 5 ? 'None' : this.objectFit == 1 ? 'Contain' :
                                                         this.objectFit == 0 ? 'Fill' : this.objectFit == 2 ? 'Cover' : 'ScaleDown'}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'None',
                action: () => {
                  this.objectFit = ImageFit.None
                }
              },
              {
                value: 'Contain',
                action: () => {
                  this.objectFit = ImageFit.Contain
                }
              },
              {
                value: 'Fill',
                action: () => {
                  this.objectFit = ImageFit.Fill
                }
              },
              {
                value: 'Cover',
                action: () => {
                  this.objectFit = ImageFit.Cover
                }
              },
              {
                value: 'ScaleDown',
                action: () => {
                  this.objectFit = ImageFit.ScaleDown
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: "-8vp" })
          .visibility(Visibility[this.Visibility2])

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('renderMode')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.renderMode == 0 ? 'Original' : 'Template'}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'Original',
                action: () => {
                  this.renderMode = ImageRenderMode.Original
                }
              },
              {
                value: 'Template',
                action: () => {
                  this.renderMode = ImageRenderMode.Template
                }
              }
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: "-8vp" })
          .visibility(Visibility[this.Visibility3])

          Flex({ direction: FlexDirection.Column }) {
            Text('sourceSize')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Row() {
              Text('x')
                .fontSize('16fp')
                .opacity(0.5)
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
              Slider({
                value: this.xWidth,
                min: 0,
                max: 300,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF')
                .trackColor('#182431')
                .selectedColor('#007DFF')
                .showSteps(true)
                .showTips(true)
                .width('80%')
                .onChange((value: number) => {
                  this.xWidth = value
                  this.yHeight += 0.001
                })
              Text(this.xWidth.toFixed())
                .fontSize('16fp')
                .opacity(0.5)
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
            }.width('80%')
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .visibility(Visibility[this.Visibility3])

          Flex({ direction: FlexDirection.Column }) {
            Text('sourceSize')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Row() {
              Text('y')
                .fontSize('16fp')
                .opacity(0.5)
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
              Slider({
                value: this.yHeight,
                min: 10,
                max: 300,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF')
                .trackColor('#182431')
                .selectedColor('#007DFF')
                .showSteps(true)
                .showTips(true)
                .width('80%')
                .onChange((value: number) => {
                  this.yHeight = value
                  this.xWidth += 0.001
                })
              Text(this.yHeight.toFixed(0)).fontSize(16)
            }.width('80%')
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8, bottom: 8 })
          .visibility(Visibility[this.Visibility3])

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('interpolation')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.interpolation == 0 ? 'None' : this.interpolation == 3 ? 'High'
                                                                                 : this.interpolation == 2 ? 'Medium' : 'Low'}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'None',
                action: () => {
                  this.interpolation = ImageInterpolation.None
                }
              },
              {
                value: 'High',
                action: () => {
                  this.interpolation = ImageInterpolation.High
                }
              },
              {
                value: 'Medium',
                action: () => {
                  this.interpolation = ImageInterpolation.Medium
                }
              },
              {
                value: 'Low',
                action: () => {
                  this.interpolation = ImageInterpolation.Low
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .margin({ top: "-16vp" })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .visibility(Visibility[this.Visibility4])

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('objectRepeat')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.objectRepeat == 0 ? 'NoRepeat' : this.objectRepeat == 1 ? 'X'
                                                                                   : this.objectRepeat == 2 ? 'Y' : 'XY'}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'NoRepeat',
                action: () => {
                  this.objectRepeat = ImageRepeat.NoRepeat
                }
              },
              {
                value: 'X',
                action: () => {
                  this.objectRepeat = ImageRepeat.X
                }
              },
              {
                value: 'Y',
                action: () => {
                  this.objectRepeat = ImageRepeat.Y
                }
              },
              {
                value: 'XY',
                action: () => {
                  this.objectRepeat = ImageRepeat.XY
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .margin({ top: "-16vp" })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .visibility(Visibility[this.Visibility5])

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('onComplete')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text('msg.width')
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .margin({ top: "-16vp" })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .visibility(Visibility[this.Visibility6])

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('onFinish')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text('opacity')
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: "-8vp", bottom: 8 })
          .visibility(Visibility[this.Visibility6])
        }.width('100%')
      }.width('100%').height('25%')
    }
    .width('100%')
    .backgroundColor('#F1F1F5')
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