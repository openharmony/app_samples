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

import { GoodsList } from '../../components/goodslist'
import { newProductTitleBarModel, SwiperModel } from '../../model/homeModel'
import { newProductTitleBarData, swiperData } from '../../data/homeData'

@Component
export struct NewProduct {
  @State tabsIndex: number = 0
  @State swiperData: Array<SwiperModel> = swiperData
  @State newProductTitleBarData: Array<newProductTitleBarModel> = newProductTitleBarData
  @Prop ratio: number
  private url: string
  @Prop isLand: boolean
  private option: object
  private controller: TabsController = new TabsController()

  build() {
    Column() {
      List() {
        ListItem() {
          Flex({ direction: FlexDirection.Row,
            justifyContent: FlexAlign.Center,
            alignItems: ItemAlign.Center }) {
            Swiper() {
              ForEach(this.swiperData, item => {
                Navigator({ target: 'pages/detail' }) {
                  Image(item.img)
                    .objectFit(ImageFit.Fill)
                    .borderRadius({ bottomLeft: '12vp', bottomRight: '12vp', topLeft: 0, topRight: 0 })
                }
                .clip(true)
                .params({ ratio: this.ratio })
              }, item => item.toString())
            }
            .loop(true)
            .autoPlay(true)
            .indicator(false)
            .indicatorStyle({
              selectedColor: 'black',
              color: 'rgba(0,0,0,0.20',
              right: '5%',
              bottom: '5%',
              size: 10
            })
            .width('100%')
            .height(250)
          }
        }

        ListItem() {
          Column() {
            Flex({
              direction: FlexDirection.Row,
              justifyContent: FlexAlign.SpaceBetween,
              alignItems: ItemAlign.Center
            }) {
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                ForEach(this.newProductTitleBarData, item => {
                  Column() {
                    Text(item.title)
                      .margin(6)
                      .fontSize(20)
                      .fontColor('#ff000000')
                      .opacity(this.tabsIndex == item.id ? 1 : 0.6)
                      .fontWeight(this.tabsIndex == item.id ? 500 : 400)
                  }
                  .onClick(() => {
                    this.tabsIndex = item.id
                    this.controller.changeIndex(item.id)
                  })
                }, item => item.toString())

                Row() {
                  Image($r('app.media.nav_classification'))
                    .width('3.5%')
                    .height('55%')
                    .objectFit(ImageFit.Contain)
                  Text($r('app.string.classification'))
                    .fontSize(20)
                    .opacity(0.6)
                    .fontColor('#ff000000')
                }
              }
            }
          }
        }
        .height('5%')
        .width('98%')
        .padding({ left: '7vp', right: '7vp' })
        .margin({ left: 4, bottom: '12vp', top: '12vp', right: 4 })

        ListItem() {
          Column() {
            Tabs({ controller: this.controller }) {
              TabContent() {
                GoodsList({ isLand: this.isLand, ratio: this.ratio, url: this.url })
              }
            }
            .barWidth(0)
            .barHeight(0)
            .height('67%')
            .scrollable(false)
          }
          .justifyContent(FlexAlign.Center)
        }
      }

      Divider()
        .color('#ffa9a9a9')
        .width(1)
    }
    .width('100%')
    .height('100%')
  }
}