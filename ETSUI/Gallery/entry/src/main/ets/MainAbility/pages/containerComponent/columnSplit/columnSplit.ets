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
struct ColumnSplitSample {
  @State space: number= 25
  @State alignItemsConfig: VerticalAlign= VerticalAlign.Top
  @State circularArr: number[]= [1, 2, 3]
  private showMessage: string= "VerticalAlign.Top"
  private boxWidth: string= "20%"
  private backGround: string []= ["#EE82EE", "#87CEFA", "#FF4500"]
  private circularVal: number= 0;
  @State resizeableVal: boolean= false

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: 'ColumnSplit' })
      Column() {
        Scroll() {
          ColumnSplit() {
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
          .resizeable(this.resizeableVal)
          .width('100%')
          .padding(5)
          .backgroundColor(0xAFEEEE)
        }
        .width('100%')
        .backgroundColor('#b6dfff')
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })

      Scroll() {
        Column() {
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
            Text(this.showMessage)
              .width('90%')
              .fontSize('20fp')
              .fontColor('#000000')
              .margin({ bottom: 5, left: 15 })
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Medium)
              .opacity(0.8)
          }
          .margin({ top: 3, bottom: 15 })
          .padding(5)

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Button('+', { type: ButtonType.Capsule, stateEffect: true })
              .borderRadius(14)
              .backgroundColor('#007DFF')
              .size({ width: 44, height: 28 })
              .fontSize('16fp')
              .onClick(() => {
                this.circularVal = this.circularArr.length + 1;
                this.circularArr[this.circularVal-1] = this.circularVal;
              })
            Button('-', { type: ButtonType.Capsule, stateEffect: true })
              .borderRadius(14)
              .backgroundColor('#007DFF')
              .size({ width: 44, height: 28 })
              .fontSize('16fp')
              .onClick(() => {
                this.circularArr = this.circularArr.slice(0, this.circularArr.length - 1)
                this.circularVal = this.circularArr.length + 1
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text("resizeableVal")
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.resizeableVal + "")
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'ture',
                action: () => {
                  this.resizeableVal = true
                  this.showMessage = "resizeableVal:true"
                }
              },
              {
                value: 'false',
                action: () => {
                  this.resizeableVal = false
                  this.showMessage = "resizeableVal:false"
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
      .width('100%')
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