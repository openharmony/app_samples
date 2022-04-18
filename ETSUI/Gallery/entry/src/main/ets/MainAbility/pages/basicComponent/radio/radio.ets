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
struct ProgressSample {
  @State setProgressChecked: boolean = false;
  @State setBackgroundColor: string = '#F1F3F5';

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {

      NavigationBar({ title: 'Radio' })

      Scroll() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Text('radio')
            .fontSize(24)
            .margin(10)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 20 })
          Radio({ value: 'Radio', group: 'radioGroup' }).checked(this.setProgressChecked)
            .height(50)
            .width(50)
            .onChange((value: boolean) => {
              console.log('Radio1 status is ' + value)
            })
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('40%')
      .backgroundColor(this.setBackgroundColor)
      //属性属性值
      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('progressChecked')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Toggle({ type: ToggleType.Switch, isOn: this.setProgressChecked })
              .width(35)
              .height(20)
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange(() => {
                  this.setProgressChecked ? this.setProgressChecked = false : this.setProgressChecked = true
              })
          }
          .width('100%')
          .height(35)
          .padding({ left: 12, right: 12 })
          .borderRadius(14)
          .backgroundColor('#FFF')
          .margin({ top: 8, bottom: 8,left:12,right:12 })

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

        }.width('100%')
      }.margin({ top: 20 })
      .width('100%')
      .height('60%')
    }
    .width('100%')
    .height('100%')
    .padding({ left: '2%', right: '2%' })
    .backgroundColor('#F1F3F5')
  }
}