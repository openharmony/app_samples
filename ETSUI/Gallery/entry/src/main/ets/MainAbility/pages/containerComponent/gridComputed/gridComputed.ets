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

class ButtonIteam {
  public index: number ;
  public textMessage: string ;
  public backgroundColor: string;
  public columnNumber: number;

  constructor(index: number, textMessage: string, backgroundColor: string) {
    this.index = index;
    this.textMessage = textMessage;
    this.backgroundColor = backgroundColor;
  }
}

@Entry
@Component
struct GridComputedSample {
  @State listShow: ButtonIteam[] = [
    new ButtonIteam(0, "AC", "#A0A0A0"),
    new ButtonIteam(1, "+/-", "#A0A0A0"),
    new ButtonIteam(2, "%", "#A0A0A0"),
    new ButtonIteam(3, "÷", "#F89806"),
    new ButtonIteam(4, "7", "#313131"),
    new ButtonIteam(5, "8", "#313131"),
    new ButtonIteam(6, "9", "#313131"),
    new ButtonIteam(7, "x", "#F89806"),
    new ButtonIteam(8, "4", "#313131"),
    new ButtonIteam(9, "5", "#313131"),
    new ButtonIteam(10, "6", "#313131"),
    new ButtonIteam(11, "-", "#F89806"),
    new ButtonIteam(12, "1", "#313131"),
    new ButtonIteam(13, "2", "#313131"),
    new ButtonIteam(14, "3", "#313131"),
    new ButtonIteam(15, "+", "#F89806"),
    new ButtonIteam(16, "0", "#313131"),
    new ButtonIteam(17, ".", "#313131"),
    new ButtonIteam(18, "=", "#F89806")
  ]
  @State columnsGap: number= 10
  @State rowsGap: number= 10
  @State showMessage: string= "请点击按钮显示"

  build() {
    Column() {
      NavigationBar({ title: 'Grid' })
      //上部分显示效果
      Scroll() {
        Grid() {
          GridItem() {
            Text(this.showMessage)
              .fontSize(40)
              .backgroundColor(Color.White)
              .width('100%')
              .height('100%')
              .textAlign(TextAlign.Center)
          }.forceRebuild(false)
          .columnStart(1).columnEnd(4)

          ForEach(this.listShow, (item: ButtonIteam) => {
            GridItem() {
              Text(item.textMessage)
                .fontSize(30)
                .fontColor(Color.White)
                .backgroundColor(item.backgroundColor)
                .width(item.index == 16 ? '100%' : 60)
                .height(item.index == 16 ? '100%' : 60)
                .textAlign(TextAlign.Center)
                .borderRadius(item.index == 18 ? 0 : 50)
                .onClick(() => {
                  this.showMessage = item.textMessage
                })
            }
            .rowStart(1)
            .rowEnd(1)
            .columnStart(1)
            .columnEnd(item.index == 16 ? 2 : 1)
          }, item => item.index)
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsTemplate('2fr 1fr 1fr 1fr 1fr 1fr ')
        .columnsGap(this.columnsGap)
        .rowsGap(this.rowsGap)
        .width('90%')
        .height('90%')
        .margin({ top: 5, bottom: 5 })
      }
      .width('100%')
      .height('75%')
      .backgroundColor(Color.Black)
      .zIndex(99)
      //下部分属性、属性值
      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('行间距')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
//            Counter() {
//              Text(this.rowsGap + "").fontSize(22)
//            }
//            .height(30)
//            .onInc(() => {
//              if (this.rowsGap < 80) {
//                this.rowsGap++
//              }
//            })
//            .onDec(() => {
//              if (this.rowsGap > 1) {
//                this.rowsGap--
//              }
//            })
            Counter() {
              Text(this.rowsGap + "")
                .fontWeight(FontWeight.Regular)
                .fontColor('#000000')
                .fontSize('10fp')
            }
            .onInc(() => {
              if (this.rowsGap < 80) {
                this.rowsGap++
              }
            })
            .onDec(() => {
              if (this.rowsGap > 1) {
                this.rowsGap--
              }
            })
            .height(24)
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('列间距')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
//            Counter() {
//              Text(this.columnsGap + "").fontSize(22)
//            }
//            .height(30)
//            .onInc(() => {
//              if (this.columnsGap < 30) {
//                this.columnsGap++
//              }
//            })
//            .onDec(() => {
//              if (this.columnsGap > 1) {
//                this.columnsGap--
//              }
//            })
            Counter() {
              Text(this.columnsGap + "")
                .fontWeight(FontWeight.Regular)
                .fontColor('#000000')
                .fontSize('10fp')
            }
            .onInc(() => {
              if (this.columnsGap < 30) {
                this.columnsGap++
              }
            })
            .onDec(() => {
              if (this.columnsGap > 1) {
                this.columnsGap--
              }
            })
            .height(24)
          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

        }
        .width('97%')
        .margin({ right: '3%' })
      }
      .width('100%')
      .height('15%')
      .zIndex(99)
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