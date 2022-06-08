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

import router from '@ohos.router'
import preferences from '@ohos.data.preferences'
import logger from '../Common/Logger'
import { Element } from '../Common/Element'
import { TitleBar } from '../Common/TitleBar'
import { AirQualityModel } from '../Model/AirQualityModel'

@Extend(Text) function fancyText (backgroundColor: string, height: number, margin: number) {
  .backgroundColor(backgroundColor)
  .height(height)
  .width('14%')
  .margin({ left: margin })
}

const TAG: string = 'Detail'

@Entry
@Component
struct Detail {
  private preference: preferences.Preferences = undefined
  private city: string = router.getParams()['city']
  @State airQualitysHistory: Array<AirQualityModel> = []
  handlerClickButton = () => {
    router.back()
  }

  async aboutToAppear() {
    this.preference = await preferences.getPreferences(globalThis.abilityContext, 'airquality')
    if (this.city === '深圳') {
      let shenZhenResult = <string> await this.preference.get('shenzhen', 'default')
      this.airQualitysHistory = JSON.parse(shenZhenResult)
      logger.info(TAG, `this.airQualitysHistoryShenZhen = ${JSON.stringify(this.airQualitysHistory)}`)
    }
    if (this.city === '东莞') {
      let shenZhenResult = <string> await this.preference.get('shenzhen', 'default')
      this.airQualitysHistory = JSON.parse(shenZhenResult)
      logger.info(TAG, `this.airQualitysHistoryDongGuan = ${JSON.stringify(this.airQualitysHistory)}`)
    }
  }

  formatNumber(data) {
    return data * 20
  }

  build() {
    Column() {
      TitleBar({ handlerClickButton: this.handlerClickButton })
      Scroll() {
        Column() {
          Row() {
            Text(this.city)
              .width('100%')
              .height(45)
              .fontSize(40)
              .fontWeight(500)
              .textAlign(TextAlign.Center)
          }
          .height(45)
          .width('100%')
          .margin({ top: 30 })

          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
            ForEach(this.airQualitysHistory, (item, index) => {
              Column() {
                Text(item.date)
                  .fontSize(30)
                  .width('100%')
                  .height(30)
                  .textAlign(TextAlign.Start)
                  .margin({ top: 20 })
                Flex({ alignItems: ItemAlign.End }) {
                  Text().fancyText('#00ff00', this.formatNumber(item.co.data), 0)
                  Text().fancyText('#00ff00', this.formatNumber(item.so2.data), 5)
                  Text().fancyText('#ff0000', this.formatNumber(item.pm10.data), 5)
                  Text().fancyText('#ff0000', this.formatNumber(item.pm2p5.data), 5)
                  Text().fancyText('#FF7500', this.formatNumber(item.no2.data), 5)
                }
                .margin({ top: 20 })

                Element()
              }
              .width('47%')
              .margin({ left: 10 })
            })
          }
          .width('100%')

        }
        .constraintSize({ minHeight: '100%' })
        .alignItems(HorizontalAlign.Start)
      }
      .height('92%')
    }
  }
}