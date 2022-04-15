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
import { NavigationBar } from "../../../common/components/navigationBar";
import Curves from '@ohos.curves';

@Entry
@Component
struct InterpolationSample {
  @State positionX: string= '0%'
  @State flag: boolean = false
  @State width: string= '15%'

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: '插值计算' })
      Column() {
        Text('Curve.Linear')
          .fontSize('12fp')
          .fontColor('#FFFFFF')
          .width(this.width)
          .height(40)
          .textAlign(TextAlign.Center)
          .backgroundColor('#a320bf')
          .animation({ duration: 2000, curve: Curve.Linear })
        Text('Curve.EaseInOut')
          .fontSize('12fp')
          .fontColor('#FFFFFF')
          .width(this.width)
          .height(40)
          .textAlign(TextAlign.Center)
          .backgroundColor('#17d4be')
          .animation({ duration: 2000, curve: Curve.EaseInOut })
          .margin({ top: 10 })
        Text('cubicBezier')
          .fontSize('12fp')
          .fontColor('#FFFFFF')
          .width(this.width)
          .height(40)
          .textAlign(TextAlign.Center)
          .backgroundColor('#d20d4d')
          .margin({ top: 10 })
          .animation({ duration: 2000, curve: Curves.cubicBezier(0.38, 0.2, 1.0, 0.5) })
        Text('Curve.Smooth')
          .fontSize('12fp')
          .fontColor('#FFFFFF')
          .width(this.width)
          .height(40)
          .textAlign(TextAlign.Center)
          .backgroundColor('#0e2d8c')
          .animation({ duration: 2000, curve: Curve.Smooth })
          .margin({ top: 10 })
        Text('Curves.spring')
          .fontSize('12fp')
          .fontColor('#FFFFFF')
          .width(this.width)
          .height(40)
          .textAlign(TextAlign.Center)
          .backgroundColor('#d4bb19')
          .margin({ top: 10 })
          .animation({ duration: 2000, curve: Curves.spring(30, 20, 20, 10) })
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })

      Text('GO!')
        .borderRadius(20)
        .fontColor('#FFFFFF')
        .fontSize('12fp')
        .fontWeight(FontWeight.Bolder)
        .backgroundColor('#15587c')
        .padding(10)
        .onClick(() => {
            this.flag ? this.width = '15%' : this.width = '85%'
            this.flag = !this.flag
        })
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