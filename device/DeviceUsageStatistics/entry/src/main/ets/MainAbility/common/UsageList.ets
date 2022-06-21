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

import Logger from '../model/Logger'
import AppTime from '../model/AppTime'
import bundleState from '@ohos.bundleState'
import { hmsToString, getAppName, getAppIcon, getTotalTime, getTimStr } from '../utils/Util'

const TAG = 'UsageList'

@Component
export struct UsageList {
  @State statisticals: Array<AppTime> = []
  @State totalTime: number = 0

  aboutToAppear() {
    this.getTime()
  }

  async getTime() {
    let dateBegin = new Date()
    dateBegin.setHours(0)
    dateBegin.setMinutes(0)
    dateBegin.setSeconds(0)
    Logger.info(TAG, `dateBegin= ${getTimStr(dateBegin)} ${dateBegin.toString()}`)
    let dateEnd = new Date()
    Logger.info(TAG, `dateEnd= ${getTimStr(dateEnd)} ${dateEnd.toString()}`)
    let res = await bundleState.queryBundleStateInfos(Date.parse(dateBegin.toString()), Date.parse(dateEnd.toString()))
    Logger.info(TAG, `queryBundleStateInfos promise success`)
    let list: Array<AppTime> = []
    for (let key in res) {
      if (res.hasOwnProperty(key)) {
        Logger.info(TAG, `queryBundleStateInfos promise result ${JSON.stringify(res[key])}`)
        let appTime = new AppTime(res[key].bundleName, res[key].abilityPrevAccessTime, res[key].abilityInFgTotalTime)
        list.push(appTime)
      }
    }
    this.totalTime = getTotalTime(list)
    list.sort((a, b) => b.totalTime - a.totalTime)
    this.statisticals = list
  }

  build() {
    Column() {
      Text(hmsToString(this.totalTime / 1000))
        .width('80%')
        .fontSize(30)
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 15, bottom: 15 })
      Scroll() {
        Column() {
          ForEach(this.statisticals, (item) => {
            Row() {
              Image(getAppIcon(item.bundleName))
                .width(80)
                .height(80)
                .objectFit(ImageFit.Fill)
              Column() {
                Row() {
                  Text(getAppName(item.bundleName))
                    .width('60%')
                    .fontSize(25)
                    .fontWeight(FontWeight.Bold)
                  Text(hmsToString(Math.floor(item.totalTime / 1000)))
                    .width('40%')
                    .fontSize(22)
                    .textAlign(TextAlign.End)
                }
                .width('100%')
                .alignSelf(ItemAlign.Start)

                Progress({ value: item.totalTime, total: this.totalTime, type: ProgressType.Linear })
                  .height(20)
                  .width('100%')
                  .color(Color.Grey)
                  .margin({ top: 12 })
                  .style({ strokeWidth: 10 })
                  .alignSelf(ItemAlign.Start)

                Row() {
                  Text($r('app.string.application_last_used')).fontSize(15)
                  Text(hmsToString(Math.floor(item.prevAccessTime / 1000))).fontSize(15)
                }
                .width('100%')
              }
              .layoutWeight(1)
              .padding({ left: 5, right: 5 })
            }
            .width('100%')
            .height(95)
            .margin({ bottom: 50 })
          }, item => item.bundleName)
        }
        .padding(10)
        .justifyContent(FlexAlign.Start)
      }
      .width('90%')
      .height('80%')
      .scrollBar(BarState.Off)
      .backgroundColor(Color.White)
      .scrollable(ScrollDirection.Vertical)
      .border({ width: 20, color: Color.White, radius: 10 })
    }
    .width('100%')
    .height('55%')
    .margin({ top: 40 })
  }
}