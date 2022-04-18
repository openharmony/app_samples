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
struct TabsSample {
  scroller: Scroller = new Scroller()
  private controller: TabsController = new TabsController()
  @State vertical: boolean = true
  @State barPosition: boolean = true
  @State scrollable: boolean = true
  @State barWidth: number = 80
  @State index: number = 0
  @State barHeight: number = 240
  @State barMode: boolean = true
  @State animationDuration: number = 400

  build() {
    Column() {
      NavigationBar({ title: 'Tabs&TabContent' })

      Column() {
        Tabs({
          barPosition: this.barPosition ? BarPosition.Start : BarPosition.End,
          index: this.index,
          controller: this.controller
        }) {
          TabContent() {
            Flex({ justifyContent: FlexAlign.SpaceAround }) {
              Column() {
                Text('Pink').fontSize(24)
                Text('index:0').fontSize(24)
              }.alignSelf(ItemAlign.Center)
            }.width('100%').height('100%').backgroundColor(Color.Pink)
          }.tabBar({ icon: $r('app.media.icon'), text: 'pink' })

          TabContent() {
            Flex({ justifyContent: FlexAlign.SpaceAround }) {
              Column() {
                Text('Yellow').fontSize(24)
                Text('index:1').fontSize(24)
              }.alignSelf(ItemAlign.Center)
            }.width('100%').height('100%').backgroundColor(Color.Yellow)
          }.tabBar('yellow')

          TabContent() {
            Flex({ justifyContent: FlexAlign.SpaceAround }) {
              Column() {
                Text('Blue').fontSize(24)
                Text('index:2').fontSize(24)
              }.alignSelf(ItemAlign.Center)
            }.width('100%').height('100%').backgroundColor(Color.Blue)
          }.tabBar('blue')

          TabContent() {
            Flex({ justifyContent: FlexAlign.SpaceAround }) {
              Column() {
                Text('Red').fontSize(24)
                Text('index:3').fontSize(24)
              }.alignSelf(ItemAlign.Center)
            }.width('100%').height('100%').backgroundColor(Color.Red)
          }.tabBar('red')

          TabContent() {
            Flex({ justifyContent: FlexAlign.SpaceAround }) {
              Column() {
                Text('Green').fontSize(24)
                Text('index:4').fontSize(24)
              }.alignSelf(ItemAlign.Center)
            }.width('100%').height('100%').backgroundColor(Color.Green)
          }.tabBar('green')
        }
        .vertical(this.vertical)
        .scrollable(this.scrollable)
        .barMode(this.barMode ? BarMode.Scrollable : BarMode.Fixed)
        .barWidth(this.barWidth)
        .barHeight(this.barHeight)
        .animationDuration(this.animationDuration)
        .onChange((index: number) => {
          this.index = index
        })
        .width('100%')
        .backgroundColor(0xF5F5F5)
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .width('100%')
      .padding(18)
      .backgroundColor('#FFFFFF')

      Scroll(this.scroller) {
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('index')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Text('' + this.index)
                .fontSize('14fp')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
          }
          .bindMenu([
            {
              value: '0',
              action: () => {
                this.controller.changeIndex(0)
              }
            },
            {
              value: '1',
              action: () => {
                this.controller.changeIndex(1)
              }
            },
            {
              value: '2',
              action: () => {
                this.controller.changeIndex(2)
              }
            },
            {
              value: '3',
              action: () => {
                this.controller.changeIndex(3)
              }
            },
            {
              value: '4',
              action: () => {
                this.controller.changeIndex(4)
              }
            },
          ])

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems:ItemAlign.Center }) {
              Text('vertical')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Toggle({ type: ToggleType.Switch, isOn: this.vertical })
                .selectedColor('#007DFF')
                .switchPointColor(0xe5ffffff)
                .onChange((isOn: boolean) => {
                  this.vertical = !this.vertical
                  if (this.vertical) {
                    this.barWidth = 80
                    this.barHeight = 240
                  } else {
                    this.barWidth = 400
                    this.barHeight = 60
                  }
                })
                .margin(0)
                .padding(0)
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('barMode')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Text(this.barMode ? 'Scrollable' : 'Fixed')
                .fontSize('14fp')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }
          .bindMenu([
            {
              value: 'Scrollable',
              action: () => {
                this.barMode = true
              }
            },
            {
              value: 'Fixed',
              action: () => {
                this.barMode = false
              }
            },
          ])

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('barPosition')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Text('' + this.barPosition ? 'Start' : 'End')
                .fontSize('14fp')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }
          .bindMenu([
            {
              value: 'Start',
              action: () => {
                this.barPosition = true
              }
            },
            {
              value: 'End',
              action: () => {
                this.barPosition = false
              }
            },
          ])

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems:ItemAlign.Center }) {
              Text('scrollable')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Toggle({ type: ToggleType.Switch, isOn: this.scrollable })
                .selectedColor('#007DFF')
                .switchPointColor(0xe5ffffff)
                .onChange((isOn: boolean) => {
                  this.scrollable = !this.scrollable
                })
                .margin(0)
                .padding(0)
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }

          if (this.scrollable) {
            Column() {
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Text('animationDuration')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')
                Text('' + this.animationDuration)
                  .fontSize('16fp')
                  .fontWeight(FontWeight.Medium)
              }
              .height(35)

              Slider({
                value: this.animationDuration / 100,
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
                .showTips(false)
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.animationDuration = Math.floor(value * 100)
                })
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }

          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('barWidth')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Text('' + this.barWidth)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
            }
            .height(35)

            Slider({
              value: this.barWidth,
              min: 0,
              max: 400,
              step: 1,
              style: SliderStyle.OutSet
            })
              .blockColor('#FFFFFF')
              .trackColor('#182431')
              .selectedColor('#007DFF')
              .width('100%')
              .showSteps(true)
              .showTips(false)
              .onChange((value: number, mode: SliderChangeMode) => {
                this.barWidth = Math.floor(value)
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('barHeight')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')
              Text('' + this.barHeight)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
            }
            .height(35)

            Slider({
              value: this.barHeight,
              min: 0,
              max: 400,
              step: 1,
              style: SliderStyle.OutSet
            })
              .blockColor('#FFFFFF')
              .trackColor('#182431')
              .selectedColor('#007DFF')
              .width('100%')
              .showSteps(true)
              .showTips(false)
              .onChange((value: number, mode: SliderChangeMode) => {
                this.barHeight = Math.floor(value)
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
      }
      .align(Alignment.Start)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .scrollBarColor(Color.Gray)
      .scrollBarWidth(30)
      .margin({ top: 24 })
      .height('50%')
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