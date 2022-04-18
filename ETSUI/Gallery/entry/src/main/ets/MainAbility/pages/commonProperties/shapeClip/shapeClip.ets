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
struct ShapeClipSample {
  @State showType: string = "clip"
  @State clip: string = "false"
  @State clipWidth: number = 250
  @State clipHeight: number = 250
  @State mask: string = "Rect"
  @State maskWidth: number = 250
  @State maskHeight: number = 250

  build() {
    Flex({ direction: FlexDirection.Column }) {
      NavigationBar({ title: '形状裁剪' })
      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              if (this.showType == 'clip') {
                if (this.clip == 'false') {
                  Column() {
                    Image('/common/test4.jpg').width('100%').height('100%')
                  }
                  .width('80%').height('80%')
                  .clip(false)
                  .borderRadius(20)
                } else if (this.clip == 'Rect') {
                  Column() {
                    Image('/common/test4.jpg').width('100%').height('100%')
                  }
                  .width(250).height(250)
                  .clip(new Rect({ width: this.clipWidth, height: this.clipHeight }))
                  .borderRadius(20)
                } else if (this.clip == 'Circle') {
                  Column() {
                    Image('/common/test4.jpg').width('100%').height('100%')
                  }
                  .width(250).height(250)
                  .clip(new Circle({ width: this.clipWidth, height: this.clipHeight }))
                  .borderRadius(20)
                }
              } else if (this.showType == 'mask') {
                if (this.mask == 'Rect') {
                  Column() {
                    Image('/common/test4.jpg').width('100%').height('100%')
                  }
                  .width(250).height(250)
                  .mask(new Rect({ width: this.maskWidth, height: this.maskHeight }).fill(Color.Gray))
                  .borderRadius(20)
                } else if (this.mask == 'Circle') {
                  Column() {
                    Image('/common/test4.jpg').width('100%').height('100%')
                  }
                  .width(250).height(250)
                  .mask(new Circle({ width: this.maskWidth, height: this.maskHeight }).fill(Color.Gray))
                  .borderRadius(20)
                }
              }
            }.width('100%').height('100%')
          }
          .width('100%')
        }
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .width('100%')
      .padding(18)
      .backgroundColor('#FFFFFF')


      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('属性')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              Text(`${this.showType}`)
                .fontWeight(FontWeight.Regular)
                .fontColor('#000000')
                .fontSize('10fp')
            }
            .bindMenu([
              {
                value: 'clip',
                action: () => {
                  this.showType = "clip"
                }
              },
              {
                value: 'mask',
                action: () => {
                  this.showType = "mask"
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          if (this.showType == 'clip') {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('clip')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Column() {
                Text(`${this.clip}`)
                  .fontWeight(FontWeight.Regular)
                  .fontColor('#000000')
                  .fontSize('10fp')
              }
              .bindMenu([
                {
                  value: 'false',
                  action: () => {
                    this.clip = "false"
                  }
                },
                {
                  value: 'Rect',
                  action: () => {
                    this.clip = "Rect"
                  }
                },
                {
                  value: 'Circle',
                  action: () => {
                    this.clip = "Circle"
                  }
                },
              ])
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })

            if (this.clip !== 'false') {
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text('clipWidth')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')
                Column() {
                  Row() {
                    Slider({
                      value: this.clipWidth,
                      min: 0,
                      max: 250,
                      step: 1,
                      style: SliderStyle.OutSet
                    })
                      .blockColor('#FFFFFF')
                      .trackColor('#182431')
                      .selectedColor('#007DFF')
                      .width('100%')
                      .showSteps(true)
                      .showTips(true)
                      .onChange((value: number) => {
                        this.clipWidth = value
                      })
                    Text(this.clipWidth.toFixed(0))
                      .fontWeight(FontWeight.Regular)
                      .fontColor('#000000')
                      .fontSize('10fp')
                      .width('50%')
                      .textAlign(TextAlign.End)
                  }.width('80%')
                }
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })

              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text('clipHeight')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')
                Column() {
                  Row() {
                    Slider({
                      value: this.clipHeight,
                      min: 0,
                      max: 250,
                      step: 1,
                      style: SliderStyle.OutSet
                    })
                      .blockColor('#FFFFFF')
                      .trackColor('#182431')
                      .selectedColor('#007DFF')
                      .width('100%')
                      .showSteps(true)
                      .showTips(true)
                      .onChange((value: number) => {
                        this.clipHeight = value
                      })
                    Text(this.clipHeight.toFixed(0))
                      .fontWeight(FontWeight.Regular)
                      .fontColor('#000000')
                      .fontSize('10fp')
                      .width('50%')
                      .textAlign(TextAlign.End)
                  }.width('80%')
                }
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })
            }
          } else if (this.showType == 'mask') {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('mask')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Column() {
                Text(`${this.mask}`)
                  .fontWeight(FontWeight.Regular)
                  .fontColor('#000000')
                  .fontSize('10fp')
              }
              .bindMenu([
                {
                  value: 'Rect',
                  action: () => {
                    this.mask = "Rect"
                  }
                },
                {
                  value: 'Circle',
                  action: () => {
                    this.mask = "Circle"
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
                Text('maskWidth')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')

                Text(this.maskWidth.toFixed(0))
                  .fontWeight(FontWeight.Regular)
                  .fontColor('#000000')
                  .fontSize('16fp')
              }

              Slider({
                value: this.maskWidth,
                min: 0,
                max: 250,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF')
                .trackColor('#182431')
                .selectedColor('#007DFF')
                .width('100%')
                .showSteps(true)
                .showTips(true)
                .onChange((value: number) => {
                  this.maskWidth = value
                })
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })

            Flex({ direction: FlexDirection.Column }) {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
                Text('maskHeight')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')

                Text(this.maskHeight.toFixed(0))
                  .fontWeight(FontWeight.Regular)
                  .fontColor('#000000')
                  .fontSize('16fp')
              }

              Slider({
                value: this.maskHeight,
                min: 0,
                max: 250,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF')
                .trackColor('#182431')
                .selectedColor('#007DFF')
                .width('100%')
                .showSteps(true)
                .showTips(true)
                .onChange((value: number) => {
                  this.maskHeight = value
                })
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }
        }
        .width('100%')
      }
      .width('100%')
      .height('60%')
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
