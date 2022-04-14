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
import { RadioStatus } from '../model/RadioStatus'
import { ResultModel } from '../model/ResultModel'

const TAG = '[PanelView]'

@Component
export struct PanelView {
  @Link show: boolean
  private slotId: number
  private title: string
  @State statusArray: Array<ResultModel> = []
  @State radioStatus: RadioStatus = new RadioStatus()

  async aboutToAppear() {
    this.radioStatus.getRadioTech(this.slotId).then((radioTech) => {
      Logger.info(`${TAG}, aboutToAppear radioTech = ${JSON.stringify(radioTech)}`)
      let result = new ResultModel('RadioTech', JSON.stringify(radioTech))
      this.statusArray.push(result)
    })

    this.radioStatus.getSignalInformation(this.slotId).then((signalInformation) => {
      Logger.info(`${TAG}, aboutToAppear signalInformation = ${JSON.stringify(signalInformation)}`)
      let result = new ResultModel('SignalInformation', JSON.stringify(signalInformation))
      this.statusArray.push(result)
    })

    this.radioStatus.getNetworkSelectionMode(this.slotId).then((networkSelectionMode) => {
      Logger.info(`${TAG}, aboutToAppear networkSelectionMode = ${JSON.stringify(networkSelectionMode)}`)
      let result = new ResultModel('NetworkSelectionMode', JSON.stringify(networkSelectionMode))
      this.statusArray.push(result)
    })

    this.radioStatus.getISOCountryCodeForNetwork(this.slotId).then((iSOCountryCode) => {
      Logger.info(`${TAG}, aboutToAppear iSOCountryCode = ${JSON.stringify(iSOCountryCode)}`)
      let result = new ResultModel('ISOCountryCodeForNetwork', JSON.stringify(iSOCountryCode))
      this.statusArray.push(result)
    })
  }

  build() {
    Panel(this.show) {
      Column() {
        Text(this.title)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 10 })
        Divider()
        ForEach(this.statusArray, item => {
          Column() {
            Text(item.title)
              .fontSize(20)
              .fontColor(Color.Grey)
              .margin({ top: 10 })
            Text(item.value)
              .fontSize(20)
          }
        }, item => JSON.stringify(item)
        )
      }
    }
    .type(PanelType.Foldable)
    .mode(PanelMode.Half)
    .dragBar(true)
    .halfHeight(500)
    .onChange((value: any) => {
      Logger.info(`${TAG}, onChange`)
    })
    .onClick(() => {
      this.show = !this.show
    })
  }
}