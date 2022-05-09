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
struct TabsPage {
  controller: TabsController = new TabsController()
  @State barPosition: BarPosition = BarPosition.End
  @State changeIndex: number = 1
  @State vertical: boolean = false
  @State scrollable: boolean = true
  @State barMode: BarMode = BarMode.Scrollable
  @State barWidth: number = 350
  @State barHeight: number = 50
  @State animationDuration: number = 200

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Tabs({ barPosition: this.barPosition, index: 0, controller: this.controller }) {
          TabContent() {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text('One')
                .fontSize(25)
            }.height('100%')
          }.tabBar('One')

          TabContent() {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text('Two')
                .fontSize(25)
            }.height('100%')
          }.tabBar({

            text: 'Two'
          })

          TabContent() {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text('Three')
                .fontSize(25)
            }.height('100%')
          }.tabBar('Three')

          TabContent() {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text('Four')
                .fontSize(25)
            }.height('100%')
          }.tabBar({

            text: "Four"
          })

          TabContent() {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text('Five')
                .fontSize(25)
            }.height('100%')
          }.tabBar('Five')

          TabContent() {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text('Six')
                .fontSize(25)
            }.height('100%')
          }.tabBar('Six')
        }
        .vertical(this.vertical)
        .scrollable(this.scrollable)
        .barMode(this.barMode)
        .barWidth(this.barWidth)
        .barHeight(this.barHeight)
        .animationDuration(this.animationDuration)
        .onChange((index: number) => {
          console.info('页签变化：' + (index+1))
        })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          GridItem() {
            Text('页签位置')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Button("Start")
              .fontSize(15)
              .width('80%')
              .onClick(() => {
                this.barPosition = BarPosition.Start
              })
          }

          GridItem() {
            Button("End")
              .fontSize(15)
              .width('80%')
              .onClick(() => {
                this.barPosition = BarPosition.End
              })
          }

          GridItem() {
            Text(`控制器：${this.changeIndex}`)
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Slider({ value: this.changeIndex, step: 1, min: 1, max: 6 })
              .blockColor(Color.Orange)
              .width('100%')
              .showSteps(true)
              .onChange((e) => {
                this.changeIndex = Math.round(e)
                this.controller.changeIndex(this.changeIndex-1)
              })
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Text('切换方向')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }

          GridItem() {
            Button(`${this.vertical}`)
              .fontSize(15)
              .width('80%')
              .onClick(() => {
                this.vertical = !this.vertical
              })
          }

          GridItem() {
            Text('scrollable')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }

          GridItem() {
            Button(`${this.vertical}`)
              .fontSize(15)
              .width('80%')
              .onClick(() => {
                this.scrollable = !this.scrollable
              })
          }

          GridItem() {
            Text('布局模式')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Button('Scrollable')
              .fontSize(15)
              .width('80%')
              .onClick(() => {
                this.barMode = BarMode.Scrollable
              })
          }

          GridItem() {
            Button('Fixed')
              .fontSize(15)
              .width('80%')
              .onClick(() => {
                this.barMode = BarMode.Fixed
              })
          }

          GridItem() {
            Text(`TabBar宽：${this.barWidth}`)
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Slider({ value: this.changeIndex, step: 1, min: -10, max: 50 })
              .blockColor(Color.Orange)
              .width('100%')
              .showSteps(true)
              .onChange((e) => {
                this.barWidth = Math.round(e)
              })
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Text(`TabBar高：${this.barWidth}`)
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Slider({ value: this.changeIndex, step: 1, min: -10, max: 50 })
              .blockColor(Color.Orange)
              .width('100%')
              .showSteps(true)
              .onChange((e) => {
                this.barHeight = Math.round(e)
              })
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Text(`滑动时长：${this.barWidth}`)
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(1).forceRebuild(true)

          GridItem() {
            Slider({ value: this.changeIndex, step: 1, min: -10, max: 50 })
              .blockColor(Color.Orange)
              .width('100%')
              .showSteps(true)
              .onChange((e) => {
                this.animationDuration = Math.round(e)
              })
          }.columnStart(0).columnEnd(1).forceRebuild(true)
        }
        .columnsTemplate('1fr 1fr')

        .columnsGap(5)
        .rowsGap(5)
        .scrollBar(BarState.Auto)
      }.height('60%')
      .width('100%')
    }
    .width('100%').margin({ top: 5 })
  }
}