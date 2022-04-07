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
struct PanelPage {
  @State num: number[] = [...Array(3).keys()]
  @State showPanel: boolean = true
  @State typeId: number = 0
  @State type: PanelType[] = [PanelType.Minibar, PanelType.Foldable, PanelType.Temporary]
  @State typeDescribe: string[] = ['Minibar', 'Foldable', 'Temporary']
  @State modeId: number = 0
  @State mode: PanelMode[] = [PanelMode.Mini, PanelMode.Half, PanelMode.Full]
  @State modeDescribe: string[] = ['Mini', 'Half', 'Full']
  @State dragBar: boolean = true
  @State fullHeight: number = 300
  @State halfHeight: number = 150
  @State miniHeight: number = 50

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Panel(this.showPanel) {
          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Text('Panel组件')
              .fontSize(20)
          }
        }
        .type(this.type[this.typeId])
        .mode(this.mode[this.modeId])
        .dragBar(this.dragBar)
        .fullHeight(this.fullHeight)
        .halfHeight(this.halfHeight)
        .miniHeight(this.miniHeight)
        .onChange((event:any) => {
          console.info('width：'+event.width  + ',height：' + event.height + ',mode：' + event.mode)
        })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          GridItem() {
            Text('是否显示：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(2).forceRebuild(true)

          GridItem() {
            Button('true')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.showPanel = true
              })
          }

          GridItem() {
            Button('false')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.showPanel = false
              })
          }

          GridItem() {
            Text('可滑动面板类型：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(2).forceRebuild(true)

          ForEach(this.num, item => {
            GridItem() {
              Button(this.typeDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.typeId = item
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('可滑动面板初始状态：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(2).forceRebuild(true)

          ForEach(this.num, item => {
            GridItem() {
              Button(this.modeDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.modeId = item
                })
            }
          }, item => item.toString())
          GridItem() {
            Text('dragBar：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(2).forceRebuild(true)

          GridItem() {
            Button('true')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.dragBar = true
              })
          }

          GridItem() {
            Button('false')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.dragBar = false
              })
          }

        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate("")
        .columnsGap(5)
        .rowsGap(5)
        .scrollBar(BarState.Auto)
      }
      .margin({top:20})
      .height('60%')
      .width('100%')
    }
    .width('100%').margin({ top: 5 })
  }
}