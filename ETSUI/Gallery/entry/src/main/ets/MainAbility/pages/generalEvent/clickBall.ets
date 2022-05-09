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
struct ClickBallSample {
  @State balloonNumber: number = 3
  private ballsNumber: any[] = []

  private aboutToAppear(): void{
    for (let i = 0; i < this.balloonNumber; i++) {
      this.ballsNumber.length = this.balloonNumber
    }
  }

  build() {
    Column() {
      NavigationBar({ title: '点击事件' })
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
        ForEach(this.ballsNumber, (item, index) => {
          Ball()
        })
      }
      .width('100%')
      .height('50%')
      .backgroundColor(Color.White)
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

@Component
struct Ball {
  @State balloonWidth: number = 60
  @State balloonHeight: number = 60
  @State balloonPositionX: number = 1
  @State balloonPositionY: number = 270

  build() {
    Column() {
      Text()
        .width(this.balloonWidth)
        .height(this.balloonHeight)
        .borderRadius(60)
        .position({ x: this.balloonPositionX, y: this.balloonPositionY })
        .backgroundColor(Color.Pink)
        .onClick(() => {
          let timer = setInterval(() => {
            this.balloonWidth -= 4
            this.balloonHeight -= 4
            this.balloonPositionX -= 4
            this.balloonPositionY -= 30
            console.info(this.balloonWidth.toString())
            if (this.balloonWidth <= 0) {
              clearInterval(timer)
            }
          }, 30)
        })
    }
    .width(100)
    .height(370)
  }
}