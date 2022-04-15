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

import { NavigationBar } from "../../common/components/navigationBar"

@Entry
@Component
struct BasicGestureExample {
  @State colOpacity: number = 1
  @State count: number = 0
  @State offsetX: number = 0
  @State offsetY: number = 0
  @State scale: number = 1
  @State angle: number = 0
  @State eventType: string = ''
  @State borderRadius: number = 0
  @State borderWidth: number = 0
  @State gestureValue: string = ''

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      NavigationBar({ title: '基础手势' })
      Column() {
        Text('点击两下&长按&平移&双指捏合&旋转手势').fontSize(15)
        Flex({
          direction: FlexDirection.Column,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceBetween
        }) {
          Image('/common/test1.jpg')
        }
        .margin(20)
        .height(200)
        .width(300)
        .borderWidth(this.borderWidth)
        .borderColor(Color.Green)
        .border({ style: BorderStyle.Solid })
        .borderRadius(this.borderRadius)
        .opacity(this.colOpacity)
        .translate({ x: this.offsetX, y: this.offsetY, z: 5 })
        .scale({ x: this.scale, y: this.scale, z: this.scale })
        .rotate({ x: 1, y: 2, z: 3, angle: this.angle })
        .gesture(
        GestureGroup(GestureMode.Parallel,
        TapGesture({ count: 2, fingers: 1 })
          .onAction(() => {
            this.borderWidth += 1
          }),
        LongPressGesture({ fingers: 1, repeat: true, duration: 1000 })
          .onAction((event: GestureEvent) => {
            this.colOpacity -= 0.1
            if (event.repeat) {
              this.count++
            }
          })
          .onActionEnd(() => {
            this.colOpacity = 1;
            this.count = 0;
          }),
        PanGesture({ fingers: 1, direction: PanDirection.All, distance: 5.0 })
          .onActionStart(() => {
            console.info('Pan start')
          })
          .onActionUpdate((event: GestureEvent) => {
            this.offsetY = event.offsetY;
            this.offsetX = event.offsetX;
          })
          .onActionEnd(() => {
            console.info('Pan end')
          }),
        PinchGesture({ fingers: 2, distance: 4 })
          .onActionStart(() => {
            console.info('PinchGesture start')
          })
          .onActionUpdate((event: GestureEvent) => {
            this.scale = event.scale
            this.borderRadius = 10
          })
          .onActionEnd(() => {
            console.info('PinchGesture end')
          }),
        RotationGesture({ fingers: 2, angle: 2 })
          .onActionStart(() => {
            console.info('RotationGesture start')
          })
          .onActionUpdate((event: GestureEvent) => {
            this.angle = event.angle
          })
          .onActionEnd(() => {
            console.info('RotationGesture end')
          })
        )
          .onCancel(() => {
            console.log('Parallel gesture canceled')
          })
        )
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })

      Column() {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text('angle')
            .fontSize('16fp')
            .opacity(0.5)
            .fontColor('#182431')
            .fontWeight(FontWeight.Medium)
          Column() {
            Text(`${this.angle}`)
              .fontSize('16fp')
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.End)
          }
          .bindMenu([
            {
              value: '-10',
              action: () => {
                this.angle = -10
              }
            },
            {
              value: '0',
              action: () => {
                this.angle = 0
              }
            },
            {
              value: '10',
              action: () => {
                this.angle = 10
              }
            }
          ])
        }
        .width('100%')
        .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
        .borderRadius(24)
        .backgroundColor('#FFFFFF')
        .margin({ top: 8 })

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text('scale')
            .fontSize('16fp')
            .opacity(0.5)
            .fontColor('#182431')
            .fontWeight(FontWeight.Medium)
          Column() {
            Text(`${this.scale}`)
              .fontSize('16fp')
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.End)
          }
          .bindMenu([
            {
              value: '1.1',
              action: () => {
                this.scale = 1.1
              }
            },
            {
              value: '1',
              action: () => {
                this.scale = 1
              }
            },
            {
              value: '-1',
              action: () => {
                this.scale = -1
              }
            }
          ])
        }
        .width('100%')
        .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
        .borderRadius(24)
        .backgroundColor('#FFFFFF')
        .margin({ top: 8 })
      }
    }
    .width('100%')
    .backgroundColor('#F1F1F5')
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