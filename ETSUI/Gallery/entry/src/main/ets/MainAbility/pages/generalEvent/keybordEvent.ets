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
 * WITHOUT WARRANTIES OR CONDITION S OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { NavigationBar } from "../../common/components/navigationBar"

@Entry
@Component
struct KeybordSample {
  @State keybordMessage: string= ""
  @State borderColorArray: string[]= ["#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF",]

  build() {
    Column() {
      NavigationBar({ title: '按键事件' })
      Column() {
        Text("请使用键盘输入")
          .focusable(false)
          .width("90%")
          .height(150)
          .fontSize(30)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Medium)
        Text(this.keybordMessage)
          .focusable(false)
          .width("90%")
          .height(100)
          .fontSize(20)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Medium)
          .borderWidth(10)
          .borderColor(Color.White)
          .borderRadius(12)
          .onKeyEvent((event: KeyEvent) => {
            if (event.keyCode == 2012) {
              this.borderColorArray = ["#F89806", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF",]
              this.keybordMessage = "上"
            } else if (event.keyCode == 2013) {
              this.borderColorArray = ["#FFFFFF", "#F89806", "#FFFFFF", "#FFFFFF", "#FFFFFF",]
              this.keybordMessage = "下"
            } else if (event.keyCode == 2014) {
              this.borderColorArray = ["#FFFFFF", "#FFFFFF", "#F89806", "#FFFFFF", "#FFFFFF",]
              this.keybordMessage = "左"
            }
            else if (event.keyCode == 2015) {
              this.borderColorArray = ["#FFFFFF", "#FFFFFF", "#FFFFFF", "#F89806", "#FFFFFF",]
              this.keybordMessage = "右"
            }
            else {
              this.borderColorArray = ["#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#F89806",]
              this.keybordMessage = "确定"
            }
          })
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .backgroundColor('#b6dfff')
      .borderRadius(12)

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text("上")
              .focusable(false)
              .width("40%")
              .height(80)
              .fontSize(20)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Medium)
              .borderWidth(10)
              .borderColor(this.borderColorArray[0])
              .borderRadius(12)

            Text("下")
              .focusable(false)
              .width("40%")
              .height(80)
              .fontSize(20)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Medium)
              .borderWidth(10)
              .borderColor(this.borderColorArray[1])
              .borderRadius(12)
          }
          .margin({ bottom: 22 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text("左")
              .focusable(false)
              .width("40%")
              .height(80)
              .fontSize(20)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Medium)
              .borderWidth(10)
              .borderColor(this.borderColorArray[2])
              .borderRadius(12)

            Text("右")
              .focusable(false)
              .width("40%")
              .height(80)
              .fontSize(20)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Medium)
              .borderWidth(10)
              .borderColor(this.borderColorArray[3])
              .borderRadius(12)
          }
          .margin({ bottom: 22 })

          Text("确定")
            .focusable(false)
            .width("60%")
            .height(80)
            .fontSize(20)
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
            .borderWidth(10)
            .borderColor(this.borderColorArray[4])
            .borderRadius(12)
        }
      }
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