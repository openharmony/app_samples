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
struct LoadingProgressSample {
  @State color: Color = Color.Black
  @State arr_color: string[]= []

  private getRandomColor(): string{
    let randomColor: string = '#';
    let hexadecimal: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
    while (randomColor.length < 7) {
      randomColor += hexadecimal[Math.floor(Math.random() * (hexadecimal.length))]
    }
    return randomColor;
  }

  private aboutToAppear(): void{
    for (let i = 0;i < 6; i++) {
      this.arr_color.push(this.getRandomColor())
    }
  }

  build() {
    Column() {
      NavigationBar({ title: 'LoadingProgress' })

      //上部分显示效果
      Scroll() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          LoadingProgress()
            .color(this.color).margin({ top: '30%' })
        }
        .width('100%')
      }
      .width('100%')
      .height('40%')
      .margin({ top: 20 })

      //下部分属性、属性值
      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('Color:')
              .fontSize(16)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Text('+').fontColor('#FFFFFF').fontSize(26).position({ x: 0, y: -4 })
            }
            .backgroundColor('#000000')
            .width(22)
            .height(22)
            .onClick(() => {
              this.arr_color.push(this.getRandomColor())
            })
          }
          .width('100%')

          Divider().strokeWidth(1).color('#F2F2F2').lineCap(LineCapStyle.Round).margin({ top: 8, bottom: 8 })

          Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
            ForEach(this.arr_color, (item, index) => {
              Column() {
                Column() {
                  Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
                    Column() {
                      Image($r("app.media.ic_public_cancel"))
                    }
                    .borderColor('#F2F2F2')
                    .borderRadius(10)
                    .backgroundColor('rgba(255,255,255,0.3)')
                    .alignItems(HorizontalAlign.Center)
                    .height(10)
                    .width(10)
                    .margin({ right: 2 })
                    .padding(1)
                    .onClick(() => {
                      this.arr_color.splice(index, 1)
                    })
                  }
                  .backgroundColor(item)
                  .width(42)
                  .height(18)
                  .borderRadius(50)
                  .onClick(() => {
                    this.color = item
                  })
                }
                .borderWidth(1)
                .borderColor(item)
                .padding(1)
                .borderRadius(50)
                .margin({ right: 3, left: 3 })
              }.margin({ bottom: 20 })
            }, item => item.toString())
          }
        }
        .width('100%')
        .padding('3%')
        .borderRadius(24)
        .backgroundColor('#FFFFFF')
      }
      .width('100%')
      .height('60%')
      .margin({ top: 24 })
    }
    .width('100%')
    .height('100%')
    .padding({ left: '3%', right: '3%' })
    .backgroundColor('#F1F3F5')
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
