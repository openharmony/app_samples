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
struct RowPage {
  @State num1: number[] = [...Array(3).keys()]
  @State num3: number[] = [...Array(3).keys()]
  @State alignItemsId: number = 0
  @State alignItems: VerticalAlign[] = [VerticalAlign.Top, VerticalAlign.Center, VerticalAlign.Bottom]
  @State alignItemsDescribe: string[] = ['Top', 'Center', 'Bottom']
  @State flexItemsId: number = 0
  @State flexItems: FlexAlign[] = [FlexAlign.Center, FlexAlign.Start, FlexAlign.End]
  @State flexItemsDescribe: string[] = ['Center', 'Start', 'End']
  @State space: number = 0
  @State useAlign: string = 'Top'
  @State flexAlign: string = 'Top'

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {

          Row({ space: this.space }) {
            Row() {
            }.width(50).height(50).backgroundColor(Color.Orange)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Yellow)

            Row() {
            }.width(50).height(40).backgroundColor(Color.Green)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Red)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Pink)
          }
          .width(300)
          .height(300)
          .border({ width: 1 })
          .alignItems(this.alignItems[this.alignItemsId])

          Row({ space: this.space }) {
            Row() {
            }.width(50).height(50).backgroundColor(Color.Orange)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Yellow)

            Row() {
            }.width(50).height(40).backgroundColor(Color.Green)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Red)

            Row() {
            }.width(50).height(50).backgroundColor(Color.Pink)
          }
          .width(300)
          .height(300)
          .border({ width: 1 })
          .justifyContent(this.flexItems[this.flexItemsId])
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          GridItem() {
            Text('对齐方式：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(2).forceRebuild(true)

          ForEach(this.num1, item => {
            GridItem() {
              Button(this.alignItemsDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.alignItemsId = item
                })
            }
          }, item => item.toString())
          GridItem() {
            Text('space：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(2).forceRebuild(true)

          GridItem() {
            Slider({ value: this.space, step: 1, min: -10, max: 50 })
              .blockColor(Color.Orange)
              .width("100%")
              .onChange((e) => {
                this.space = Math.round(e)
              })
          }.columnStart(0).columnEnd(2).forceRebuild(true)

          GridItem() {
            Text('自定义横向对齐方式：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(2).forceRebuild(true)

          ForEach(this.num1, item => {
            GridItem() {
              Button(this.flexItemsDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.flexItemsId = item
                })
            }
          }, item => item.toString())
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate("")
        .columnsGap(5)
        .rowsGap(5)
        .scrollBar(BarState.Auto)
        .margin({bottom:10})
      }
      .height('60%')
      .width('100%')
      .margin({top:10})
    }
    .width('100%').margin({ top: 5,bottom:10 })
  }
}