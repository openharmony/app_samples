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
struct FocusSmaple {
  @State suspension: boolean= false
  @State borderWithNumber: number[]= [0, 0, 0, 0]
  @State chooseUrlNumber: number= 0

  private urlArray: Resource[]= [$r("app.media.focus_01"), $r("app.media.focus_02"), $r("app.media.focus_03"), $r("app.media.focus_04")]

  build() {
    Column() {
      Row() {
        NavigationBar({ title: 'Focus' })
      }
      .width('100%')
      .height('10%')
      .zIndex(999)
      //上部分显示效果
      Column() {
        Image(this.urlArray[this.chooseUrlNumber])
          .width(250)
          .height(250)
          .borderRadius(12)
          .hoverEffect(HoverEffect.Scale)
          .onHover((isHover: boolean) => {
            animateTo({ duration: 500 }, () => {
              this.suspension = !this.suspension
            })
          })
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .width('100%')
      .padding(18)
      .backgroundColor('#FFFFFF')
      .zIndex(99)

      //下部分属性、属性值
      Column() {
        if (!this.suspension) {
          Row() {
            Image($r("app.media.focus_01"))
              .width(80)
              .height(80)
              .borderRadius(12)
              .margin({ right: 12, top: 12 })
              .borderWidth(this.borderWithNumber[0])
              .borderColor(Color.Orange)
              .focusable(true)
              .onFocus(() => {
                this.borderWithNumber = [6, 0, 0, 0]
                this.chooseUrlNumber = 0
              })

            Image($r("app.media.focus_02"))
              .width(75)
              .height(75)
              .borderRadius(12)
              .margin({ right: 10, top: 12 })
              .borderWidth(this.borderWithNumber[1])
              .borderColor(Color.Orange)
              .focusable(true)
              .onFocus(() => {
                this.borderWithNumber = [0, 6, 0, 0]
                this.chooseUrlNumber = 1
              })

            Image($r("app.media.focus_03"))
              .width(75)
              .height(75)
              .borderRadius(12)
              .margin({ right: 10, top: 12 })
              .borderWidth(this.borderWithNumber[2])
              .borderColor(Color.Orange)
              .focusable(true)
              .onClick(() => {
                this.borderWithNumber = [0, 0, 6, 0]
                this.chooseUrlNumber = 2
              })
              .onFocus(() => {
                this.borderWithNumber = [0, 0, 6, 0]
                this.chooseUrlNumber = 2
              })

            Image($r("app.media.focus_04"))
              .width(75)
              .height(75)
              .borderRadius(12)
              .margin({ right: 10, top: 12 })
              .borderWidth(this.borderWithNumber[3])
              .borderColor(Color.Orange)
              .focusable(true)
              .onClick(() => {
                this.borderWithNumber = [0, 0, 0, 6]
                this.chooseUrlNumber = 3
              })
              .onFocus(() => {
                this.borderWithNumber = [0, 0, 0, 6]
                this.chooseUrlNumber = 3
              })
          }
          .width(336)
          .height(100)
          .transition({ type: TransitionType.Insert, scale: { x: 0, y: 2.0 } })
          .transition({ type: TransitionType.Delete, scale: { x: 2.0, y: 0.0 } })
        }
        else {
          Column() {
            Text("鼠标正在悬浮")
              .fontSize(30)
              .fontColor(Color.Black)
              .textAlign(TextAlign.Center)
              .width(336)
              .height(100)
              .margin({ top: 5, bottom: 5 })

            Image($r("app.media.focus_05"))
              .width(150)
              .height(150)
              .borderRadius(12)
          }.width(336)
          .height(100)
        }
      }
      .width(336)
      .height(56)
      .backgroundColor('#FFFFFF')
      .zIndex(99)
      .margin({top:24})
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