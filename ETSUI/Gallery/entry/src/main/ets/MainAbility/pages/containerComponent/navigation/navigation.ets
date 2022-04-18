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
import { NavigationBar } from "../../../common/components/navigationBar"

@Entry
@Component
struct NavigationSample {
  private list: number[] = [0, 1, 2, 3]
  @State hideToolBar: boolean = false
  @State hideTitleBar: boolean = false
  @State hideBackButton: boolean = false
  @State titleMode: number = 1

  @Builder NavigationTitle() {
    Column() {
      Text('title')
        .width(80)
        .height(48)
        .fontColor(Color.Blue)
        .fontSize(30)
    }
    .onClick(() => {
      console.log("title")
    })
  }

  @Builder NavigationMenus() {
    Row() {
      Image('images/add.png')
        .width(25)
        .height(25)
      Image('comment/more.png')
        .width(25)
        .height(25)
        .margin({ left: 30 })
    }.width(100)
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      NavigationBar({ title: 'Navigation' })
      Navigation() {
        List({ space: 12, initialIndex: 0 }) {
          ForEach(this.list, (item) => {
            ListItem() {
              Text('' + item)
                .height(80)
                .borderRadius(15)
                .fontSize(16)
                .textAlign(TextAlign.Center)
            }
            .editable(true)
            .width('93.3%')
            .borderRadius(24)
            .padding({ left: '3.6%', right: '5.4%', top: 12, bottom: 12 })
            .backgroundColor('#ffffff')
          }, item => item)
        }
        .margin({ top: 20 })
        .listDirection(Axis.Vertical)
        .height(300)
        .margin({ top: 10, left: 18 })
        .width('100%')
        .height('100%')
      }
      .title(this.NavigationTitle)
      .subTitle('subtitle')
      .menus(this.NavigationMenus)
      .titleMode(this.titleMode == 1 ? NavigationTitleMode.Mini : this.titleMode == 2 ? NavigationTitleMode.Free : NavigationTitleMode.Full)
      .hideTitleBar(this.hideTitleBar)
      .hideBackButton(this.hideBackButton)
      .height('50%')
      .onTitleModeChange((titleModel: NavigationTitleMode) => {
        console.log('titleMode')
      })
      .toolBar({ items: [
        { value: 'app', icon: 'images/grid.svg', action: () => {
          console.log("app")
        } },
        { value: 'add', icon: 'images/add.svg', action: () => {
          console.log("add")
        } },
        { value: 'collect', icon: 'images/collect.svg', action: () => {
          console.log("collect")
        } }] })
      .hideToolBar(this.hideToolBar)

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('hideTitleBar')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Toggle({ type: ToggleType.Switch, isOn: this.hideTitleBar })
              .selectedColor('#007DFF ')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                this.hideTitleBar = !this.hideTitleBar
              })
              .margin(0)
              .padding(0)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('hideToolBar')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Toggle({ type: ToggleType.Switch, isOn: this.hideToolBar })
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                this.hideToolBar = !this.hideToolBar
              })
              .margin(0)
              .padding(0)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('hideBackButton')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Toggle({ type: ToggleType.Switch, isOn: this.hideBackButton })
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                this.hideBackButton = !this.hideBackButton
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('titleMode')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)
            Text(this.titleMode == 1 ? 'Mini' : this.titleMode == 2 ? 'Free' : 'Full').fontSize(16).lineHeight(28)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .bindMenu([
            {
              value: 'Mini',
              action: () => {
                this.titleMode = 1
              }
            },
            {
              value: 'Free',
              action: () => {
                this.titleMode = 2
              }
            },
            {
              value: 'Full',
              action: () => {
                this.titleMode = 3
              }
            }
          ])
        }
      }.height('60%')
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 10 })
  }

  pageTransition() {
    PageTransitionEnter({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)

    PageTransitionExit({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)
  }
}