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
struct StackSample {
  @State alignDirection: string = "Bottom"
  @State fontDirection: string = "Top"

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: 'Stack' })
      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Stack({ alignContent: Alignment[this.alignDirection] }) {
              Column()
                .width('100%')
                .height('100%')
                .backgroundColor(0xF1F3F5)
                .border({ width: 5, color: 0x2788D9, radius: 10, style: BorderStyle.Solid })
              Divider()
                .vertical(false)
                .strokeWidth(5)
                .color(0x2788D9)
                .lineCap(LineCapStyle.Round)
                .width('100%')
                .position({ x: 0, y: '33.3%' })
              Divider()
                .vertical(false)
                .strokeWidth(5)
                .color(0x2788D9)
                .lineCap(LineCapStyle.Round)
                .width('100%')
                .position({ x: 0, y: '66.6%' })
              Divider()
                .vertical(true)
                .strokeWidth(5)
                .color(0x2788D9)
                .lineCap(LineCapStyle.Round)
                .width('100%')
                .position({ x: '-16.7%', y: 0 })
              Divider()
                .vertical(true)
                .strokeWidth(5)
                .color(0x2788D9)
                .lineCap(LineCapStyle.Round)
                .width('100%')
                .position({ x: '16.7%', y: 0 })
              Text('First Child')
                .width('33%')
                .height('33.7%')
                .backgroundColor(0x2788D9)
                .align(Alignment[this.fontDirection])
                .textAlign(TextAlign.Center)
                .fontSize('15fp')
                .padding({ top: '3%', bottom: '4%' })
              Text('Second Child')
                .width('20%')
                .height('17%')
                .backgroundColor('red')
                .border({ width: 5, color: 0x2788D9, radius: 10, style: BorderStyle.Solid })
                .fontSize('16fp')
                .textAlign(TextAlign.Center)
            }.width('60%').height('81%')
          }.width('100%').height('100%')
        }.width('100%')
      }.width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('align')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.alignDirection}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: 'TopStart',
                action: () => {
                  this.alignDirection = "TopStart"
                  this.fontDirection = "Bottom"
                }
              },
              {
                value: 'Top',
                action: () => {
                  this.alignDirection = "Top"
                  this.fontDirection = "Bottom"
                }
              },
              {
                value: 'TopEnd',
                action: () => {
                  this.alignDirection = "TopEnd"
                  this.fontDirection = "Bottom"
                }
              },
              {
                value: 'Start',
                action: () => {
                  this.alignDirection = "Start"
                  this.fontDirection = "Top"
                }
              },
              {
                value: 'Center',
                action: () => {
                  this.alignDirection = "Center"
                  this.fontDirection = "Top"
                }
              },
              {
                value: 'End',
                action: () => {
                  this.alignDirection = "End"
                  this.fontDirection = "Top"
                }
              },
              {
                value: 'BottomStart',
                action: () => {
                  this.alignDirection = "BottomStart"
                  this.fontDirection = "Top"
                }
              },
              {
                value: 'Bottom',
                action: () => {
                  this.alignDirection = "Bottom"
                  this.fontDirection = "Top"
                }
              },
              {
                value: 'BottomEnd',
                action: () => {
                  this.alignDirection = "BottomEnd"
                  this.fontDirection = "Top"
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8, bottom: 20 })
        }.width('100%')
      }
    }
    .width('100%')
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
