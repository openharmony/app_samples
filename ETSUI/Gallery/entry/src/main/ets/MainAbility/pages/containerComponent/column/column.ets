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
struct ColumnSample {
  @State space: number= 25
  @State alignItemsConfig: HorizontalAlign= HorizontalAlign.Start
  @State circularArr: number[]= [1, 2, 3]
  private showMessage: string= "VerticalAlign.Start"
  private boxWidth: string= "20%"
  private backGround: string []= ["#EE82EE", "#87CEFA", "#FF4500"]
  private circularVal: number= 0;

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: 'Column' })
      Scroll() {
        Column({ space: this.space }) {
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
        .width('90%')
        .padding(5)
        .backgroundColor(0xAFEEEE)
        .margin({ bottom: 15 })
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .width('100%')
      .backgroundColor('#b6dfff')

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
              .borderRadius(14)
              .width(44)
              .height(28)
              .backgroundColor("#007DFF")
              .fontSize('16fp')
              .onClick(() => {
                this.circularVal = this.circularArr.length + 1;
                this.circularArr[this.circularVal-1] = this.circularVal;
              })
            Button('-', { type: ButtonType.Capsule, stateEffect: true })
              .borderRadius(14)
              .width(44)
              .height(28)
              .backgroundColor("#007DFF")
              .fontSize('16fp')
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
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'Start',
                action: () => {
                  this.boxWidth = "20%"
                  this.alignItemsConfig = HorizontalAlign.Start
                  this.showMessage = "HorizontalAlign.Start"
                }
              },
              {
                value: 'Center',
                action: () => {
                  this.boxWidth = "20%"
                  this.alignItemsConfig = HorizontalAlign.Center
                  this.showMessage = "HorizontalAlign.Center"
                }
              },
              {
                value: 'End',
                action: () => {
                  this.boxWidth = "20%"
                  this.alignItemsConfig = HorizontalAlign.End
                  this.showMessage = "HorizontalAlign.End"
                }
              },
            ])
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
              Text(`${this.space}`).fontSize('10fp').fontColor('#000000').fontWeight(FontWeight.Regular)
            }.width(100)
            .height(24)
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
        .width('97%')
        .margin({ right: '3%' })
      }
      .width('100%')
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