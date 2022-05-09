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
struct KeyEventSample {
  @State text: string = ''
  @State eventType: string = ''

  build() {
    Column() {
      NavigationBar({ title: '按键事件' })
      Column() {
        Text('插入键盘，按下按键出现按键类型和键码变化')
          .width(312)
          .height(20)
          .fontSize(12)
          .fontColor('#182431 ')
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .focusable(false)
          .margin({ left: 12, right: 12, top: 38, bottom: 18 })
        Button('KeyEvent')
          .onKeyEvent((event: KeyEvent) => {
            if (event.type === KeyType.Down) {
              this.eventType = 'Down'
            }
            if (event.type === KeyType.Up) {
              this.eventType = 'Up'
            }
            console.info(this.text = 'KeyType:' + this.eventType
            + '\n KeyCode:' + event.keyCode
            + '\n KeyText:' + event.keyText
            + '\n KeySource:' + event.keySource
            + '\n deviceId:' + event.deviceId
            + '\n metaKey:' + event.metaKey
            )
          })
        Text(this.text).fontSize(15)
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