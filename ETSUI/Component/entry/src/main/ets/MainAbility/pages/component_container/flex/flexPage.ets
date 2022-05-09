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
struct FlexPage {
  @State num1: number[] = [...Array(3).keys()]
  @State num2: number[] = [...Array(4).keys()]
  @State num3: number[] = [...Array(6).keys()]
  @State directionId: number = 0
  @State direction: FlexDirection[] = [FlexDirection.Row,FlexDirection.RowReverse,FlexDirection.Column,FlexDirection.ColumnReverse]
  @State directionDescribe: string[] = ['Row','RowReverse','Column','ColumnReverse']
  @State flexWrapId: number = 1
  @State flexWrap: FlexWrap[] = [FlexWrap.NoWrap,FlexWrap.Wrap,FlexWrap.WrapReverse]
  @State flexWrapDescribe: string[] = ['NoWrap','Wrap','WrapReverse']
  @State justifyContentId: number = 0
  @State alignContentId: number = 0
  @State flexAlign: FlexAlign[] = [FlexAlign.Start,FlexAlign.Center,FlexAlign.End,FlexAlign.SpaceBetween,FlexAlign.SpaceAround,FlexAlign.SpaceEvenly]
  @State flexAlignDescribe: string[] = ['Start','Center','End','SpaceBetween','SpaceAround','SpaceEvenly']
  @State itemAlignId: number = 0
  @State itemAlign: ItemAlign[] = [ItemAlign.Auto,ItemAlign.Start,ItemAlign.Center,ItemAlign.End,ItemAlign.Stretch,ItemAlign.Baseline]
  @State itemAlignDescribe: string[] = ['Auto','Start','Center','End','Stretch','Baseline']
  @State isAlignItems: boolean = false
  @State isAlignContent: boolean = true

  build() {
    Column(){
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Flex({direction:this.direction[this.directionId],wrap:this.flexWrap[this.flexWrapId],justifyContent:this.flexAlign[this.justifyContentId],alignItems:this.itemAlign[this.itemAlignId],alignContent:this.flexAlign[this.alignContentId]}){
          Row(){}.width(50).height(50).backgroundColor(Color.Orange)
          Row(){}.width(50).height(50).backgroundColor(Color.Yellow)
          Row(){}.width(50).height(50).backgroundColor(Color.Green)
          Row(){}.width(50).height(50).backgroundColor(Color.Red)
          Row(){}.width(50).height(50).backgroundColor(Color.Pink)
          Row(){}.width(50).height(50).backgroundColor(Color.Gray)
          Row(){}.width(50).height(50).backgroundColor(Color.Blue)
          Row(){}.width(50).height(50).backgroundColor(Color.Brown)
        }.width('100%').height('100%')
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
        Grid() {
          GridItem() {
            Text('排列方向')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(5).forceRebuild(true)

          ForEach(this.num2, item => {
            GridItem() {
              Button(this.directionDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.directionId = item
                })
            }
          }, item => item.toString())


          GridItem() {
            Text('单行多行')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(5).forceRebuild(true)

          ForEach(this.num1, item => {
            GridItem() {
              Button(this.flexWrapDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.flexWrapId = item
                  if(item == 0){
                    this.isAlignItems = true
                    this.isAlignContent = false
                  }else{
                    this.isAlignItems = false
                    this.isAlignContent = true
                  }
                })
            }
          }, item => item.toString())

          GridItem() {
            Text('主轴对齐')
              .fontSize(15)
              .backgroundColor(0xFAEEE0)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Start)
              .margin({ left: 20 })
              .fontWeight(FontWeight.Bolder)
          }.columnStart(0).columnEnd(5).forceRebuild(true)

          ForEach(this.num3, item => {
            GridItem() {
              Button(this.flexAlignDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.justifyContentId = item
                })
            }
          }, item => item.toString())
          if(this.isAlignItems) {
            GridItem() {
              Text('交叉轴对齐')
                .fontSize(15)
                .backgroundColor(0xFAEEE0)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Start)
                .margin({ left: 20 })
                .fontWeight(FontWeight.Bolder)
            }.columnStart(0).columnEnd(5).forceRebuild(true)

            ForEach(this.num3, item => {
              GridItem() {
                Button(this.itemAlignDescribe[`${item}`])
                  .fontSize(15)
                  .width('100%')
                  .onClick(() => {
                    this.itemAlignId = item
                  })
              }
            }, item => item.toString())
          }

          if(this.isAlignContent) {
            GridItem() {
              Text('多行对齐')
                .fontSize(15)
                .backgroundColor(0xFAEEE0)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Start)
                .margin({ left: 20 })
                .fontWeight(FontWeight.Bolder)
            }.columnStart(0).columnEnd(5).forceRebuild(true)

            ForEach(this.num3, item => {
              GridItem() {
                Button(this.flexAlignDescribe[`${item}`])
                  .fontSize(15)
                  .width('100%')
                  .onClick(() => {
                    this.alignContentId = item
                  })
              }
            }, item => item.toString())
          }
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
        .rowsTemplate("")
        .columnsGap(5)
        .rowsGap(5)
        .scrollBar(BarState.Auto)
      }
      .height('60%')
      .width('100%')
      .margin({top:10})
    }
    .width('100%')
  }
}