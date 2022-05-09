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
import prompt from '@ohos.prompt';

@Entry
@Component
struct ClickEventSample {
  @State colOpacity: number = 1

  build() {
    Column() {
      NavigationBar({ title: '点击事件' })
      Column() {
        Text('连续点击图片，逐渐透明')
          .width(312)
          .height(20)
          .fontSize(12)
          .fontColor('#182431 ')
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .margin({ left: 12, right: 12, top: 38, bottom: 18 })
        Image('/common/test3.png')
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.colOpacity -= 0.1;
          })
          .margin({ bottom: 81 })
          .width(330)
          .height(242)
          .opacity(this.colOpacity)
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })
      .backgroundColor('#FFFFFF')

      Button('reset')
        .fontSize(20)
        .onClick(() => {
          this.colOpacity = 1
        })
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%' })
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