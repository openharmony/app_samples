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
import { InfoView } from '../common/InfoView'
import { PanelView } from '../common/PanelView'
import { RadioStatus } from '../model/RadioStatus'
import { ResultModel } from '../model/ResultModel'

const TAG = '[Index]'

@Entry
@Component
struct Index {
  @State show: boolean = false
  @State slotId: number = 0
  @State title: string = 'SIM1 status'
  @State networks: Array<ResultModel> = []
  @State radioStatus: RadioStatus = new RadioStatus()

  aboutToAppear() {
    let networkState = this.radioStatus.getNetworkState().then((networkState) => {
      Logger.info(`${TAG}, aboutToAppear networkState = ${JSON.stringify(networkState)}`)
      let result = new ResultModel('NetworkState', networkState)
      this.networks.push(result)
    })

    this.radioStatus.getRadioOn().then((radioOn) => {
      Logger.info(`${TAG}, aboutToAppear radioOn = ${JSON.stringify(radioOn)}`)
      let result = new ResultModel('IsRadioOn', radioOn.toString())
      this.networks.push(result)
    }).catch(error => {
      Logger.error(`${TAG}, aboutToAppear radioOn error->${JSON.stringify(error)}`)
      let result = new ResultModel('IsRadioOn', `error:${JSON.stringify(error)}`)
      this.networks.push(result)
    })
  }

  build() {
    Stack() {
      Column() {
        Text($r('app.string.entry_MainAbility'))
          .width('100%')
          .height(50)
          .backgroundColor('#0D9FFB')
          .fontColor(Color.White)
          .fontSize(20)
          .padding({ left: 20 })

        Scroll() {
          Column() {
            InfoView({ show: $show, slotId: $slotId, title: $title })
            Divider().color(Color.Grey)
            ForEach(this.networks, item => {
              Column() {
                Text(item.title)
                  .width('100%')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .margin({ top: 10 })
                Text(item.value)
                  .width('100%')
                  .fontSize(20)
                  .margin({ bottom: 10 })
              }
              .margin({ left: 20, right: 20 })
            }, item => JSON.stringify(item))
          }
        }
        .layoutWeight(1)
      }

      PanelView({ show: $show, slotId: this.slotId, title: this.title })
    }
    .width('100%')
    .height('100%')
  }
}