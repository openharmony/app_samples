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
struct ListPage {
  @State num1: number[] = [...Array(4).keys()]
  @State num2: number[] = [...Array(3).keys()]
  @State listCount: number[] = [...Array(100).keys()].slice(1)
  @State space: number = 10
  @State initialIndex: number = 10
  @State num3: number[] = [...Array(2).keys()]
  @State listDirection: Axis = Axis.Vertical
  @State strokeWidth: number = 0
  @State startMargin: number = 0
  @State endMargin: number = 0
  @State colorId: number = 0
  @State color: Color[] = [Color.Green, Color.Orange, Color.Pink, Color.Yellow]
  @State colorDescribe: string[] = ['Green', 'Orange', 'Pink', 'Yellow']
  @State editMode: boolean = false
  @State edgeEffectId: number = 0
  @State edgeEffect: EdgeEffect[] = [EdgeEffect.Spring, EdgeEffect.None, EdgeEffect.Fade]
  @State edgeEffectDescribe: string[] = ['Spring', 'None', 'Fade']
  @State chainAnimation: boolean = false
  @State sticky: Sticky = Sticky.None
  @State editable: boolean = false

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        List({ space: this.space, initialIndex: this.initialIndex }) {
          ListItem() {
            Text('吸顶')
          }
          .sticky(this.sticky)
          .height(50)
          .width('100%')
          .border({ radius: 15 })
          .backgroundColor(Color.Green)
          .editable(this.editable)

          ForEach(this.listCount, (item) => {
            ListItem() {
              Text(`${item}`)
                .fontSize(15)
                .height(40)
                .textAlign(TextAlign.Start)
                .width('100%')
                .margin({ left: 10 })
            }
            .height(50)
            .width('100%')
            .border({ radius: 15 })
            .backgroundColor(Color.Orange)
            .editable(this.editable)
          }, item => item.toString())
        }
        .listDirection(this.listDirection)
        .divider({
          strokeWidth: this.strokeWidth,
          color: this.color[this.colorId],
          startMargin: this.startMargin,
          endMargin: this.endMargin
        })
        .editMode(this.editMode)
        .edgeEffect(this.edgeEffect[this.edgeEffectId])
        .chainAnimation(this.chainAnimation)
        .onItemDelete((index: number) => {
          console.log('www data delete: ' + 123)
          return true
        })
        .onScrollIndex((e) => {
          console.info("on Scroll index " + String(e))
        })
        .onScroll((scrollOffset: number, scrollState: ScrollState) => {
          console.info('状态：' + String(scrollState))
        })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          GridItem() {
            Text(`space：${this.space}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Slider({ value: this.space, step: 5, min: -10, max: 100 })
              .blockColor(Color.Orange)
              .width("100%")
              .onChange((e) => {
                this.space = Math.round(e)
              })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Text('排列方向：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Button("Vertical")
              .fontSize(15)
              .height(40)
              .width('100%')
              .onClick(() => {
                this.listDirection = Axis.Vertical
              })
          }

          GridItem() {
            Button("Horizontal")
              .fontSize(15)
              .height(40)
              .width('100%')
              .onClick(() => {
                this.listDirection = Axis.Horizontal
              })
          }

          GridItem() {
            Text(`strokeWidth：${this.strokeWidth}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Slider({ value: this.space, step: 5, min: -10, max: 100 })
              .width("100%")
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.strokeWidth = Math.round(e)
              })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Text(`startMargin：${this.startMargin}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Slider({ value: this.space, step: 5, min: -10, max: 100 })
              .width("100%")
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.startMargin = Math.round(e)
              })
          }.columnStart(0).columnEnd(3).forceRebuild(true)


          GridItem() {
            Text(`endMargin：${this.endMargin}`)
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Slider({ value: this.space, step: 5, min: -10, max: 100 })
              .width("100%")
              .blockColor(Color.Orange)
              .onChange((e) => {
                this.endMargin = Math.round(e)
              })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Text('分割线颜色：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          ForEach(this.num1, item => {
            GridItem() {
              Button(this.colorDescribe[`${item}`])
                .width('100%')
                .fontSize(15)
                .height(40)
                .onClick(() => {
                  this.colorId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('editMode：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Button('true')
              .width('100%')
              .fontSize(15)
              .onClick(() => {
                this.editMode = true
              })
          }

          GridItem() {
            Button('false')
              .width('100%')
              .fontSize(15)
              .onClick(() => {
                this.editMode = false
              })
          }

          GridItem() {
            Text('链式动效：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Button('true')
              .width('100%')
              .fontSize(15)
              .onClick(() => {
                this.chainAnimation = true
              })
          }

          GridItem() {
            Button('false')
              .width('100%')
              .fontSize(15)
              .onClick(() => {
                this.chainAnimation = false
              })
          }

          GridItem() {
            Text('edgeEffect：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          ForEach(this.num2, item => {
            GridItem() {
              Button(this.edgeEffectDescribe[`${item}`])
                .width('100%')
                .fontSize(15)
                .onClick(() => {
                  this.edgeEffectId = item
                })
            }
          }, item => item.toString())


          GridItem() {
            Text('吸顶效果：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Button("None")
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.sticky = Sticky.None
              })
          }

          GridItem() {
            Button("Normal")
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.sticky = Sticky.Normal
              })
          }

          GridItem() {
            Text('editable：')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .height(40)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(3).forceRebuild(true)

          GridItem() {
            Button("true")
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.editable = true
              })
          }

          GridItem() {
            Button("false")
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.editable = false
              })
          }

          GridItem() {
            Button('删除')
              .fontSize(15)
              .width("100%")
              .onClick(() => {
                this.listCount.splice(0, 1)
              })
          }.columnStart(0).columnEnd(3).forceRebuild(true)
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsTemplate("")
        .columnsGap(5)
        .rowsGap(5)
        .scrollBar(BarState.Auto)
        .margin({bottom:10})
      }.height('60%')
      .width('100%')
      .margin({top:10})
    }
    .width('100%').margin({ top: 5 })
  }
}