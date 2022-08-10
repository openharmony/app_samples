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

import { NavDataModel, TitleBarModel } from '../../model/homeModel'
import { navData, titleBarData } from '../../data/homeData'
import { GoodsList } from '../goodslist'
import { SwiperComponent } from './swiper'

@Component
export struct homePageContent {
  @State tabsIndex: number = 0
  @Prop isLand: boolean
  @State navData: Array<NavDataModel> = navData
  @State titleBarData: Array<TitleBarModel> = titleBarData
  @Prop ratio: number
  private url: string
  private option: object
  private controller: TabsController = new TabsController()

  build() {
    Scroll() {
      Column() {
        SwiperComponent({ ratio: this.ratio, isLand: this.isLand })
          .width('100%')
          .height('30%')
        Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
          ForEach(this.titleBarData, item => {
            Column() {
              Text(item.title)
                .fontSize(20)
                .fontWeight(500)
                .fontColor(this.tabsIndex === item.id ? Color.Red : Color.Black)
              Text(item.content)
                .fontSize(16)
                .opacity(0.6)
                .fontColor(this.tabsIndex === item.id ? Color.Red : Color.Black)
            }
            .width('20%')
            .onClick(() => {
              this.tabsIndex = item.id
              this.controller.changeIndex(item.id)
            })
          }, item => item.toString())
        }
        .backgroundColor('#F1F3F5')
        .margin({ top: 8, bottom: 8 })
        .padding({ top: 10 * this.ratio, bottom: 10 * this.ratio })

        // 主页下半部分商品展示--全部、精选、新品、实惠
        Tabs({ controller: this.controller }) {
          TabContent() {
            GoodsList({ isLand: this.isLand, ratio: this.ratio, url: this.url })
          }

          TabContent() {
            GoodsList({ isLand: this.isLand, ratio: this.ratio, url: this.url })
          }

          TabContent() {
            GoodsList({ isLand: this.isLand, ratio: this.ratio, url: this.url })
          }

          TabContent() {
            GoodsList({ isLand: this.isLand, ratio: this.ratio, url: this.url })
          }
        }
        .barWidth(0)
        .barHeight(0)
        .height('55%')
        .scrollable(false)
      }
    }
  }
}