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
import { ArrayType } from "../commonDataType/iterateArray"

@Entry
@Component
struct ConditionsLoopsSample {
  @State iconArray: ArrayType[] = [
    { image: $r("app.media.ic_public_home"), name: 'Home' },
    { image: $r("app.media.ic_public_add"), name: 'Add' },
    { image: $r("app.media.ic_public_app"), name: 'App' },
    { image: $r("app.media.ic_public_albums"), name: 'Albums' }
  ]
  @State selectedIndex: number = 0

  build() {
    Column() {
      NavigationBar({ title: '循环渲染' })
      Flex({ direction: FlexDirection.Column }) {
        Text(`${this.iconArray[this.selectedIndex].name}`)
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .width('100%')
          .flexGrow(1)
        Flex({ justifyContent: FlexAlign.SpaceAround }) {
          ForEach(this.iconArray, (item, index) => {
            Column() {
              Image(this.selectedIndex == index ? item.icon : item.image)
                .width(25)
                .height(25)
              Text(item.name)
                .fontSize(20)
                .fontColor(this.selectedIndex == index ? '#00F' : '#000')
            }
            .width('25%')
            .padding({ top: 9, bottom: 5 })
            .height(60)
            .backgroundColor(this.selectedIndex == index ? '#ddd' : '#fff')
            .onClick(() => {
              this.selectedIndex = index
            })
          })
        }.width('100%')
        .height('10%')
      }
      .flexGrow(1)
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: '8%' })
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