/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import { InfoView } from '../common/infoView'
import { PanelView } from '../common/panelView'
import { RadioStatus } from '../model/radioStatus'

@Entry
@Component
struct Index {
  @State show: boolean = false
  @State slotId: number = 0
  @State title: string = 'SIM1 status'
  @State networkArray: Array<any> = []
  @State radioStatus: RadioStatus = new RadioStatus()

  aboutToAppear() {
    let self = this
    this.radioStatus.getNetworkState((result) => {
      self.networkArray.push({ title: 'NetworkState', value: result })
    })
    this.radioStatus.getRadioOn((result) => {
      self.networkArray.push({ title: 'IsRadioOn', value: result })
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
            ForEach(this.networkArray, item => {
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