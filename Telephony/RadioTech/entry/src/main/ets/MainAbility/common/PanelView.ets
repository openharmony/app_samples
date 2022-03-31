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

import { RadioStatus } from '../model/RadioStatus'

@Component
export struct PanelView {
  @Link show: boolean
  private slotId: number
  private title: string
  @State statusArray: Array<any> = []
  @State radioStatus: RadioStatus = new RadioStatus()

  aboutToAppear() {
    let self = this
    this.radioStatus.getRadioTech(this.slotId, (result) => {
      self.statusArray.push({ title: 'RadioTech', value: result })
    })
    this.radioStatus.getSignalInformation(this.slotId, (result) => {
      self.statusArray.push({ title: 'SignalInformation', value: result })
    })
    this.radioStatus.getNetworkSelectionMode(this.slotId, (result) => {
      self.statusArray.push({ title: 'NetworkSelectionMode', value: result })
    })
    this.radioStatus.getISOCountryCodeForNetwork(this.slotId, (result) => {
      self.statusArray.push({ title: 'ISOCountryCodeForNetwork', value: result })
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
      console.info(`width:${value.width},height:${value.height},mode:${value.mode}`)
    })
    .onClick(() => {
      this.show = !this.show
    })
  }
}