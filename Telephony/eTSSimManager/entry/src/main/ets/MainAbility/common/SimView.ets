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

import sim from '@ohos.telephony.sim'
import HiLogUtil from '../model/HiLogUtil.ets'

const TAG = '[SimView]'

@Component
export struct SimView {
  @State data: string = ''
  @State sim1Color: string = '#FFFFFF'
  @State sim2Color: string = '#FFFFFF'

  async getDefaultVoice() {
    let color: string
    try {
      let result = await sim.getDefaultVoiceSlotId()
      HiLogUtil.log(TAG, `color result is ${result}`)
      color = result === 0 ? '#0D9FFB' : '#FFFFFF'
      HiLogUtil.log(TAG, `color is ${JSON.stringify(color)}`)
    } catch (err) {
      color = '#FFFFFF'
      HiLogUtil.log(TAG, `color fail is ${JSON.stringify(color)}`)
      HiLogUtil.log(TAG, `err is ${JSON.stringify(err)}`)
    }
    return color
  }

  async aboutToAppear() {
    let result = await Promise.all([this.getDefaultVoice(), this.getDefaultVoice()])
    HiLogUtil.log(TAG, `result is ${JSON.stringify(result)}`)
    this.sim1Color = result[0]
    this.sim2Color = result[1]
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.voice'))
          .fontSize(20)
          .layoutWeight(1)
          .fontColor(Color.Gray)
        Row() {
          Button() {
            Text($r('app.string.sim1_id'))
              .fontSize(18)
              .fontColor(Color.Black)
              .textAlign(TextAlign.Center)
          }
          .width('50%')
          .height('85%')
          .padding(5)
          .borderRadius(10)
          .backgroundColor(this.sim1Color)

          Button() {
            Text($r('app.string.sim2_id'))
              .fontSize(18)
              .fontColor(Color.Black)
              .textAlign(TextAlign.Center)
          }
          .width('50%')
          .height('85%')
          .padding(5)
          .borderRadius(10)
          .backgroundColor(this.sim2Color)
        }
        .width('40%')
        .height('95%')
        .borderRadius(50)
        .backgroundColor('#F1F1F1')
      }
      .margin(8)
      .padding(10)
      .width('95%')
      .height('8%')
      .borderRadius(10)
      .backgroundColor(Color.White)
    }
  }
}