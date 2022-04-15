// @ts-nocheck
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
import Curves from '@ohos.curves';

@Entry
@Component
struct ShowAnimationSample {
  @State rotateX: number = 0
  @State rotateY: number = 0
  @State width: number= 140
  @State height: number= 140
  @State angle: number= 0
  @State scaleX: number= 1
  @State scaleY: number= 1
  private flag: boolean = true

  animate() {
    if (this.flag) {
      animateTo({
        duration: 3000,
        onFinish: () => {
          console.info(`${this.duration}`)
        }
      }, () => {
        this.angle = 2160
        this.scaleX = 1.5
        this.scaleY = 1.5
      })
    } else {
      animateTo({
        duration: 3000,
        onFinish: () => {
          console.info(`${this.duration}`)
        }
      }, () => {
        this.angle = 0
        this.scaleX = 1
        this.scaleY = 1
      })
    }
    this.flag = !this.flag
  }

  build() {
    Column() {
      NavigationBar({ title: '显式动画' })
      Stack() {
        Column() {
          Image($r('app.media.windmill'))
        }
        .width(240)
        .height(240)
        .margin({ top: 5 })
        .scale({
          x: this.scaleX,
          y: this.scaleY,
          z: 1,
          centerX: '50%',
          centerY: '50%'
        })
        .rotate({
          x: 0,
          y: 0,
          z: 1,
          centerX: '50%',
          centerY: '50%',
          angle: this.angle
        })
      }
      .backgroundColor('rgb(51,51,51)')
      .width('100%')
      .height('56%')
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })

      Button('play')
        .height(28)
        .backgroundColor('#007DFF')
        .borderRadius(14)
        .fontSize('12fp')
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Medium)
        .onClick(() => {
          this.animate()
        })
    }
    .width('100%')
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
