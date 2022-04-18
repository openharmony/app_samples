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
struct ScrollSample {
  scroller: Scroller = new Scroller()
  scrollercontrol: Scroller = new Scroller()
  @State flag: boolean = true
  private list: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  @State scrollable: number  = 2
  @State scrollWidth: string  = '100%'
  @State scrollBar: boolean = true
  @State scrollBarWidth: number = 30
  @State scrollBarColor: string = '#d0d0d0'

  build() {
    Column() {
      NavigationBar({ title: 'Scroll' })
      Scroll(this.scroller) {
        if (this.scrollable == 2) {
          Column() {
            ForEach(this.list, (item) => {
              Text(item.toString())
                .width('90%')
                .height(72)
                .backgroundColor('#fff')
                .borderRadius(15)
                .fontSize(24)
                .textAlign(TextAlign.Center)
                .margin(10)
            }, item => item)
          }.width('100%').backgroundColor('#F1F3F5').padding({ bottom: 10 })
        } else {
          Flex({ direction: FlexDirection.Row }) {
            ForEach(this.list, (item) => {
              Column() {
                Text(item.toString())
                  .width(72)
                  .height('100%')
                  .backgroundColor('#fff')
                  .borderRadius(15)
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
              }
              .margin({ bottom: 20, right: 10 })
            }, item => item)
          }.height('100%').backgroundColor('#F1F3F5').padding({ left: '2%', right: 210 })
        }
      }
      .width('96%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .scrollable(this.scrollable == 1 ? ScrollDirection.Horizontal : this.scrollable == 2 ? ScrollDirection.Vertical : ScrollDirection.None)
      .scrollBar(this.scrollBar ? BarState.On : BarState.Off)
      .scrollBarColor(this.scrollBarColor)
      .scrollBarWidth(this.scrollBarWidth)
      .onScroll((xOffset: number, yOffset: number) => {
        console.info(xOffset + ' ' + yOffset)
      })
      .onScrollEdge((side: Edge) => {
        console.info('To the edge')
      })
      .onScrollEnd(() => {
        console.info('Scroll Stop')
      })

      Scroll(this.scrollercontrol) {
        Column() {
          Row() {
            Button('previous page')
              .onClick(() => {
                this.scroller.scrollPage({ next: false })
              })
              .fontSize('12fp')
              .fontWeight(FontWeight.Medium)
              .fontColor('#FFFFFF')
              .borderRadius(14)
              .padding({ left: 8, right: 8, top: 6, bottom: 6 })
              .backgroundColor('#007DFF')
              .alignSelf(ItemAlign.Center)
            Button('next page')
              .onClick(() => {
                this.scroller.scrollPage({ next: true })
              })
              .fontSize('12fp')
              .fontWeight(FontWeight.Medium)
              .fontColor('#FFFFFF')
              .borderRadius(14)
              .padding({ left: 8, right: 8, top: 6, bottom: 6 })
              .backgroundColor('#007DFF')
              .alignSelf(ItemAlign.Center)
              .margin({ left: '3%' })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Row() {
            Button('scroll 100')
              .onClick(() => {
                this.scroller.scrollTo({
                  xOffset: 0,
                  yOffset: this.scroller.currentOffset()
                  .yOffset + 100
                })
              })
              .fontSize('12fp')
              .fontWeight(FontWeight.Medium)
              .fontColor('#FFFFFF')
              .borderRadius(14)
              .padding({ left: 8, right: 8, top: 6, bottom: 6 })
              .backgroundColor('#007DFF')
              .alignSelf(ItemAlign.Center)
            Button('back top')
              .onClick(() => {
                this.scroller.scrollEdge(Edge.Top)
              })
              .fontSize('12fp')
              .fontWeight(FontWeight.Medium)
              .fontColor('#FFFFFF')
              .borderRadius(14)
              .padding({ left: 8, right: 8, top: 6, bottom: 6 })
              .backgroundColor('#007DFF')
              .alignSelf(ItemAlign.Center)
              .margin({ left: '3%' })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Row() {
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Text('scrollable')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')
                Text(this.scrollable == 1 ? 'Horizontal' : this.scrollable == 2 ? 'Vertical' : 'None')
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
                value: 'Horizontal',
                action: () => {
                  this.scrollable = 1
                  this.scrollWidth = '150%'
                  this.scrollBar = false
                }
              },
              {
                value: 'Vertical',
                action: () => {
                  this.scrollable = 2
                  this.scrollWidth = '100%'
                  this.scrollBar = true
                }
              },
              {
                value: 'None',
                action: () => {
                  this.scrollable = 3
                }
              }
            ])

            Row() {
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Text('scrollBar')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')
                Text(this.scrollBar ? 'On' : 'Off')
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
                value: 'On',
                action: () => {
                  this.scrollBar = true
                }
              },
              {
                value: 'Off',
                action: () => {
                  this.scrollBar = false
                }
              }
            ])

            if (this.scrollBar) {
              Row() {
                Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                  Text('scrollBarColor:')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')
                  Text(this.scrollBarColor == '#d0d0d0' ? '灰色' : '浅蓝灰色')
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
                  value: '灰色',
                  action: () => {
                    this.scrollBarColor = '#d0d0d0'
                  }
                },
                {
                  value: '浅灰蓝色',
                  action: () => {
                    this.scrollBarColor = '#b0e0e6'
                  }
                }
              ])
            }

            if (this.scrollBar) {
              Column() {
                Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                  Text('scrollBarWidth')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')
                  Text('' + this.scrollBarWidth)
                    .fontSize('16fp')
                    .fontWeight(FontWeight.Medium)
                }
                .width('100%')

                .borderRadius(24)
                .backgroundColor('#FFFFFF')

                Slider({
                  value: this.scrollBarWidth,
                  min: 0,
                  max: 350,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .borderColor('rgba(0,0,0,0.04) ')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number, mode: SliderChangeMode) => {
                    this.scrollBarWidth = value
                  })
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })
            }
          }
        }.width('100%')
      }.scrollBar(BarState.Off)
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