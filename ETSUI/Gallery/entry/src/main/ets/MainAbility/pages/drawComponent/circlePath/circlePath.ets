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

const COLOR_TRANSPARENT = '#00000000'
const COLOR_BACKGROUND_FILL = '#7ebede'

const DIAMETER = 200;
const RADIUS_IN_PX = vp2px(DIAMETER / 2.0);
const BIG_DIAMETER = 220;
const BIG_RADIUS_IN_PX = vp2px(BIG_DIAMETER / 2.0);

@Entry
@Component
struct CircleSample {
  @State outSetValue: number = 50
  @State pathCommands: string = ''
  @State backGroundColor: string = '#00000000'

  onPageShow() {
    this.pathCommands = this.calPathCommands(this.outSetValue);
  }

  calXSquare(y: number) {
    return RADIUS_IN_PX * RADIUS_IN_PX - (y - RADIUS_IN_PX) * (y - RADIUS_IN_PX);
  }

  calY(k: number) {
    return (1 - k) * RADIUS_IN_PX * 2;
  }

  formatPathCommands(x1: number, x2: number, y: number, radius: number) {
    return `M${x1} ${y} A${radius} ${radius} 0 ${y > RADIUS_IN_PX ? 0 : 1} 0  ${x2} ${y} `
    + `Q${(x1 + 3 * x2) / 4} ${y + 12.5 * (x2 - x1) / radius}, ${(x1 + x2) / 2} ${y} T${x1} ${y}`
  }

  calPathCommands(value: number) {
    let y = this.calY(value / 100.0)
    let squareX = this.calXSquare(y)
    if (squareX >= 0) {
      let x = Math.sqrt(squareX);
      let x1 = RADIUS_IN_PX - x;
      let x2 = RADIUS_IN_PX + x;
      return this.formatPathCommands(x1, x2, y, RADIUS_IN_PX);
    }
    return "";
  }

  build() {

    Column() {
      NavigationBar({ title: "绘制组件" })

      Column() {
        Stack() {
          Circle({ width: BIG_DIAMETER, height: BIG_DIAMETER })
            .fill(COLOR_TRANSPARENT)
            .stroke('#007DFF')
            .strokeWidth(5)
          Shape() {
            Circle({ width: DIAMETER, height: DIAMETER })
              .fill(this.backGroundColor)
            Path()
              .width(DIAMETER)
              .height(DIAMETER)
              .commands(this.pathCommands)
              .fill(COLOR_BACKGROUND_FILL)
          }
          .width(DIAMETER)
          .height(DIAMETER)

          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Text(this.outSetValue.toFixed(0) + "%")
              .fontSize(60)
          }
        }.width(BIG_DIAMETER)
        .height(BIG_DIAMETER)

        Column({ space: 5 }) {
          Row() {
            Slider({
              value: this.outSetValue,
              min: 0,
              max: 100,
              step: 1,
              style: SliderStyle.OutSet
            })
              .blockColor('#FFFFFF')
              .trackColor('#182431')
              .selectedColor('#007DFF')
              .showSteps(true)
              .showTips(true)
              .onChange((value: number, mode: SliderChangeMode) => {
                this.outSetValue = value
                if (this.outSetValue == 100) {
                  this.backGroundColor = COLOR_BACKGROUND_FILL
                  this.pathCommands = '';
                } else {
                  this.backGroundColor = COLOR_TRANSPARENT
                  this.pathCommands = this.calPathCommands(this.outSetValue);
                }
                console.log(`value = ${value} ->` + this.pathCommands);
              })
            Text(this.outSetValue.toFixed(0)).fontSize(16)
          }
          .padding({ top: 50 })
          .width('80%')
        }
      }.width('100%')
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