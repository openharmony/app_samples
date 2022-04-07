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

@Entry
@Component
struct DividerPage {
  @State vertical: boolean = false
  @State color: Color = Color.Red
  @State strokeWidth: number = 5
  @State lineCap: LineCapStyle = LineCapStyle.Butt
  @State lineCaps: LineCapStyle[] = [LineCapStyle.Butt, LineCapStyle.Round, LineCapStyle.Square]

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Divider()
          .vertical(this.vertical)
          .color(this.color)
          .strokeWidth(`${this.strokeWidth}`)
          .lineCap(this.lineCap)
          .width(300)
          .height(300)
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
        Text(`divider组件的宽度：${this.strokeWidth}`)
          .fontSize(15)
          .backgroundColor(0xFAEEE0)
          .width('100%')
          .height(40)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bolder)
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
          Slider({ value: this.strokeWidth, step: 1, min: -10, max: 100 })
            .blockColor(Color.Orange)
            .onChange((e) => {
              this.strokeWidth = Math.round(e)
            })
        }
        .width('100%')
        .margin({ top: 5, bottom: 5, left: 10, right: 10 })

        Column() {
          Text('分割线方向：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('100%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Button('vertical')
              .margin({ right: 10 })
              .fontSize(15)
              .width(110)
              .onClick(() => {
                this.vertical = true
              })
            Button('horizontal')
              .width(110)
              .fontSize(15)
              .onClick(() => {
                this.vertical = false
              })
          }
          .width('90%')
          .margin({ top: 5, bottom: 5, left: 10, right: 10 })
        }
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text('端点样式：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('100%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Button('Butt')
              .margin({ right: 10 })
              .width(110)
              .fontSize(15)

              .onClick(() => {
                this.lineCap = LineCapStyle.Butt
              })
            Button('Round')
              .margin({ right: 10 })
              .width(110)
              .fontSize(15)

              .onClick(() => {
                this.lineCap = LineCapStyle.Round
              })
            Button('Square')
              .margin({ right: 10 })
              .width(110)
              .fontSize(15)

              .onClick(() => {
                this.lineCap = LineCapStyle.Square
              })
          }
          .width('90%')
          .margin({ top: 5, bottom: 5, left: 10, right: 10 })
        }
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text('分割线颜色：')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
            .width('100%')
            .height(40)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bolder)
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Button('红色')
              .margin({ right: 10 })
              .width(110)
              .fontSize(15)

              .onClick(() => {
                this.color = Color.Red
              })
            Button('黄色')
              .margin({ right: 10 })
              .width(110)
              .fontSize(15)

              .onClick(() => {
                this.color = Color.Yellow
              })
            Button('绿色')
              .margin({ right: 10 })
              .width(110)
              .fontSize(15)

              .onClick(() => {
                this.color = Color.Green
              })
          }
          .width('90%')
          .margin({ top: 5, bottom: 5, left: 10, right: 10 })
        }
        .alignItems(HorizontalAlign.Start)
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 20 })
    }
    .width('100%')
  }
}