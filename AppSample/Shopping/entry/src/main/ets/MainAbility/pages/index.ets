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

import mediaQuery from '@ohos.mediaquery';
import display from '@ohos.display';
import { TabTitleModel } from '../model/homeModel'
import { tabTitleData } from '../data/homeData'
import { MainPage } from './homePage/main'
import { VisitPage } from './homePage/visitPage'
import { Information } from './homePage/informance'
import { ShopCart } from './homePage/shopCart'
import { User } from './homePage/User'

let portraitIndex = null

@Entry
@Component
struct Index {
  @State device: string = ''
  @State tabsIndex: number = 0
  @State tabTittleData: Array<TabTitleModel> = tabTitleData
  @State idx: number = 0
  controller: TabsController = new TabsController()
  @State opacity: number = 1
  @State width: number = 100
  @State ratio: number = 1
  listener = mediaQuery.matchMediaSync('(orientation:landscape)')

  aboutToAppear() {
    display.getAllDisplay((err, data) => {
      let aspect = data[0].width / data[0].height
      if (aspect == 0.5625) {
        this.ratio = 1.4
      }
    })
    portraitIndex = this.onPortrait.bind(this)
    this.listener.on('change', portraitIndex)
  }

  async onPortrait(mediaQueryResult) {
    let result = mediaQueryResult.matches
    if (result) {
      this.width = 45
    } else {
      this.width = 100
    }
  }

  build() {
    Column() {
      Column() {
        Tabs({ barPosition: BarPosition.Start, controller: this.controller, index: this.tabsIndex }) {
          TabContent() {
            MainPage({ num: this.width, ratio: this.ratio })
          }.tabBar({ text: this.tabTittleData[0].title })

          TabContent() {
            VisitPage({ ratio: this.ratio })
          }.tabBar({ text: this.tabTittleData[0].title })

          TabContent() {
            Information({ ratio: this.ratio })
          }.tabBar({ text: this.tabTittleData[0].title })

          TabContent() {
            ShopCart({ ratio: this.ratio })
          }.tabBar({ text: this.tabTittleData[0].title })

          TabContent() {
            User({ num: this.width, ratio: this.ratio })
          }.tabBar({ text: this.tabTittleData[0].title })
        }
        .barWidth(400)
        .barHeight(0)
        .scrollable(false)
        .animationDuration(200)
        .height('92%')

        Column() {
          Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
            ForEach(this.tabTittleData, item => {
              Flex({
                direction: FlexDirection.Column,
                justifyContent: FlexAlign.Center,
                alignItems: ItemAlign.Center
              }) {
                Image(this.tabsIndex == item.id ? item.selectedUri : item.uri)
                  .width(25 * this.ratio)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                Text(item.title)
                  .fontSize(15 * this.ratio)
                  .margin(1)
                  .fontColor(this.tabsIndex == item.id ? Color.Orange : Color.Black)
              }
              .width('20%')
              .onClick(() => {
                this.tabsIndex = item.id
                this.controller.changeIndex(item.id)
              })
            }, item => item.toString())
          }
          .height('8%')
        }
        .width('100%')
      }
      .width(`${this.width}%`)
      .backgroundColor(Color.White)
    }
    .width('100%')
    .backgroundColor('#10000000')
  }

  PageTransition() {
    PageTransitionEnter({ duration: 0, curve: Curve.Linear, delay: 0 })
      .onEnter((type: RouteType, progress: number) => {
        this.opacity = 1
      })
    PageTransitionExit({ duration: 0, curve: Curve.Linear, delay: 0 })
      .onExit((type: RouteType, progress: number) => {
        this.opacity = 1
      })
  }
}