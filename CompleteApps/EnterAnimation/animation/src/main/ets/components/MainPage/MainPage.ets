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

import router from '@ohos.router'
import window from '@ohos.window'

const SKIP_COUNTDOWN: number = 3

@Entry
@Component
export struct TransitionsAnimation {
  @State pageCountDown: number = 6
  gotoNav: () => void

  aboutToAppear() {
    window.getTopWindow(getContext(this)).then(result => {
      result.setFullScreen(true)
    })
    let timer = setInterval(() => {
      this.pageCountDown--
      if (this.pageCountDown == 0) {
        window.getTopWindow(getContext(this)).then(result => {
          result.setFullScreen(false)
        })
        this.gotoNav() // 6秒后执行gotoNav函数跳转到首页
        clearInterval(timer) // 关闭定时器
      }
    }, 1000)
  }

  // 自定义转场
  pageTransition() {
    PageTransitionEnter({ duration: 1200 })
      .slide(SlideEffect.Left)
    PageTransitionExit({ delay: 100 })
      .translate({ x: 100.0, y: 100.0 })
      .opacity(0)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      if (this.pageCountDown > SKIP_COUNTDOWN) {
        Image($r('app.media.enterApp'))
          .objectFit(ImageFit.Contain)
      } else if (this.pageCountDown <= SKIP_COUNTDOWN) {
        Column() {
          Row() {
            Image($r('app.media.enterAppAnimation'))
              .objectFit(ImageFit.Contain)
              .width('80%')
              .aspectRatio(1.4)
          }
          .margin({ top: '181vp' })

          Column() {
            Text($r('app.string.shopping'))
              .fontSize(24)
            Text($r('app.string.shoppingAdvertising'))
              .margin({ top: 10 })
              .fontSize(20)
              .opacity(0.6)
          }
          .margin({ top: '200vp' })
        }

        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Text($r('app.string.skip'))
            .fontSize('16vp')
            .textAlign(TextAlign.Center)
            .fontColor('#FFFFFF')
          Text(`${this.pageCountDown}`)
            .fontSize('16vp')
            .textAlign(TextAlign.Center)
            .fontColor('#FFFFFF')
            .margin({ left: '4vp' })
        }
        .position({ x: '75.3%', y: '3%' })
        .width('18.9%')
        .aspectRatio(2.4)
        .backgroundColor('rgba(0,0,0,0.3)')
        .borderRadius('18vp')
        .onClick(() => {
          window.getTopWindow(getContext(this)).then(result => {
            result.setFullScreen(false)
          })
          this.pageCountDown = 0
          router.replace({ url: 'pages/Home' })
        })
      }
    }
    .width('100%')
    .backgroundColor('#f1f3f5')
  }
}