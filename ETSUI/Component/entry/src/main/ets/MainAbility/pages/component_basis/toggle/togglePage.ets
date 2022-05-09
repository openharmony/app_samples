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

import prompt from '@ohos.prompt';

@Entry
@Component
struct TogglePage {
  @State num1: number[] = [...Array(3).keys()]
  @State num2: number[] = [...Array(4).keys()]
  @State toggleId: number = 0
  @State toggleType: ToggleType[] = [ToggleType.Checkbox, ToggleType.Button, ToggleType.Switch]
  @State toggleTypeDescribe: string[] = ['Checkbox', 'Checkbox', 'Switch']
  @State colorId: number = 0
  @State color: Color[] = [Color.Green, Color.Orange, Color.Pink, Color.Yellow]
  @State colorDescribe: string[] = ['Green', 'Orange', 'Pink', 'Yellow']
  @State isOn: boolean = true

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Toggle({ type: this.toggleType[this.toggleId], isOn: this.isOn })
          .selectedColor(this.color[this.colorId])
          .width(150)
          .height(100)
          .onChange(() => {
            prompt.showToast({ message: '开关切换', duration: 2000 })
          })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
        Column() {
          Text('初始状态：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('100%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Button('true')
              .margin({ right: 10 })
              .fontSize(15)
              .width(110)
              .onClick(() => {
                this.isOn = true
              })
            Button('false')
              .fontSize(15)
              .width(110)
              .onClick(() => {
                this.isOn = false
              })
          }
          .width('90%')
          .margin({ top: 5, bottom: 5, left: 10, right: 10 })
        }
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text('组件类型：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('100%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            ForEach(this.num1, item => {
              Button(this.toggleTypeDescribe[`${item}`])
                .margin({ right: 10 })
                .fontSize(15)
                .width(110)
                .onClick(() => {
                  this.toggleId = item
                })
            }, item => item.toString())
          }
          .width('90%')
          .margin({ top: 5, bottom: 5, left: 10, right: 10 })
        }
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text('选中颜色：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('100%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            ForEach(this.num2, item => {
              Button(this.colorDescribe[`${item}`])
                .margin({ right: 10 })
                .fontSize(15)
                .width(110)
                .onClick(() => {
                  this.colorId = item
                })
            }, item => item.toString())
          }
          .width('90%')
          .margin({ top: 5, bottom: 5, left: 10, right: 10 })
        }
        .alignItems(HorizontalAlign.Start)
      }
      .margin({ top: 20 })
    }.width('100%')
  }
}