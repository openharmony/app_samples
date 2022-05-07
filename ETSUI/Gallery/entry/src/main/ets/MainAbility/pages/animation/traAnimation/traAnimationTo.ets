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
import router from '@ohos.router';

@Entry
@Component
struct TraAnimationToSample {
  @State progress: number = 0;
  @State receivedParams: object= {}
  @State type: SlideEffect = SlideEffect.Left;
  @State color: string= ''
  @State angle: number= 1

  private aboutToAppear() {
    this.receivedParams = router.getParams()
    this.type = this.receivedParams['type'];
    this.color = this.receivedParams['color'];
    this.angle = this.receivedParams['angle']
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Row() {
        Text('PAGE')
          .fontSize('50fp')
          .opacity(0.4)
        Text('TRANSITIONS')
          .fontSize('50fp')
          .fontColor('#FFFFFF')
      }

      Text('back to pageTransition')
        .width(350)
        .height(70)
        .textAlign(TextAlign.Center)
        .fontSize('30fp')
        .fontWeight(FontWeight.Bold)
        .fontColor('#CCCCCC')
        .backgroundColor('#FFFFFF')
        .onClick(() => {
          router.back()
        })
        .margin({ top: '20%' })
    }
    .width('100%')
    .height('100%')
    .rotate({ z: 1, angle: this.progress * this.angle })
    .scale({ x: this.progress, y: this.progress })
    .opacity(this.progress)
    .backgroundColor(`${this.color}`)
  }

  pageTransition() {
    PageTransitionEnter({ duration: 370, curve: Curve.Linear })
      .onEnter((type: RouteType, progress: number) => {
        this.progress = progress
      }).slide(this.type)

    PageTransitionExit({ duration: 370, curve: Curve.Ease })
      .slide(this.type)
      .onExit((type: RouteType, progress: number) => {
        this.progress = progress
      })
  }
}

