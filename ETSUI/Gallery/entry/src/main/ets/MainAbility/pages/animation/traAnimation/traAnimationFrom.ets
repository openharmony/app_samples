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
import router from '@ohos.router';

@Entry
@Component
struct TraAnimationFromSample {
  @State angle: number= 360
  @State topY: number= 0
  @State leftX: number= 0
  @State rightX: number= 0
  @State leftX1: number= 0
  @State rightX1: number= 0
  @State bottomY: number= 0

  build() {
    Column() {
      NavigationBar({ title: '页面间转场' })
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
          Flex({ justifyContent: FlexAlign.Center }) {
            Text('PAGE')
              .fontSize('35fp')
              .opacity(0.4)
            Text('TRANSITIONS')
              .fontSize('35fp')
              .fontColor('#FFFFFF')
          }.width('100%')

          Text('MOVE TO BOTTOM / FROM TOP')
            .translate({ x: 0, y: this.topY })
            .width(340)
            .height(60)
            .textAlign(TextAlign.Center)
            .fontSize('20fp')
            .fontWeight(FontWeight.Bold)
            .fontColor('#CCCCCC')
            .backgroundColor('#FFFFFF')
            .onClick(() => {
              router.push({
                url: 'pages/animation/traAnimation/traAnimationTo',
                params: { type: SlideEffect.Top, color: '#FFF6CD46' }
              })
            })
            .margin({ top: 30 })
          Text('MOVE TO TOP / FROM BOTTOM')
            .translate({ x: this.leftX, y: 0 })
            .width(340)
            .height(60)
            .textAlign(TextAlign.Center)
            .fontSize('20fp')
            .fontWeight(FontWeight.Bold)
            .fontColor('#CCCCCC')
            .backgroundColor('#FFFFFF')
            .onClick(() => {
              router.push({
                url: 'pages/animation/traAnimation/traAnimationTo',
                params: { type: SlideEffect.Bottom, color: '#ee94b4' }
              })
            })
          Text('MOVE TO RIGHT / FROM LEFT')
            .translate({ x: this.rightX, y: 0 })
            .width(340)
            .height(60)
            .textAlign(TextAlign.Center)
            .fontSize('20fp')
            .fontWeight(FontWeight.Bold)
            .fontColor('#CCCCCC')
            .backgroundColor('#FFFFFF')
            .onClick(() => {
              router.push({
                url: 'pages/animation/traAnimation/traAnimationTo',
                params: { type: SlideEffect.Left, color: '#996666' }
              })
            })
          Text('MOVE TO LEFT / FROM RIGHT')
            .translate({ x: this.leftX1, y: 0 })
            .width(340)
            .height(60)
            .textAlign(TextAlign.Center)
            .fontSize('20fp')
            .fontWeight(FontWeight.Bold)
            .fontColor('#CCCCCC')
            .backgroundColor('#FFFFFF')
            .onClick(() => {
              router.push({
                url: 'pages/animation/traAnimation/traAnimationTo',
                params: { type: SlideEffect.Right, color: '#FF1CBCBC' }
              })
            })

          Text('SCALE')
            .translate({ x: this.rightX1, y: 0 })
            .width(340)
            .height(60)
            .textAlign(TextAlign.Center)
            .fontSize('20fp')
            .fontWeight(FontWeight.Bold)
            .fontColor('#CCCCCC')
            .backgroundColor('#FFFFFF')
            .onClick(() => {
              router.push({
                url: 'pages/animation/traAnimation/traAnimationTo',
                params: { type: SlideEffect.Left, color: '#ee94b4' }
              })
            })
          Text('ROTATE')
            .translate({ x: 0, y: this.bottomY })
            .width(340)
            .height(60)
            .textAlign(TextAlign.Center)
            .fontSize('20fp')
            .fontWeight(FontWeight.Bold)
            .fontColor('#CCCCCC')
            .backgroundColor('#FFFFFF')
            .onClick(() => {
              router.push({
                url: 'pages/animation/traAnimation/traAnimationTo',
                params: { type: SlideEffect.Bottom, color: '#ee94b4', angle: this.angle }
              })
            })
        }
        .width('100%')
        .height('70%')
        .margin({ top: 20 })
      }
      .clip(true)
      .height('100%')
      .width('100%')
      .backgroundColor('#db95e5')
      .padding({ left: '3%', right: '3%' })
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 10 })
  }

  pageTransition() {
    PageTransitionEnter({ duration: 370, curve: Curve.Linear })
      .onEnter((type: RouteType, progress: number) => {
        this.topY = (-progress + 1) * this.topY
        this.bottomY = (-progress + 1) * this.bottomY
        this.leftX = (-progress + 1) * this.leftX
        this.leftX1 = (-progress + 1) * this.leftX1
        this.rightX = (-progress + 1) * this.rightX
        this.rightX1 = (-progress + 1) * this.rightX1
      })

    PageTransitionExit({ duration: 370, curve: Curve.Ease })
      .onExit((type: RouteType, progress: number) => {
        this.topY = -600 * progress
        this.bottomY = -600 * progress
        this.leftX = -600 * progress
        this.rightX = 600 * progress
        this.leftX1 = -600 * progress
        this.rightX1 = 600 * progress
      })
  }
}