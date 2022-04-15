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
import matrix4 from '@ohos.matrix4';

@Component
struct Card {
  @State angle: number= 0
  private startY: number = 0
  @State rotateX: number= 0
  @State rotateZ: number= 1

  build() {
    Row() {
      Text('1')
        .fontWeight(FontWeight.Bold)
        .backgroundColor('black')
        .fontColor('white')
        .fontSize(200)
        .width(200)
        .height(200)
        .lineHeight(200)
        .textAlign(TextAlign.Center)
    }
    .clip(true)
    .width(200)
    .height(200)
    .borderRadius(20)
    .transform(matrix4.init(
      [1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 1 / 1000,
      0, 0, 0, 1]))
    .rotate({
      x: this.rotateX,
      y: 0,
      z: this.rotateZ,
      angle: this.angle,
      centerX: '50%',
      centerY: '50%',
    })
    .onTouch((event: TouchEvent) => {
      console.log(JSON.stringify(event.touches))
      if (event.type == TouchType.Down) {
        this.startY = event.touches[0].screenY
      } else if (event.type == TouchType.Move) {
        if (event.touches[0].x >= 200 || event.touches[0].x <= -200) {
          this.rotateZ = 1, this.rotateX = 0
          let x = event.touches[0].screenX
          this.angle = 180 * (x - this.startY) / 100
        } else if (event.touches[0].y >= 200 || event.touches[0].y <= -200) {
          this.rotateZ = 0, this.rotateX = 1
          let y = event.touches[0].screenY
          this.angle = 180 * (y - this.startY) / 100
        }
      }
    })
  }
}

@Entry
@Component
struct MatrixTransitionSample {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center}) {
      NavigationBar({ title: '矩阵变换' })
     Flex({ justifyContent:FlexAlign.Center, alignItems: ItemAlign.Center}){
        Card()
      }.flexGrow(1)
      .backgroundColor('#FFFFFF')
      .width('100%')
    }
    .height('100%')
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