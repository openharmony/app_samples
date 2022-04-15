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
struct AppearEventSample {
  @State isShow: boolean = true
  @State myText: string = 'Text for onAppear'
  @State changeAppear: string = 'Hide Text'

  build() {
    Column() {
      NavigationBar({ title: '挂载卸载事件' })
      Column() {
        Text('挂载&卸载事件')
          .width(312)
          .height(20)
          .fontSize('12fp')
          .fontColor('#182431 ')
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .margin({ left: 12, right: 12, top: 77, bottom: 18 })
        Button(this.changeAppear)
          .fontSize(16)
          .onClick(() => {
            this.isShow = !this.isShow
          })
          .margin({ bottom: 12 })
        if (this.isShow) {
          Text(this.myText)
            .width(312)
            .height(50)
            .fontSize(30)
            .fontColor('#182431 ')
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Center)
            .margin({ top: 60, left: 12, right: 12, bottom: 18 })
            .onAppear(() => {
              this.changeAppear = 'Show Text'
              prompt.showToast({ message: 'The text is  onAppear', duration: 1000 })
            })
            .onDisAppear(() => {
              this.changeAppear = 'Hide Text'
              prompt.showToast({ message: 'The text is  onDisAppear', duration: 1000 })
            })
        }
      }
      .width('100%')
      .height(402)
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