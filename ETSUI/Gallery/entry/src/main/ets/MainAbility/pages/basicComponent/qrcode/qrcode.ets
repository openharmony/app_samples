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
import { GetColor } from "../../../common/components/getColor"

@Entry
@Component
struct QrCodeSample {
  @State value: string = "hello world"
  @State setColor: string = 'rgba(0,0,0,1)'

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: 'QRCode' })

      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            QRCode(this.value)
              .color(this.setColor)
              .width(200)
              .height(200)
          }.width('100%')
        }
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .width('100%')
      .padding(18)
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('value')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              Text(`${this.value}`)
                .fontSize('10fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'hello world',
                action: () => {
                  this.value = "hello world"
                }
              },
              {
                value: 'just do it',
                action: () => {
                  this.value = "just do it"
                }
              },
              {
                value: 'to be No.1',
                action: () => {
                  this.value = "to be No.1"
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('color')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              GetColor({ colorVal: $setColor })
            }.width(48)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }.width('100%')
      }
      .width('100%')
      .margin({ top: 24 })
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 20 })
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