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

import { RadioStatus } from '../model/radioStatus'

@Component
export struct InfoView {
  @Link show: boolean
  @Link slotId: number
  @Link title: string
  @State simArray: Array<any> = []
  @State radioStatus: RadioStatus = new RadioStatus()

  aboutToAppear() {
    this.getSimSpn(0)
    this.getSimSpn(1)
  }

  getSimSpn(slotId) {
    let self = this
    this.radioStatus.getSimSpn(slotId, (result) => {
      let title = slotId === 0 ? 'SIM1 status' : 'SIM2 status'
      self.simArray.push({ slotId: slotId, title: title, value: result })
    })
  }

  build() {
    Column() {
      ForEach(this.simArray, item => {
        Row() {
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
          .layoutWeight(1)

          Image($r('app.media.right_arrow'))
            .width('3%')
            .height('3%')
            .margin({ right: 10 })
        }
        .width('100%')
        .onClick(() => {
          console.log(`PanelView()`)
          this.show = !this.show
          this.slotId = item.slotId
          this.title = item.title
        })

      }, item => JSON.stringify(item))
    }
    .width('100%')
    .padding({ left: 20, right: 20 })
  }
}