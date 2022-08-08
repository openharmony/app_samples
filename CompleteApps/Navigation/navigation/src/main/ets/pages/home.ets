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

import display from '@ohos.display'
import { TabTitleModel } from '../model/homeModel'
import { tabTitleData } from '../data/homeData'
import { MainPage } from './homePage/mainPage'
import { NewProduct } from './homePage/newProduct'
import { ShopCart } from './homePage/shopCart'
import { User } from './homePage/user'

const SCREEN_RATIO: number = 0.5625 // 设备的屏幕宽高比
AppStorage.Link('isUpdateDialogOpen') || AppStorage.SetOrCreate('isUpdateDialogOpen', false)

@Entry
@Component
export struct NavigationHomePage {
  @State tabsIndex: number = 0
  @State tabTitleData: Array<TabTitleModel> = tabTitleData
  @State ratio: number = 1 // 适配屏幕所需要乘的比例，默认为1
  private url: string
  private option: object
  private controller: TabsController = new TabsController()

  @Builder TabBarBuilder(index: number) {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Image(this.tabsIndex === this.tabTitleData[index].id ? this.tabTitleData[index].uri : this.tabTitleData[index].selectedUri)
          .width('50%')
          .height('50%')
          .objectFit(ImageFit.Contain)
        Text(this.tabTitleData[index].title)
          .margin(4)
          .fontSize(14)
          .fontWeight(500)
          .opacity(this.tabsIndex == this.tabTitleData[index].id ? 1 : 0.6)
          .fontWeight(this.tabsIndex == this.tabTitleData[index].id ? 500 : 400)
          .fontColor(this.tabsIndex === this.tabTitleData[index].id ? Color.Red : Color.Black)
      }

      .width('100%')
      .onClick(() => {
        this.tabsIndex = this.tabTitleData[index].id
        this.controller.changeIndex(this.tabTitleData[index].id)
      })
    }
  }

  aboutToAppear() {
    display.getAllDisplay((err, data) => {
      let aspect = data[0].width / data[0].height
      if (aspect === SCREEN_RATIO) {
        this.ratio = 1.3 // 适配到设备上放大的倍数
      }
    })
  }

  pageTransition() {
    PageTransitionEnter({ duration: 1200 })
      .slide(SlideEffect.Left)
    PageTransitionExit({ delay: 100 })
      .translate({ x: 100.0, y: 100.0 })
      .opacity(0)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          MainPage({ ratio: this.ratio, url: this.url, option: this.option })
        }.tabBar(this.TabBarBuilder(0))

        TabContent() {
          NewProduct({ ratio: this.ratio, url: this.url, option: this.option })
        }.tabBar(this.TabBarBuilder(1))

        TabContent() {
          ShopCart({ ratio: this.ratio, url: this.url, option: this.option })
        }.tabBar(this.TabBarBuilder(2))

        TabContent() {
          User({ ratio: this.ratio, url: this.url, option: this.option })
        }.tabBar(this.TabBarBuilder(3))
      }
      .barHeight('8%')
      .scrollable(false)
      .barMode(BarMode.Fixed)
      .onChange((index: number) => {
        this.tabsIndex = index
      })
    }
    .backgroundColor('#F1F3F5')
  }
}