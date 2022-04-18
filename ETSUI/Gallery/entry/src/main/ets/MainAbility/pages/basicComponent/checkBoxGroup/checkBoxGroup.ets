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
struct CheckboxExample {
  @State setBoxColor: Color = Color.Green;
  @State setBackgroundColor: string = '#F1F3F5';

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {

      NavigationBar({ title: 'CheckboxGroup' })

      Scroll() {
        Column() {
          Column() {
            CheckboxGroup({ group: 'checkboxGroup' })
              .selectedColor(0xed6f21)
              .onChange((itemName: CheckboxGroupResult) => {
                console.info("TextPicker::dialogResult is" + JSON.stringify(itemName))
              })
            Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
              .select(false)
              .selectedColor(this.setBoxColor)
              .onChange((value: boolean) => {
                console.info('Checkbox1 change is' + value)
              })
            Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
              .select(false)
              .selectedColor(this.setBoxColor)
              .onChange((value: boolean) => {
                console.info('Checkbox2 change is' + value)
              })
            Checkbox({ name: 'checkbox3', group: 'checkboxGroup' })
              .select(false)
              .selectedColor(this.setBoxColor)
              .onChange((value: boolean) => {
                console.info('Checkbox3 change is' + value)
              })
          }
          .backgroundColor(this.setBackgroundColor)

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('boxColor')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              GetColor({ colorVal: $setBoxColor })
            }.width(48)
          }
          .width('100%')
          .height(35)
          .padding({ left: 12, right: 12 })
          .borderRadius(14)
          .backgroundColor('#FFF')
          .margin({ top: 8, bottom: 8, left: 12, right: 12 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('backgroundColor')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              GetColor({ colorVal: $setBackgroundColor })
            }.width(48)
          }
          .width('100%')
          .height(35)
          .padding({ left: 12, right: 12 })
          .borderRadius(14)
          .backgroundColor('#FFF')
          .margin({ top: 8, bottom: 8, left: 12, right: 12 })

        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: '2%', right: '2%' })
    }
    .backgroundColor('#F1F3F5')
  }
}