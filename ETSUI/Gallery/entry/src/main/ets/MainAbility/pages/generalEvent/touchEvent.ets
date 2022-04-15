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
import prompt from '@system.prompt';

@Entry
@Component
struct TouchEventSample {
  @State eventType: string = ''
  @State radius: number = 2
  @State width: number = 1
  @State brightness: number = 1.0
  @State x: number = 1
  @State y: number = 1
  @State offsetX: number = 0
  @State offsetY: number = 0
  @State screenX: number = 0
  @State screenY: number = 0
  @State x1: number = 0
  @State x2: number = 0
  @State y1: number = 0
  @State y2: number = 0

  build() {
    Column() {
      NavigationBar({ title: '触摸事件' })
      Column() {
        Text('Touch:按下&松开&长按移动(有阴影)')
          .width(312)
          .height(20)
          .fontSize(12)
          .fontColor('#182431 ')
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .margin({ left: 12, right: 12, top: 38, bottom: 18 })
        Image('/common/test2.jpg')
          .width(330)
          .height(242)
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.eventType = 'Down'
              this.radius = 20
              this.width = 2
              this.x = 1.1
              this.y = 1.1
              this.x1 = event.touches[0].x
              this.y1 = event.touches[0].y
            }
            if (event.type === TouchType.Up) {
              this.eventType = 'Up'
              this.radius = 2
              this.width = 1
              this.x = 1
              this.y = 1
              this.offsetX = 0
              this.offsetY = 0

            }
            if (event.type === TouchType.Move) {
              this.eventType = 'Move'
              this.x2 = event.touches[0].x - this.x1
              this.y2 = event.touches[0].y - this.y1
              this.offsetX = this.x2
              this.offsetY = this.y2
            }
            if (event.type === TouchType.Cancel) {
              this.eventType = 'Cancel'
              this.brightness = 1.0
            }
          })
          .width(300)
          .height(212)
          .border({ width: this.width, radius: this.radius, color: 0x317AF7 })
          .margin(30)
          .shadow({ radius: 10, color: Color.Gray, offsetX: this.offsetX, offsetY: this.offsetY })
          .scale({ x: this.x, y: this.y })
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })
      .backgroundColor('#FFFFFF')
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