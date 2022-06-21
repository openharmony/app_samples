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
import { getAppName, getTotalTime, getTimStr } from '../utils/Util'

const TAG = 'PanelView'
const oftenUsed = 5

@Component
export struct PanelView {
  @State statisticals: Array<AppTime> = []
  @State panelName: string[] = []
  @State panelValue: number[] = []
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
    let topFiveTotalTime = 0
    for (let i = 0;i < oftenUsed; i++) {
      this.panelName.push(getAppName(this.statisticals[i].bundleName))
      this.panelValue.push(this.statisticals[i].totalTime)
      topFiveTotalTime += this.statisticals[i].totalTime
    }
    this.panelName.push('others')
    this.panelValue.push(this.totalTime - topFiveTotalTime)
  }

  build() {
    Column() {
      Text($r('app.string.application_duration'))
        .fontSize(20)
        .width('100%')
        .margin({ top: 10 })
        .textAlign(TextAlign.Center)
      Row() {
        DataPanel({ values: this.panelValue, max: this.totalTime, type: DataPanelType.Circle })
          .width(200)
          .height(200)
        Column() {
          ForEach(this.panelName, (item) => {
            Text(item)
              .fontSize(20)
              .margin({ top: 5 })
          }, item => item)
        }
        .height('80%')
        .margin({ top: '10%', left: 35 })
      }
      .height(250)
      .margin({ top: 10 })
      .alignSelf(ItemAlign.Center)
    }
    .height('30%')
    .width('100%')
  }
}