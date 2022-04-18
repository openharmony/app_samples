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
struct ImageAnimatorSample {
  @State state: AnimationStatus = AnimationStatus.Initial
  @State fillMode: FillMode = FillMode.None
  @State reverse: boolean = false
  @State fixedSize: boolean = false
  @State iterations: number = 1

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: 'ImageAnimator' })
      Column() {
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          ImageAnimator()
            .images([
              {
                src: '/common/animator/animator1.png',
                duration: 120,
                width: 200,
                height: 270,
                top: 0,
                left: 0
              },
              {
                src: '/common/animator/animator2.png',
                duration: 120,
                width: 200,
                height: 270,
                top: 0,
                left: 0
              },
              {
                src: '/common/animator/animator3.png',
                duration: 120,
                width: 200,
                height: 270,
                top: 0,
                left: 0
              },
              {
                src: '/common/animator/animator4.png',
                duration: 120,
                width: 200,
                height: 270,
                top: 0,
                left: 0
              },
              {
                src: '/common/animator/animator5.png',
                duration: 120,
                width: 200,
                height: 270,
                top: 0,
                left: 0
              },
              {
                src: '/common/animator/animator6.png',
                duration: 120,
                width: 200,
                height: 270,
                top: 0,
                left: 0
              },
              {
                src: '/common/animator/animator7.png',
                duration: 120,
                width: 200,
                height: 270,
                top: 0,
                left: 0
              },
              {
                src: '/common/animator/animator8.png',
                duration: 120,
                width: 200,
                height: 270,
                top: 0,
                left: 0
              },
              {
                src: '/common/animator/animator9.png',
                duration: 120,
                width: 200,
                height: 270,
                top: 0,
                left: 0
              },
              {
                src: '/common/animator/animator10.png',
                duration: 120,
                width: 200,
                height: 270,
                top: 0,
                left: 0
              }
            ])
            .state(this.state)
            .reverse(this.reverse)
            .fixedSize(this.fixedSize)
            .preDecode(0)
            .fillMode(this.fillMode)
            .iterations(this.iterations)
            .width(230)
            .height(320)
            .onStart(() => {
              console.info('Start')
            })
            .onPause(() => {
              console.info('Pause')
            })
            .onRepeat(() => {
              console.info('Repeat')
            })
            .onCancel(() => {
              console.info('Cancel')
            })
            .onFinish(() => {
              console.info('Finish')
            })
        }.width('100%')
        .margin({ left: '10%' })
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 12, bottom: 22 })
      .margin({ bottom: 14 })
      .backgroundColor('#000000')

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('state')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.state == 0 ? 'Initial' : this.state == 1 ? 'Running' :
                                                        this.state == 2 ? 'Paused' : 'Stopped'}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'Initial',
                action: () => {
                  this.state = AnimationStatus.Initial
                }
              },
              {
                value: 'Running',
                action: () => {
                  this.state = AnimationStatus.Running
                }
              },
              {
                value: 'Paused',
                action: () => {
                  this.state = AnimationStatus.Paused
                }
              },
              {
                value: 'Stopped',
                action: () => {
                  this.state = AnimationStatus.Stopped
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
            Text('reverse')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.reverse}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'false',
                action: () => {
                  this.reverse = false
                }
              },
              {
                value: 'true',
                action: () => {
                  this.reverse = true
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
            Text('fixedSize')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.fixedSize}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'false',
                action: () => {
                  this.fixedSize = false
                }
              },
              {
                value: 'true',
                action: () => {
                  this.fixedSize = true
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
            Text('fillMode')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.fillMode == 0 ? 'None' : 'Forwards'}`)
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
                  this.fillMode = FillMode.None
                }
              },
              {
                value: 'Forwards',
                action: () => {
                  this.fillMode = FillMode.Forwards
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
            Text('iterations')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.iterations}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: '1',
                action: () => {
                  this.iterations = 1
                }
              },
              {
                value: '-1',
                action: () => {
                  this.iterations = -1
                }
              }
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8, bottom: 8 })
        }.width('100%')
      }
    }
    .width('100%')
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