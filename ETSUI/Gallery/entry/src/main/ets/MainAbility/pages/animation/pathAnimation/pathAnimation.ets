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
struct PathAnimationSample {
  @State path: string= 'M0,0 ' +
  'C20,100.143 40.90861,80 60,18 ' +
  'C80.09139,119 100,-62.90861 120,66 ' +
  'C140,110.86 160,24.54 180,-90.6 ' +
  'C200,-100 220,10.13 240,108.15 ' +
  'C260,79.23 280,-44.23 300,-112.43 ' +
  'C320,-48.51 340,64.05 360,108.15 ' +
  'C380,104.143 400.90861,86 420,36 ' +
  'C440.09139,114 460,200,480.90861,66' +
  'C500,110.86 520,24.54 540,-90.6 ' +
  'C560,-100 580,10.13 600,108.15 ' +
  'C620,-79 640,-44.23 660,-112.43 ' +
  'C680,-48.51 700,-64.23 720,-108.43 '
  @State toggle: boolean= true

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: '路径动画' })
      Column() {
        Column() {
          Row() {
            Image($r('app.media.plane'))
          }
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            centerX: '50%',
            centerY: '70%',
            angle: 90
          })
          .width(50)
          .height(50)
          .motionPath({ path: this.path, from: 0.0, to: 1.0, rotatable: true })
        }.margin({ top: 100 })
        .width('100%').height('100%').alignItems(this.toggle ? HorizontalAlign.Start : HorizontalAlign.End)
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .backgroundColor('#696969')

      Button('play')
        .width(120)
        .height(60)
        .backgroundColor('#007DFF')
        .fontSize('24fp')
        .fontWeight(FontWeight.Medium)
        .fontColor("#FFFFFF")
        .margin({ top: 120 })
        .onClick((event: ClickEvent) => {
          animateTo({ duration: 6000, curve: Curve.Linear }, () => {
            this.toggle = !this.toggle;
          })
        })
    }.height('100%')
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