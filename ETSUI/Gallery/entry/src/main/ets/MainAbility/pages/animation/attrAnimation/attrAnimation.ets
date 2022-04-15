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
struct AttrAnimationSample {
  @State flag: boolean= true
  @State borderColor: string= '#ca760f'
  @State borderRadius: number= 0
  @State backGroundColor: string= '#0099FF'
  @State width: number= 200
  @State height: number= 100
  @State opacity: number= 1
  @State fontColor: string= '#2ad085'

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: '属性动画' })
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
        Text('ANIMATION')
          .width(this.width)
          .height(this.height)
          .backgroundColor(this.backGroundColor)
          .border({ width: 5, color: this.borderColor })
          .borderRadius(this.borderRadius)
          .opacity(this.opacity)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.borderColor)
          .animation({
            duration: 800,
            curve: Curve.EaseOut,
            iterations: 1,
            playMode: PlayMode.Normal
          })

        Text('change  random  property')
          .fontColor('#FFFFFF')
          .fontSize('14fp')
          .fontWeight(FontWeight.Bolder)
          .backgroundColor('#4D4D4D')
          .opacity(0.95)
          .padding(20)
          .onClick((event: ClickEvent) => {
            let randomWidth = Math.ceil((Math.random() + 2) * 100)
            let randomHeight = Math.ceil((Math.random() + 2) * 100)
            let randomR = Math.floor(Math.random() * 255)
            let randomG = Math.floor(Math.random() * 255)
            let randomB = Math.floor(Math.random() * 255)
            let randomBackGroundColor = `rgb(${randomR},${randomG},${randomB})`
            let randomBorderColor = `rgb(${randomG},${randomR},${randomB})`
            let randomFontColor = `rgb(${randomB},${randomR},${randomG})`
            let randomRadius = Math.ceil((Math.random() + 1) * 50)
            let randomOpacity = Math.ceil(Math.random())
            if (this.flag) {
              this.width = randomWidth
              this.height = randomHeight
              this.backGroundColor = randomBackGroundColor
              this.borderRadius = randomRadius
              this.borderColor = randomBorderColor
              this.opacity = randomOpacity
              this.fontColor = randomFontColor
            } else {
              this.width = randomWidth
              this.height = randomHeight
              this.backGroundColor = randomBackGroundColor
              this.borderRadius = randomRadius
              this.borderColor = randomBorderColor
              this.opacity = randomOpacity
              this.fontColor = randomFontColor
            }
            this.flag = !this.flag
          })
      }.height('50%')
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