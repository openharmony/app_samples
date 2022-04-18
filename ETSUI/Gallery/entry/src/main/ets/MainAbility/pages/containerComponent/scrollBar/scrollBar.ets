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
struct ScrollBarSample {
  private scroller: Scroller = new Scroller()
  private list: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  @State direction: boolean = true
  @State state: number = 1
  @State ScrollBarbackgroundColor: string = '#e3e3e3'
  @State ScrollBarcolor: string = '#404040'
  @State scrollBarWidth: number = 10

  build() {
    Column() {
      NavigationBar({ title: 'ScrollBar' })

      Stack({ alignContent: Alignment.End }) {
        Scroll(this.scroller) {
          Flex({ direction: this.direction ? FlexDirection.Column : FlexDirection.Row }) {
            ForEach(this.list, (item) => {
              Row() {
                Text(item.toString())
                  .width('100%')
                  .height(100)
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
                  .margin({ bottom: 10 })
                  .height(72)
                  .borderRadius(24)
                  .backgroundColor('#ffffff')
              }
              .width('100%')
              .padding({ right: '3%' })
            }, item => item)
          }
        }
        .scrollBar(BarState.Off)
        .scrollable(this.direction ? ScrollDirection.Vertical : ScrollDirection.Horizontal)

        ScrollBar({
          scroller: this.scroller,
          direction: this.direction ? ScrollBarDirection.Vertical : ScrollBarDirection.Horizontal,
          state: this.state == 1 ? BarState.Auto : this.state == 2 ? BarState.On : BarState.Off
        }) {
          Text()
            .width(this.direction ? this.scrollBarWidth : 100)
            .height(this.direction ? 200 : this.scrollBarWidth)
            .borderRadius(10)
            .backgroundColor(this.ScrollBarcolor)
        }.width(this.direction ? this.scrollBarWidth : '100%').backgroundColor(this.ScrollBarbackgroundColor)
        .position(this.direction ? {} : { x: 0, y: '90%' }).height(this.direction ? '100%' : this.scrollBarWidth)
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .width('100%')
      .padding(18)

      Column() {
        Row() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Text('direction')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Text(this.direction ? 'Vertical' : 'Horizontal')
              .fontSize('16fp')
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
            value: 'Vertical',
            action: () => {
              this.direction = true
            }
          },
          {
            value: 'Horizontal',
            action: () => {
              this.direction = false
            }
          }
        ])

        Row() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Text('state')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Text(this.state == 1 ? 'Auto' : this.state == 2 ? 'On' : 'Off')
              .fontSize('16fp')
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
            value: 'Auto',
            action: () => {
              this.state = 1
            }
          },
          {
            value: 'On',
            action: () => {
              this.state = 2
            }
          },
          {
            value: 'Off',
            action: () => {
              this.state = 0
            }
          }
        ])

        Row() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Text('ScrollBarbackgroundColor')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Text('' + this.ScrollBarbackgroundColor == '#e3e3e3' ? '浅灰色' : '象牙色')
              .fontSize('16fp')
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
            value: '浅灰色',
            action: () => {
              this.ScrollBarbackgroundColor = '#e3e3e3'
            }
          },
          {
            value: '灰色',
            action: () => {
              this.ScrollBarbackgroundColor = '#bfbfbf'
            }
          }
        ])

        Row() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Text('ScrollBarcolor')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Text('' + this.ScrollBarcolor == '#404040' ? '深灰色' : '灰色')
              .fontSize('16fp')
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
            value: '深灰色',
            action: () => {
              this.ScrollBarcolor = '#404040'
            }
          },
          {
            value: '灰色',
            action: () => {
              this.ScrollBarcolor = '#625b57'
            }
          }
        ])

        if (this.state == 1 || this.state == 2) {
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
                .width('50%')
                .textAlign(TextAlign.End)
            }

            Slider({
              value: this.scrollBarWidth,
              min: 0,
              max: 350,
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
                this.scrollBarWidth = Math.floor(value)
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
      }.margin({ top: 24 })
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