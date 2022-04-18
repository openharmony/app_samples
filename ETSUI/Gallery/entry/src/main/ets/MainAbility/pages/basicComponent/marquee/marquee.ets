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
import { MenuComponent } from "../../../common/components/menuComponent"

@Entry
@Component
struct MarqueeSample {
  @State start: boolean = false;
  @State fromStart: boolean = true;
  @State step: number = 50;
  @State loop: number = 2;
  @State src: string = "Running Marquee starts rolling";
  @State isOn: boolean = false;
  @State content: any[] = [5, 25, 50, 75]

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: 'Marquee' })
      Column() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Text('Marquee')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 30 })
          Marquee({
            start: this.start,
            step: this.step,
            loop: this.loop,
            fromStart: this.fromStart,
            src: this.src
          })
            .fontColor(Color.White)
            .fontSize(50)
            .allowScale(false)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(Color.Black)
            .onStart(() => {
              console.log('Marquee animation complete onStart')
            })
            .onBounce(() => {
              console.log('Marquee animation complete onBounce')
            })
            .onFinish(() => {
              console.log('Marquee animation complete onFinish')
              this.start = false
            })
        }
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 302 })
      .backgroundColor('#FFB6C1')
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })

      Scroll() {
        Column() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            Button('start')
              .borderRadius(14)
              .backgroundColor('#007DFF')
              .fontSize('12fp')
              .fontWeight(FontWeight.Medium)
              .fontColor("#FFFFFF")
              .padding({ left: 8, right: 8, top: 8, bottom: 8 })
              .onClick(() => {
                this.start = true
              })
            Button('stop')
              .borderRadius(14)
              .backgroundColor('#007DFF')
              .fontSize('12fp')
              .fontWeight(FontWeight.Medium)
              .fontColor("#FFFFFF")
              .padding({ left: 8, right: 8, top: 8, bottom: 8 })
              .onClick(() => {
                this.start = false
              })
          }
          .width('100%')
          .height(35)

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('fromStart')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Toggle({ type: ToggleType.Switch, isOn: this.isOn })
              .width(35)
              .height(20)
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                console.info('Component status:' + isOn)
                this.fromStart = !this.fromStart
                this.isOn = !this.isOn
                this.start = false
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          //控件写法
          MenuComponent({ title: 'step', transferParameters: $content, items: $step })
          //原本写法
          //          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          //            Text('step')
          //              .fontColor('#182431')
          //              .fontSize('16fp')
          //              .fontWeight(FontWeight.Medium)
          //              .opacity(0.5)
          //            Text(`${this.step}`)
          //              .fontColor('#182431')
          //              .fontSize('16fp')
          //              .fontWeight(FontWeight.Medium)
          //              .width('50%')
          //              .textAlign(TextAlign.End)
          //              .bindMenu([
          //                {
          //                  value: '5',
          //                  action: () => {
          //                    this.step = 5
          //                  }
          //                },
          //                {
          //                  value: '25',
          //                  action: () => {
          //                    this.step = 25
          //                  }
          //                },
          //                {
          //                  value: '50',
          //                  action: () => {
          //                    this.step = 50
          //                  }
          //                },
          //                {
          //                  value: '75',
          //                  action: () => {
          //                    this.step = 75
          //                  }
          //                },
          //              ])
          //          }
          //          .width('100%')
          //          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          //          .borderRadius(24)
          //          .backgroundColor('#FFFFFF')
          //          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('loop')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)

            Text(`${this.loop}`)
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.End)
              .bindMenu([
                {
                  value: '-1',
                  action: () => {
                    this.loop = -1
                  }
                },
                {
                  value: '3',
                  action: () => {
                    this.loop = 3
                  }
                },
                {
                  value: '5',
                  action: () => {
                    this.loop = 5
                  }
                },
                {
                  value: '10',
                  action: () => {
                    this.loop = 10
                  }
                },
              ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('src')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)

            Text(`${this.src}`)
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.End)
              .bindMenu([
                {
                  value: "Enter by yourself",
                  action: () => {
                    this.src = "Enter by yourself"
                  }
                },
                {
                  value: 'Running Marquee starts rolling',
                  action: () => {
                    this.src = "Running Marquee starts rolling"
                  }
                },
              ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
      }
      .margin({ top: 24 })
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