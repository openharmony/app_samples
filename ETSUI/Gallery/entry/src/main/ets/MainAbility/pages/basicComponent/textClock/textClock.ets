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

@Entry
@Component
struct TextClockSample {
  @State passTime: number = 0;
  @State timeZoneOffset: number = -8;
  controller: TextClockController = new TextClockController()

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {

      NavigationBar({ title: 'TextClock' })

      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            Text('current milliseconds is:' + this.passTime).fontSize(16).width("100%").textAlign(TextAlign.Center)
            TextClock({ timeZoneOffset: this.timeZoneOffset, controller: this.controller })
              .format('hhmmss')
              .onDateChange((value: number) => {
                this.passTime = value
              })
              .margin(40)
              .fontSize(30)
          }
          .width("100%")
        }
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
            Button("start TextClock")
              .borderRadius(16)
              .fontSize(12)
              .backgroundColor("#007DFF")
              .fontColor("#FFFFFF")
              .fontWeight(FontWeight.Medium)
              .onClick(() => {
                this.controller.start()
              });
            Button("stop TextClock")
              .borderRadius(14)
              .fontSize(12)
              .backgroundColor("#007DFF")
              .fontColor("#FFFFFF")
              .fontWeight(FontWeight.Medium)
              .onClick(() => {
                this.controller.stop()
              });
          }
          .width("100%")
          .height("10%")
          .borderRadius(24)
          .padding({ left: "1%", right: "1%" })
          .margin({ bottom: 8 })
          .backgroundColor("#FFFFFF")

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('timeZoneOffset').fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Counter() {
              Text("" + this.timeZoneOffset).fontSize(18)
            }
            .onInc(() => {
                this.timeZoneOffset >= 12 ? 12 : this.timeZoneOffset++
            })
            .onDec(() => {
                this.timeZoneOffset <= -14 ? -14 : this.timeZoneOffset--
            })
          }
          .width('100%')
          .height("6%")
          .padding({ left: '3%', right: '4%' })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
        .width('100%')
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