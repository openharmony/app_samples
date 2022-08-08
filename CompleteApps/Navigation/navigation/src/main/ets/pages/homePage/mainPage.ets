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

import mediaQuery from '@ohos.mediaquery'
import { NavDataModel } from '../../model/homeModel'
import { navData } from '../../data/homeData'
import { TitleBarComponent } from '../../components/home/titleBar'
import { homePageContent } from '../../components/home/homePageContent'

@Component
export struct MainPage {
  @State navTabsIndex: number = 0
  @State navData: Array<NavDataModel> = navData
  @State isLand: boolean = false
  @Prop ratio: number
  private url: string
  private option: object
  private navController: TabsController = new TabsController()
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')

  onPortrait(mediaQueryResult) {
    this.isLand = mediaQueryResult.matches
  }

  aboutToAppear() {
    this.listener.on('change', this.onPortrait.bind(this))
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      List() {
        ListItem() {
          TitleBarComponent({ ratio: this.ratio })
        }
        .sticky(Sticky.Normal)
        .backgroundImageSize({ width: '100%', height: '100%' })
        .backgroundImage($r('app.media.titleBar'), ImageRepeat.NoRepeat)

        ListItem() {
          Column() {
            Flex({
              direction: FlexDirection.Row,
              justifyContent: FlexAlign.SpaceBetween,
              alignItems: ItemAlign.Center
            }) {
              Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
                ForEach(this.navData, item => {
                  Column() {
                    Text(item.navData)
                      .margin(6)
                      .fontSize(20)
                      .fontColor('#FFFFFF')
                      .opacity(this.navTabsIndex == item.id ? 1 : 0.6)
                      .fontWeight(this.navTabsIndex == item.id ? 500 : 400)
                  }
                  .onClick(() => {
                    this.navTabsIndex = item.id
                    this.navController.changeIndex(item.id)
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
                    .fontWeight(400)
                    .fontColor('#FFFFFF')
                }
              }
            }
            .height('5%')
            .width('100%')
            .margin({ left: 4, bottom: '12vp' })
            .padding({ left: '7vp', right: '7vp' })

            Tabs({ controller: this.navController }) {
              TabContent() {
                homePageContent({ isLand: this.isLand, ratio: this.ratio, url: this.url, option: this.option })
              }
            }
            .barWidth(0)
            .barHeight(0)
            .aspectRatio(0.1)
            .scrollable(false)
          }
        }
        .backgroundImageSize({ width: '100%', height: '1.5%' })
        .backgroundImage($r('app.media.homeBg'), ImageRepeat.NoRepeat)
      }

      Divider()
        .color('#ffa9a9a9')
        .width(1)
    }
    .width('100%')
    .height('100%')
  }
}