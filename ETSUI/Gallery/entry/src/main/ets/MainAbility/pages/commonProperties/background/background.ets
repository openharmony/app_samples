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
struct BackgroundSample {
  @State value: string = "hello world"
  @State color: Color = Color.Black
  @State getColorVal: string = 'rgba(0,0,0,1)'
  @State imageSrc: {
    name: string,
    path: string
  } = { name: 'image01', path: '/common/image01.png' }
  @State repeatStyle: string = 'NoRepeat'
  @State backgroundImageSize: string = 'Auto'
  @State backgroundImagePosition: string = 'TopStart'
  @State imageWidthProperty: {
    width: number,
    height: number,
    x: number,
    y: number
  } = { width: 0, height: 0, x: 0, y: 0 }
  @State showSize: string = 'None'
  @State showPosition: string = 'None'

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: '背景设置' })
      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Row() {
              Row()
                .width('100%')
                .height('100%')
                .backgroundImage(this.imageSrc.path, ImageRepeat[this.repeatStyle])
                .backgroundImageSize(this.backgroundImageSize != 'Customize' ?
                  ImageSize[this.backgroundImageSize] : {
                                                          width: this.imageWidthProperty.width,
                                                          height: this.imageWidthProperty.height
                                                        })
                .backgroundImagePosition(this.backgroundImagePosition != 'Customize' ?
                  Alignment[this.backgroundImagePosition] : {
                                                              x: this.imageWidthProperty.x,
                                                              y: this.imageWidthProperty.y
                                                            })
            }
            .width('100%')
            .height('100%')
            .backgroundColor(this.getColorVal)
          }.width('100%')
        }
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .width('100%')
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('backgroundColor')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Row() {
                GetColor({ colorVal: $getColorVal })
              }
              .width(48)
              .height(24)
            }
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('imageSrc')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.imageSrc.name}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'image01',
                action: () => {
                  this.imageSrc.name = 'image01'
                  this.imageSrc.path = '/common/image01.png'
                }
              },
              {
                value: 'image02',
                action: () => {
                  this.imageSrc.name = 'image02'
                  this.imageSrc.path = '/common/image02.png'
                }
              },
              {
                value: 'image03',
                action: () => {
                  this.imageSrc.name = 'image03'
                  this.imageSrc.path = '/common/image03.png'
                }
              },
              {
                value: 'big-Image',
                action: () => {
                  this.imageSrc.name = 'big-Image'
                  this.imageSrc.path = '/common/bigImage.jpg'
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
            Text('repeat')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.repeatStyle}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'X',
                action: () => {
                  this.repeatStyle = 'X'
                }
              },
              {
                value: 'Y',
                action: () => {
                  this.repeatStyle = 'Y'
                }
              },
              {
                value: 'XY',
                action: () => {
                  this.repeatStyle = 'XY'
                }
              },
              {
                value: 'NoRepeat',
                action: () => {
                  this.repeatStyle = 'NoRepeat'
                }
              }
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('backgroundImageSize')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.backgroundImageSize}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('40%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'Cover',
                action: () => {
                  this.backgroundImageSize = 'Cover'
                  this.showSize = 'None'
                }
              },
              {
                value: 'Contain',
                action: () => {
                  this.backgroundImageSize = 'Contain'
                  this.showSize = 'None'
                }
              },
              {
                value: 'Auto',
                action: () => {
                  this.backgroundImageSize = 'Auto'
                  this.showSize = 'None'
                }
              },
              {
                value: 'Customize',
                action: () => {
                  this.backgroundImageSize = 'Customize'
                  this.imageWidthProperty.width = 500
                  this.imageWidthProperty.height = 500
                  this.showSize = 'Visible'
                }
              }
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Column() {
              Row() {
                Text('width')
                  .fontSize('16fp')
                  .opacity(0.5)
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                TextInput({ placeholder: this.imageWidthProperty.width.toString() })
                  .width('30%').type(InputType.Number)
                  .onChange((value: string) => {
                    this.imageWidthProperty.width = Number(value)
                  })
              }
            }

            Column() {
              Row() {
                Text('height')
                  .fontSize('16fp')
                  .opacity(0.5)
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                  .margin({ left: 20 })
                TextInput({ placeholder: this.imageWidthProperty.height.toString() })
                  .width('30%')
                  .type(InputType.Number)
                  .onChange((value: string) => {
                    this.imageWidthProperty.height = Number(value)
                  })
              }
            }
          }
          .visibility(Visibility[this.showSize])
          .width('100%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('backgroundImagePosition')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.backgroundImagePosition}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
            }
            .bindMenu([
              {
                value: 'TopStart',
                action: () => {
                  this.backgroundImagePosition = 'TopStart'
                  this.showPosition = 'None'
                }
              },
              {
                value: 'Top',
                action: () => {
                  this.backgroundImagePosition = 'Top'
                  this.showPosition = 'None'
                }
              },
              {
                value: 'TopEnd',
                action: () => {
                  this.backgroundImagePosition = 'TopEnd'
                  this.showPosition = 'None'
                }
              },
              {
                value: 'Start',
                action: () => {
                  this.backgroundImagePosition = 'Start'
                  this.showPosition = 'None'
                }
              },
              {
                value: 'Center',
                action: () => {
                  this.backgroundImagePosition = 'Center'
                  this.showPosition = 'None'
                }
              },
              {
                value: 'End',
                action: () => {
                  this.backgroundImagePosition = 'End'
                  this.showPosition = 'None'
                }
              },
              {
                value: 'BottomStart',
                action: () => {
                  this.backgroundImagePosition = 'BottomStart'
                  this.showPosition = 'None'
                }
              },
              {
                value: 'Bottom',
                action: () => {
                  this.backgroundImagePosition = 'Bottom'
                  this.showPosition = 'None'
                }
              },
              {
                value: 'BottomEnd',
                action: () => {
                  this.backgroundImagePosition = 'BottomEnd'
                  this.showPosition = 'None'
                }
              },
              {
                value: 'Customize',
                action: () => {
                  this.backgroundImagePosition = 'Customize'
                  this.imageWidthProperty.x = 300
                  this.imageWidthProperty.y = 300
                  this.showPosition = 'Visible'
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8, bottom: 8 })

          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Column() {
              Row() {
                Text('x:')
                  .fontSize('16fp')
                  .opacity(0.5)
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                TextInput({ placeholder: this.imageWidthProperty.x.toString() })
                  .width('50%')
                  .type(InputType.Number)
                  .onChange((value: string) => {
                    this.imageWidthProperty.x = Number(value)
                  })
              }
            }

            Column() {
              Row() {
                Text('y:')
                  .fontSize('16fp')
                  .opacity(0.5)
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                  .margin({ left: 20 })
                TextInput({ placeholder: this.imageWidthProperty.y.toString() }).width('50%').type(InputType.Number)
                  .onChange((value: string) => {
                    this.imageWidthProperty.y = Number(value)
                  })
              }
            }
          }
          .visibility(Visibility[this.showPosition])
          .width('100%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ bottom: 12 })
        }.width('100%')
      }.width('100%').height('40%')
    }
    .width('100%')
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