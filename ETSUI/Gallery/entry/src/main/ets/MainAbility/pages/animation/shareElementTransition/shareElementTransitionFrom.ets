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
struct ShareElementTransitionFromSample {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: '共享元素转场' })
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Navigator({
          target: 'pages/animation/shareElementTransition/shareElementTransitionTo',
          type: NavigationType.Push
        }) {
          Image($r('app.media.heart'))
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Contain)
            .sharedTransition('sharedImage', { duration: 370 })
        }.width('20%')

        Text('sharedTransition')
          .textAlign(TextAlign.Center)
          .fontSize(20)
          .fontColor('#000')
          .height(40)
      }.height('11.1%')
      .borderRadius(24)
      .padding({ left: '3.6%', right: '5.4%', top: 12, bottom: 12 })
      .backgroundColor('#ffffff')
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