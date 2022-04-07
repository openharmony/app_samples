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
struct NavigatorPage {
  @State temporary: string = ''
  @State value: string = '默认传参值'
  @State num1: number[] = [...Array(3).keys()]
  @State target: string = 'pages/component_container/navigator/navigatorDetail1'
  @State active: boolean = false
  @State NavigationTypeId: number = 0
  @State NavigationType: NavigationType[] = [NavigationType.Push, NavigationType.Replace, NavigationType.Back]
  @State NavigationTypeDescribe: string[] = ['Push', 'Replace', 'Back']

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Navigator({ target: this.target, type: this.NavigationType[this.NavigationTypeId] }) {
          Text('路由容器组件')
            .fontSize(15)
            .backgroundColor(0xFAEEE0)
        }.active(this.active)
        .params({
          message: this.value
        })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          GridItem() {
            Text('target：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(2).forceRebuild(true)

          GridItem() {
            Button('目标页面1')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.target = 'pages/component_container/navigator/navigatorDetail1'
              })
          }

          GridItem() {
            Button('目标页面2')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.target = 'pages/component_container/navigator/navigatorDetail2'
              })
          }

          GridItem() {
            Text('路由方式：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(2).forceRebuild(true)

          ForEach(this.num1, item => {
            GridItem() {
              Button(this.NavigationTypeDescribe[`${item}`])
                .fontSize(15)
                .width('100%')
                .onClick(() => {
                  this.NavigationTypeId = item
                })
            }
          }, item => item.toString())
          GridItem() {
            Text('active：')
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
                this.active = true
              })
          }

          GridItem() {
            Button('false')
              .fontSize(15)
              .width('100%')
              .onClick(() => {
                this.active = false
              })
          }
          GridItem() {
            Text('文本内容：')
              .fontSize(15)
              .height(40)
              .backgroundColor(0xFAEEE0)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
              .margin({ left: 5 })
          }.columnStart(0).columnEnd(2).forceRebuild(true)

          GridItem() {
            TextInput({ placeholder: '', text: this.temporary })
              .enterKeyType(EnterKeyType.Send)
              .placeholderFont({ size: 15 })
              .height(40)
              .border({ width: 3, radius: 20, color: '#88000000' })
              .onChange((value) => {
                this.temporary = value
              })
              .onSubmit(() => {
                this.value = this.temporary
                this.temporary = ''
              })
          }.columnStart(0).columnEnd(2).forceRebuild(true)

        }.columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate("")
        .columnsGap(5)
        .rowsGap(5)
      }
      .margin({top:10})
      .height('60%')
      .width('100%')
    }
    .width('100%').margin({ top: 5 })
  }
}