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

import { NavigationBar } from "../../common/components/navigationBar"

@Entry
@Component
struct GestureMethodExample {
  @State gestureValue: string = ''
  @State visibility1: string = 'Visible'
  @State visibility2: string = 'None'
  @State imageOpacity: number = 1
  @State offsetX: number = 0
  @State offsetY: number = 0
  @State borderWidth: number= 0
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: '手势识别' })
      Column() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Column() {
            Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
              TabContent() {
                Column() {
                  Text('点击图片优先识别')
                    .margin({ bottom: 18, top: '18vp' })
                    .fontSize(15)
                  Image('/common/test3.png')
                    .width(280)
                    .height('160vp')
                    .shadow({ radius: 10, color: Color.Gray, offsetX: this.offsetX, offsetY: this.offsetY })
                    .gesture(
                    TapGesture()
                      .onAction(() => {
                        this.gestureValue = '子组件先触发'
                      })
                    )
                    .priorityGesture(
                    TapGesture()
                      .onAction(() => {
                        this.offsetY = 30
                        this.offsetX = 30
                      })
                    )
                  Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                    Text('shadowOffset')
                      .fontSize('16fp')
                      .opacity(0.5)
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                    Column() {
                      Text(`${this.offsetX}`)
                        .fontSize('16fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                    }
                  }
                  .width('100%')
                  .padding('3%')
                  .borderRadius(24)
                  .backgroundColor('#FFFFFF')
                  .margin({ top: 18 })
                }
              }.tabBar('priorityGesture')
              .backgroundColor('#FFFFFF')
              .margin({ top: 18 })

              TabContent() {
                Column() {
                  Text('点击图片同时识别')
                    .margin({ top: 18, bottom: 18 })
                    .fontSize(15)
                  Image('/common/test5.jpg')
                    .opacity(this.imageOpacity)
                    .border({ width: this.borderWidth })
                    .borderColor(Color.Pink)
                    .width(280)
                    .height('160vp')
                    .gesture(
                    TapGesture()
                      .onAction(() => {
                        this.imageOpacity = 0.3
                      })
                    )
                    .parallelGesture(
                    TapGesture()
                      .onAction(() => {
                        this.borderWidth = 2
                      })
                    )
                  Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                    Text('opacity')
                      .fontSize('16fp')
                      .opacity(0.5)
                      .fontColor('#182431')
                      .fontWeight(FontWeight.Medium)
                    Column() {
                      Text(`${this.imageOpacity}`)
                        .fontSize('16fp')
                        .fontColor('#182431')
                        .fontWeight(FontWeight.Medium)
                    }
                  }
                  .width('100%')
                  .padding('3%')
                  .borderRadius(24)
                  .backgroundColor('#FFFFFF')
                  .margin({ top: 20 })
                }
                .alignItems(HorizontalAlign.Center)
              }.tabBar('parallelGesture')
              .backgroundColor('#FFFFFF')
              .margin({ top: 18 })
              .borderRadius(24)
            }
            .onChange((index: number) => {
              this.currentIndex = index
            })
            .vertical(false)
            .scrollable(true)
            .barMode(BarMode.Fixed)
            .barWidth(360)
            .barHeight(56)
          }
        }
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
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