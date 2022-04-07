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
struct ProgressPage {
  @State currentValue: number = 30
  @State total: number = 100
  @State num1: number[] = [...Array(4).keys()]
  @State progressStyleId: number = 0
  @State progressStyle: ProgressStyle[] = [ProgressStyle.Linear, ProgressStyle.Eclipse]
  @State progressStyleDescribe: string[] = ['Linear', 'Eclipse', 'Circular', 'Capsule']
  @State colorId: number = 0
  @State color: Color[] = [Color.Green, Color.Orange, Color.Pink, Color.Yellow]
  @State colorDescribe: string[] = ['Green', 'Orange', 'Pink', 'Yellow']
  @State strokeWidth: number = 30
  @State scaleCount: number = 30
  @State scaleWidth: number = 30
  @State isCircular: boolean = false
  @State isStrokeWidth: boolean = true

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Progress({ value: this.currentValue, total: this.total, style: this.progressStyle[this.progressStyleId] })
          .color(this.color[this.colorId])
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Scroll() {
        Column() {
          Column() {
            Text('进度条类型：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              ForEach(this.num1, item => {
                Button(this.progressStyleDescribe[`${item}`])
                  .margin({ right: 10 })
                  .fontSize(15)
                  .width(90)
                  .onClick(() => {
                    this.progressStyleId = item
                    if (item != 2) {
                      this.isCircular = false
                    } else {
                      this.isCircular = true
                    }
                    if (item != 1) {
                      this.isStrokeWidth = true
                    } else {
                      this.isStrokeWidth = false
                    }
                  })
              }, item => item.toString())
            }
            .width('100%')
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
              ForEach(this.num1, item => {
                Button(this.colorDescribe[`${item}`])
                  .margin({ right: 10 })
                  .fontSize(15)
                  .width(90)
                  .onClick(() => {
                    this.colorId = item
                  })
              }, item => item.toString())
            }
            .width('100%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }
          .alignItems(HorizontalAlign.Start)

          Row() {
            Text(`当前进度：${this.currentValue}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Slider({ value: this.currentValue, step: 1, min: -1, max: 110 })
                .blockColor(Color.Orange)
                .onChange((e) => {
                  this.currentValue = Math.round(e)
                })
            }
            .width('60%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }

          Row() {
            Text(`进度总长：${this.total}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bolder)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
              Slider({ value: this.total, step: 1, min: -1, max: 110 })
                .blockColor(Color.Orange)
                .onChange((e) => {
                  this.total = Math.round(e)
                })
            }
            .width('60%')
            .margin({ top: 5, bottom: 5, left: 10, right: 10 })
          }

          if (this.isCircular || this.isStrokeWidth) {
            Row() {
              Text(`进度条宽度：${this.strokeWidth}`)
                .fontSize(15)
                .backgroundColor(0xFAEEE0)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Bolder)
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
                Slider({ value: this.strokeWidth, step: 1, min: -1, max: 110 })
                  .blockColor(Color.Orange)
                  .onChange((e) => {
                    this.strokeWidth = Math.round(e)
                  })
              }
              .width('100%')
              .margin({ top: 5, bottom: 5, left: 10, right: 10 })
            }
          }
          if (this.isCircular) {
            Row() {
              Text(`刻度数量：${this.scaleCount}`)
                .fontSize(12)
                .backgroundColor(0xFAEEE0)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Bolder)
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
                Slider({ value: this.scaleCount, step: 1, min: -1, max: 110 })
                  .blockColor(Color.Orange)
                  .onChange((e) => {
                    this.scaleCount = Math.round(e)
                  })
              }
              .width('60%')
              .margin({ top: 5, bottom: 5, left: 10, right: 10 })
            }

            Row() {
              Text(`刻度粗细：${this.scaleWidth}`)
                .fontSize(12)
                .backgroundColor(0xFAEEE0)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Bolder)
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
                Slider({ value: this.scaleWidth, step: 1, min: -1, max: 110 })
                  .blockColor(Color.Orange)
                  .onChange((e) => {
                    this.scaleWidth = Math.round(e)
                  })
              }
              .width('100%')
              .margin({ top: 5, bottom: 5, left: 10, right: 10 })
            }
          }
        }.alignItems(HorizontalAlign.Start)
        .margin({ top: 20 })
      }.height("60%")
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray)
      .scrollBarWidth(10)
    }
    .width('100%')
  }
}