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
import { ShowView } from '../common/ShowView.ets'
import { SimView } from '../common/SimView.ets'
import { CallView } from '../common/CallView.ets'
import { Show } from '../common/Show.ets'

const TAG = '[InfoView]'
const card1 = 0
const card2 = 1

@Component
export struct InfoView {
  @State data: string = ''
  @State slotId: number = 0
  @State sim1Color: string = '#FFFFFF'
  @State sim2Color: string = '#FFFFFF'
  @State sim1Text: Resource = undefined
  @State sim2Text: Resource = undefined
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ShowView({ slotId: this.slotId }), autoCancel: true, alignment: DialogAlignment.Center })

  async getColor(slotId: number) {
    let result = await sim.hasSimCard(slotId)
    HiLogUtil.log(TAG, `color result is ${result}`)
    let color = result ? '#0D9FFB' : '#FFFFFF'
    HiLogUtil.log(TAG, `color is ${JSON.stringify(color)}`)
    return color
  }

  async getTextData(slotId: number) {
    let flagText: Resource
    try {
      let result = await sim.getSimState(slotId)
      HiLogUtil.log(TAG, `getSimState is ${result}`)
      switch (result) {
        case sim.SimState.SIM_STATE_UNKNOWN:
          flagText = $r('app.string.unknown')
          break
        case sim.SimState.SIM_STATE_NOT_PRESENT:
          flagText = $r('app.string.not_present')
          break
        case sim.SimState.SIM_STATE_LOCKED:
          flagText = $r('app.string.locked')
          break
        case sim.SimState.SIM_STATE_NOT_READY:
          flagText = $r('app.string.not_ready')
          break
        case sim.SimState.SIM_STATE_READY:
          flagText = $r('app.string.ready')
          break
        case sim.SimState.SIM_STATE_LOADED:
          flagText = $r('app.string.loaded')
          break
      }
      HiLogUtil.log(TAG, `flagText is ${JSON.stringify(flagText)}`)
    } catch (err) {
      flagText = $r('app.string.err')
      HiLogUtil.log(TAG, `err is ${JSON.stringify(err)}`)
      HiLogUtil.log(TAG, `flagText is ${JSON.stringify(flagText)}`)
    }
    return flagText
  }

  async aboutToAppear() {
    let result = await Promise.all([
      this.getColor(card1), this.getColor(card2), this.getTextData(card1), this.getTextData(card2)
    ])
    HiLogUtil.log(TAG, `getData result is ${JSON.stringify(result)}`)
    this.sim1Color = result[0]
    this.sim2Color = result[1]
    this.sim1Text = result[2]
    this.sim2Text = result[3]
  }

  build() {
    Scroll() {
      Column() {
        Show({
          slotId: card1,
          simText: this.sim1Text,
          simColor: this.sim1Color,
          simTitle: $r('app.string.sim1_id'),
          simCard: $r('app.string.sim1_card')
        })

        Show({
          slotId: card2,
          simText: this.sim2Text,
          simColor: this.sim2Color,
          simTitle: $r('app.string.sim2_id'),
          simCard: $r('app.string.sim2_card')
        })

        SimView()
        CallView()
      }
    }
    .layoutWeight(1)
  }
}