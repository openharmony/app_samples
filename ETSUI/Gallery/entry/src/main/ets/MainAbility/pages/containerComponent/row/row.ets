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
struct RowSample {
  @State space: number= 25
  @State alignItemsConfig: VerticalAlign= VerticalAlign.Top
  @State circularArr: number[]= [1, 2, 3]
  private showMessage: string= "VerticalAlign.Top"
  private boxWidth: string= "20%"
  private backGround: string []= ["#EE82EE", "#87CEFA", "#FF4500"]
  private circularVal: number= 0;
  private scroller: Scroller = new Scroller()

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: 'Row' })
      Scroll(this.scroller) {
        Row({ space: this.space }) {
          ForEach(this.circularArr,
            (item: number) => {
              Text(`${item}`)
                .width(this.boxWidth)
                .height(50)
                .backgroundColor(this.backGround[(item)%3])
                .textAlign(TextAlign.Center)
                .lineHeight(35)
                .fontColor(Color.White)
                .fontSize(20)
            },
            (item: number) => item.toString()
          )
        }
        .alignItems(this.alignItemsConfig)
      }
      .height("50%")
      .width("100%")
      .backgroundColor(0xAFEEEE)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Auto)
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })

      ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Horizontal, state: BarState.Auto }) {
        Text()
          .width(100)
          .height(30)
          .borderRadius(10)
          .backgroundColor('#C0C0C0')
      }
      .height(30)
      .width(130)

      Scroll() {
        Column() {
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
            Text(this.showMessage)
              .width('90%')
              .fontSize(20)
              .fontColor(Color.Black)
              .margin({ bottom: 5, left: 15 })
              .textAlign(TextAlign.Center)
          }.margin({ top: 3, bottom: 15 })
          .padding(5)

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Button('+', { type: ButtonType.Capsule, stateEffect: true })
              .backgroundColor(0x317aff).width(90)
              .fontSize(30)
              .onClick(() => {
                this.circularVal = this.circularArr.length + 1;
                this.circularArr[this.circularVal-1] = this.circularVal;
              })
            Button('-', { type: ButtonType.Capsule, stateEffect: true })
              .backgroundColor(0x317aff).width(90)
              .fontSize(30)
              .onClick(() => {
                this.circularArr = this.circularArr.slice(0, this.circularArr.length - 1)
                this.circularVal = this.circularArr.length + 1
              })
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('alignIteam')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.showMessage.split('.')[1]}`)
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
                .bindMenu([
                  {
                    value: 'Top',
                    action: () => {
                      this.boxWidth = "20%"
                      this.alignItemsConfig = VerticalAlign.Top
                      this.showMessage = "VerticalAlign.Top"
                    }
                  },
                  {
                    value: 'Center',
                    action: () => {
                      this.boxWidth = "20%"
                      this.alignItemsConfig = VerticalAlign.Center
                      this.showMessage = "VerticalAlign.Center"
                    }
                  },
                  {
                    value: 'Bottom',
                    action: () => {
                      this.boxWidth = "20%"
                      this.alignItemsConfig = VerticalAlign.Bottom
                      this.showMessage = "VerticalAlign.Bottom"
                    }
                  },
                ])
            }
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('spacing')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Counter() {
              Text(`${this.space}`).fontSize(18)
            }
            .onInc(() => {
              this.space++
            })
            .onDec(() => {
              if (this.space > 0) {
                this.space--
              }
            })
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
      }
      .height('45%')
      .margin({ top: 24 })
    }
    .height('100%')
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