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
import { NetworkMobile } from '../model/NetworkMobile'

const TAG: string = '[NetWork]'

@Extend(Text) function simId () {
  .margin(5)
  .fontSize(20)
  .width('40%')
  .textAlign(TextAlign.Center)
  .borderRadius(10)
}

@Component
export struct NetWork {
  @State cellularDataFlowType: Resource = $r('app.string.error')
  @State cellularDataState: Resource = $r('app.string.error')
  private slotId: number = -1
  private cellularData: boolean = false
  private cellularDataRoaming: boolean = false
  private netWorkMobile: NetworkMobile = new NetworkMobile()

  async aboutToAppear() {
    this.slotId = await this.netWorkMobile.getDefaultCellularDataSlotId()
    Logger.info(TAG, `this slotid = ${this.slotId}`)
    this.cellularData = await this.netWorkMobile.isCellularDataEnabled()
    Logger.info(TAG, `this cellularData = ${this.cellularData}`)
    this.cellularDataRoaming = await this.netWorkMobile.isCellularDataRoamingEnabled(this.slotId)
    Logger.info(TAG, `this cellularDataRoaming = ${this.cellularDataRoaming}`)
    this.cellularDataFlowType = await this.netWorkMobile.getCellularDataFlowType()
    Logger.info(TAG, `this cellularDataFlowType = ${this.cellularDataFlowType}`)
    this.cellularDataState = await this.netWorkMobile.getCellularDataState()
    Logger.info(TAG, `this concellularDataStateectTetx = ${this.cellularDataState}`)
  }

  @Builder dataState(text: Resource, flag: boolean) {
    Row() {
      Text(text)
        .margin({ left: 10 })
        .fontSize(20)
        .width('55%')
        .textAlign(TextAlign.Start)

      Text(flag ? $r('app.string.start') : $r('app.string.end'))
        .fontSize(20)
        .margin({ left: 10, right: 6 })
        .textAlign(TextAlign.Center)
        .layoutWeight(1)
    }
    .margin(10)
    .height('8%')
  }

  @Builder networkState(text: Resource, state: Resource) {
    Column() {
      Text(text)
        .margin({ left: 10, top: 16, right: 10, bottom: 10 })
        .fontSize(20)
        .width('100%')
        .textAlign(TextAlign.Start)

      Text(state)
        .margin({ left: 10 })
        .fontSize(18)
        .width('100%')
        .textAlign(TextAlign.Start)
    }
    .alignItems(HorizontalAlign.Start)
    .margin(10)
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.sim'))
          .margin({ left: 10 })
          .fontSize(20)
          .width('60%')
          .textAlign(TextAlign.Start)
        Row() {
          Text($r('app.string.simOne'))
            .simId()
            .backgroundColor(this.slotId === 0 ? '#0D9FFB' : undefined)

          Text($r('app.string.simTwo'))
            .simId()
            .backgroundColor(this.slotId === 0 ? undefined : '#0D9FFB')
        }
        .width('35%')
        .borderRadius(10)
        .backgroundColor('#fff5f5f5')
      }
      .height('8%')
      .margin({ right: 10, bottom: 10 })

      Divider()

      this.dataState($r('app.string.mobile'), this.cellularData)

      Divider()

      this.dataState($r('app.string.roaming'), this.cellularDataRoaming)

      Divider()

      this.networkState($r('app.string.flow'), this.cellularDataFlowType)

      Divider()

      this.networkState($r('app.string.connectData'), this.cellularDataState)

    }
    .width('100%')
    .height('100%')
  }
}