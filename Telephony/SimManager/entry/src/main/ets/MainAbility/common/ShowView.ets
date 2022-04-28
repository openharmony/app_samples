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
``
import sim from '@ohos.telephony.sim'
import Logger from '../model/Logger'

const TAG = '[ShowView]'

@CustomDialog
export struct ShowView {
  @State simState: Resource = undefined
  @State results: Array<unknown> = []
  @State simTitle: Resource = undefined
  private slotId: number
  controller: CustomDialogController

  async simResult() {
    Logger.info(TAG, `getResult this.slotId ${this.slotId}`)
    this.simTitle = this.slotId === 0 ? $r('app.string.sim1_state') : $r('app.string.sim2_state')
    let result = await sim.isSimActive(this.slotId)
    this.simState = result ? $r('app.string.sim_activation') : $r('app.string.sim_inactivated')
  }

  async getSimData() {
    let data: Array<string | Resource> = new Array(3).fill('')
    Logger.info(TAG, `data = ${JSON.stringify(data)}`)
    try{
      data[0] = await sim.getSimSpn(this.slotId)
      Logger.info(TAG, `data = ${JSON.stringify(data[0])}`)
    } catch(err) {
      data[0] = $r('app.string.err')
      Logger.info(TAG, `data = ${JSON.stringify(data[0])} err = ${JSON.stringify(err)}`)
    }
    try{
      data[1] = await sim.getISOCountryCodeForSim(this.slotId)
      Logger.info(TAG, `data = ${JSON.stringify(data[1])}`)
    } catch(err) {
      data[1] = $r('app.string.err')
      Logger.info(TAG, `data = ${JSON.stringify(data[1])} err = ${JSON.stringify(err)}`)
    }
    try{
      data[2] = await sim.getSimOperatorNumeric(this.slotId)
      Logger.info(TAG, `data = ${JSON.stringify(data[2])}`)
    } catch(err) {
      data[2] = $r('app.string.err')
      Logger.info(TAG, `data = ${JSON.stringify(data[2])} err = ${JSON.stringify(err)}`)
    }
    Logger.info(TAG, `data is ${JSON.stringify(data)}`)
    return data
  }

  async aboutToAppear() {
    await this.simResult()
    let result = await this.getSimData()
    Logger.info(TAG, `result = ${JSON.stringify(result)}`)
    this.results = [
      { title: $r('app.string.spn'), value: result[0] }, { title: $r('app.string.iso'), value: result[1] },
      { title: $r('app.string.plmn'), value: result[2] }
    ]
    Logger.info(TAG, `results = ${JSON.stringify(this.results)}`)
  }

  build() {
    Column() {
      Text(this.simTitle)
        .fontSize(18)
        .margin({ left: 5, right: 5, top: 5, bottom: 10 })

      Text($r('app.string.active'))
        .margin(5)
        .fontSize(18)
        .fontColor(Color.Gray)

      Text(this.simState)
        .margin(5)
        .fontSize(18)

      ForEach(this.results, item => {
        Text(item.title)
          .margin(5)
          .fontSize(18)
          .fontColor(Color.Gray)

        Text(item.value)
          .margin(5)
          .fontSize(18)
      }, item => JSON.stringify(item))
    }
    .margin(10)
    .padding(5)
    .width('100%')
    .borderRadius(10)
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      this.controller.close()
      Logger.info(TAG, ` CustomDialog close`)
    })
  }
}
