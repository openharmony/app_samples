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
struct ToggleSample {
  @State toggleType: ToggleType = ToggleType.Switch;
  @State toggleString: string = "Switch";
  @State isOn: boolean = false;
  @State selectedColor: Color = Color.Orange;
  @State switchPointColor: Color = Color.Yellow;
  @State setProgressColor: Color = Color.Black;

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: 'Toggle' })
      Scroll() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          if (this.toggleType === ToggleType.Switch) {
            Toggle({ type: this.toggleType, isOn: this.isOn })
              .size({ width: 90, height: 35 })
              .selectedColor(this.selectedColor)
              .switchPointColor(this.switchPointColor)
              .onChange((isOn: boolean) => {
                console.info('Component status:' + isOn)
              })
          } else if (this.toggleType === ToggleType.Checkbox) {
            Toggle({ type: this.toggleType, isOn: this.isOn })
              .selectedColor(this.selectedColor)
              .size({ width: 50, height: 45 })
              .onChange((isOn: boolean) => {
                console.info('Component status:' + isOn)
              })
          } else {
            Toggle({ type: this.toggleType, isOn: this.isOn }) {
              Text('status button').padding({ left: 12, right: 12 }).size({ width: 80, height: 35 })
            }
            .width(100)
            .height(35)
            .selectedColor('#007DFF')
            .onChange((isOn: boolean) => {
              console.info('Component status:' + isOn)
            })
          }
        }
        .width('100%')
        .height('100%')
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('toggleType')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(`${this.toggleString}`)
                .bindMenu([
                  {
                    value: 'Switch',
                    action: () => {
                      this.toggleType = ToggleType.Switch
                      this.toggleString = "Switch"
                    }
                  },
                  {
                    value: 'Checkbox',
                    action: () => {
                      this.toggleType = ToggleType.Checkbox
                      this.toggleString = "Checkbox"
                    }
                  },
                  {
                    value: 'Button',
                    action: () => {
                      this.toggleType = ToggleType.Button
                      this.toggleString = "Button"
                    }
                  },
                ])
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .width('50%')
                .textAlign(TextAlign.End)
            }

          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('isOn')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Toggle({ type: ToggleType.Switch, isOn: this.isOn })
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                console.info('Component status:' + isOn)
                this.isOn = !this.isOn
              })
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('selectedColor')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              GetColor({ colorVal: $selectedColor })
            }.width(48)
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('switchPointColor')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              GetColor({ colorVal: $switchPointColor })
            }.width(48)

          }
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
        .width('100%')
      }
      .height('55%')
      .margin({ top: 24 })
    }
    .padding({ left: '3%', right: '3%', bottom: 10 })
    .backgroundColor('#F1F3F5 ')
    .height('100%')
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