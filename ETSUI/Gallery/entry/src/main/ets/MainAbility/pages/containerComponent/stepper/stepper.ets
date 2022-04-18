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
struct StepperSample {
  @State currentIndex: number = 0
  @State iteamStateType: ItemState = ItemState.Normal
  @State showMessage: string= "default"
  private iteamArrays: string[]= ["Normal", "Disabled", "Waiting", "Skip"]

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: 'Stepper' })
      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Stepper({
              index: this.currentIndex
            }) {
              StepperItem() {
                Text('Page One')
                  .fontSize(35)
                  .fontColor('#000000')
                  .width(200)
                  .lineHeight(50)
                  .margin({ top: 120 })
              }
              .nextLabel('')
              .position({ x: '28%', y: 0 })

              StepperItem() {
                Text('Page Two')
                  .fontSize(35)
                  .fontColor('#000000')
                  .width(200)
                  .lineHeight(50)
                  .margin({ top: 120 })
              }
              .nextLabel('Next')
              .prevLabel('Previous')
              .status(this.iteamStateType)
              .position({ x: '28%', y: 0 })

              StepperItem() {
                Text('Page Three')
                  .fontSize(35)
                  .fontColor('#000000')
                  .width(200)
                  .lineHeight(50)
                  .margin({ top: 120 })
              }
              .position({ x: '28%', y: 0 })
              .nextLabel('Finish')
            }
            .onFinish(() => {
              this.showMessage = "Finish"
            })
            .onSkip(() => {
              this.showMessage = "Skip"
            })
            .onChange((prevIndex: number, index: number) => {
              this.currentIndex = index
            })
            .align(Alignment.Center)
          }
        }
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })

      Scroll() {
        Column() {
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
            Text(this.showMessage)
              .fontSize('20fp')
              .fontColor('#000000')
              .fontWeight(FontWeight.Medium)
              .opacity(0.8)
              .textAlign(TextAlign.Center)
          }

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('PageTwo-ItemState')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.iteamArrays[`${this.iteamStateType}`])
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'Normal',
                action: () => {
                  this.iteamStateType = ItemState.Normal
                }
              },
              {
                value: 'Disabled',
                action: () => {
                  this.iteamStateType = ItemState.Disabled
                }
              },
              {
                value: 'Waiting',
                action: () => {
                  this.iteamStateType = ItemState.Waiting

                }
              },
              {
                value: 'Skip',
                action: () => {
                  this.iteamStateType = ItemState.Skip
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8, bottom: 8 })
        }
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