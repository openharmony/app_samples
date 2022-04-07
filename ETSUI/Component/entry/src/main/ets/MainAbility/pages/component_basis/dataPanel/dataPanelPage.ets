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

import prompt from '@system.prompt';

@Entry
@Component
struct DataPanelPage {
  @State temporary: string = ''
  @State values: number[] = [10, 20, 40, 30]
  @State max: number = 100
  @State closeEffect: boolean = false

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Column() {
          DataPanel({ values: this.values, max: this.max })
            .closeEffect(this.closeEffect)
        }.height('80%')

        Column() {
          Text(`数据值：${this.values}`)
            .fontSize(15)
            .margin({ top: 20 })
        }.alignItems(HorizontalAlign.Center)
        .width('100%')
        .margin({ left: 20 })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
        Column() {
          Text('追加选择数据：')
            .fontSize(15)
            .width('100%')
            .backgroundColor(0xFAEEE0)
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Button('清空')
              .margin({right:10})
              .fontSize(15)
              .width(80)
              .onClick(() => {
                this.values = []
              })
            TextInput({ placeholder: '', text: this.temporary })
              .type(InputType.Number)
              .enterKeyType(EnterKeyType.Send)
              .placeholderFont({ size: 15 })
              .height(40)
              .border({ width: 3, radius: 20, color: '#88000000' })
              .onChange((value) => {
                this.temporary = value
              })
              .onSubmit(() => {
                let len = this.values.length
                if (len < 9) {
                  this.values.push(Number(this.temporary))
                } else {
                  prompt.showToast({
                    message: '最大9个数据'
                  })
                }
                this.temporary = ''
              })
          }
          .width('90%')
          .margin({ top: 5, bottom: 5 ,left:10,right:10})
        }
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text(`数据最大值：${this.max}`)
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('100%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Slider({ value: this.max, step: 1, min: -1, max: 115 })
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.max = Math.round(e)
              })
          }
          .width('100%')
          .margin({ top: 5, bottom: 5 })
        }
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text('是否关闭占比图特效：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('100%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Button('true')
              .width(80)
              .margin({right:2})
              .fontSize(15)
              .onClick(() => {
                this.closeEffect = true
              })
            Button('false')
              .width(80)
              .fontSize(15)
              .onClick(() => {
                this.closeEffect = false
              })
          }
          .width('100%')
          .margin({ top: 5, bottom: 5 ,left:10})
        }
        .alignItems(HorizontalAlign.Start)
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 20 })
    }
    .width('100%').margin({ top: 5 })
  }
}