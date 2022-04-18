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
struct TextTimerSample {
  @State format: string = 'mm:ss.ms';
  @State isCountDown: boolean = false;
  @State minutes: number = 1;
  myTimerController: TextTimerController = new TextTimerController();

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {

      NavigationBar({ title: 'TextTimer' })

      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            Text('计时显示')
              .width("100%")
              .height("10%")
              .fontSize(18)
              .margin({ bottom: 10 })
              .textAlign(TextAlign.Center)

            TextTimer({
              controller: this.myTimerController,
              isCountDown: this.isCountDown,
              count: this.minutes * 60000
            })
              .format(this.format)
              .fontColor(Color.Black)
              .height("20%")
              .fontSize(50)
              .onTimer((utc: number, elapsedTime: number) => {
                console.info('textTimer notCountDown utc is：' + utc + ', elapsedTime: ' + elapsedTime)
              })
          }
          .width("100%")
        }
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })
      .backgroundColor("#FFFFFF")


      Scroll() {
        Column() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap }) {
            Button("开始计时")
              .width("30%")
              .borderRadius(14)
              .fontSize(12)
              .backgroundColor("#007DFF")
              .fontColor("#FFFFFF")
              .fontWeight(FontWeight.Medium)
              .margin({ top: 15, bottom: 10 })
              .onClick(() => {
                this.isCountDown = false;
                this.myTimerController.start();
                this.minutes = 1;
              });
            Button("暂停计时")
              .width("30%")
              .borderRadius(14)
              .fontSize(12)
              .backgroundColor("#007DFF")
              .fontColor("#FFFFFF")
              .fontWeight(FontWeight.Medium)
              .margin({ top: 15, bottom: 10 })
              .onClick(() => {
                this.myTimerController.pause();
              });
            Button("重置计时")
              .width("30%")
              .borderRadius(14)
              .fontSize(12)
              .backgroundColor("#007DFF")
              .fontColor("#FFFFFF")
              .fontWeight(FontWeight.Medium)
              .margin({ top: 15, bottom: 10 })
              .onClick(() => {
                this.myTimerController.reset();
                this.minutes = 1;
              });

            Button("开始倒计时")
              .width("30%")
              .borderRadius(14)
              .fontSize(12)
              .backgroundColor("#007DFF")
              .fontColor("#FFFFFF")
              .fontWeight(FontWeight.Medium)
              .onClick(() => {
                this.isCountDown = true;
                this.myTimerController.start();
              });
            Button("暂停倒计时")
              .width("30%")
              .borderRadius(14)
              .fontSize(12)
              .backgroundColor("#007DFF")
              .fontColor("#FFFFFF")
              .fontWeight(FontWeight.Medium)
              .onClick(() => {
                this.myTimerController.pause();
              });
            Button("重置倒计时")
              .width("30%")
              .borderRadius(14)
              .fontSize(12)
              .backgroundColor("#007DFF")
              .fontColor("#FFFFFF")
              .fontWeight(FontWeight.Medium)
              .onClick(() => {
                this.myTimerController.reset();
                this.minutes = 1;
              });
          }
          .width("100%")
          .height("15%")
          .borderRadius(24)
          .padding({ left: "1%", right: "1%" })
          .margin({ bottom: 8 })
          .backgroundColor("#FFFFFF")

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('count:').fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Counter() {
              Text("" + this.minutes).fontSize(18)
            }
            .onInc(() => {
              this.minutes++
            })
            .onDec(() => {
                this.minutes > 0 ? this.minutes-- : 0
            })
          }
          .width('100%')
          .height("6%")
          .padding({ left: '3%', right: '4%' })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
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

