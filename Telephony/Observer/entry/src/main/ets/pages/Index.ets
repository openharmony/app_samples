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
import observer from '@ohos.telephony.observer'
import radio from '@ohos.telephony.radio'
import Logger from '../modle/Logger'
import router from '@ohos.router'
import DetailData from '../modle/DetailData'

const TAG: string = 'Index'
let detailData: DetailData = new DetailData()

@Entry
@Component
struct Index {
  @State subscribes: Array<Resource> = [
    $r('app.string.network_state_change'),
    $r('app.string.signal_info_change'),
    $r('app.string.callState_change'),
    $r('app.string.cellular_data_connection_state_change'),
    $r('app.string.cellular_data_flow_change'),
    $r('app.string.sim_state_change')
  ]
  networkStateChangeCallback = (data) => {
    Logger.info(TAG, `on networkStateChange, data: ${JSON.stringify(data)}`)
    detailData.networkState = <radio.NetworkState> data
  }
  signalInfoChangeCallback = (data) => {
    Logger.info(TAG, `on signalInfoChange, data: ${JSON.stringify(data)}`)
    detailData.signalInformation = data
  }
  callStateChangeCallback = (data) => {
    Logger.info(TAG, `on callStateChange, data: ${JSON.stringify(data)}`)
    detailData.callState = data.state
    detailData.callNumber = data.number
  }
  cellularDataConnectionStateChangeCallback = (data) => {
    Logger.info(TAG, `on cellularDataConnectionStateChange, data: ${JSON.stringify(data)}`)
    detailData.dataConnectState = data.state
    detailData.ratType = data.network
  }
  cellularDataFlowChangeCallback = (data) => {
    Logger.info(TAG, `on cellularDataFlowChange, data: ${JSON.stringify(data)}`)
    detailData.dataFlowType = data
  }
  simStateChangeCallback = (data) => {
    Logger.info(TAG, `on simStateChange, data: ${JSON.stringify(data)}`)
    detailData.simStateData = data
  }

  onChangeCallback(index: number, isOn: boolean) {
    switch (index) {
      case 0:
          isOn ? observer.on('networkStateChange', this.networkStateChangeCallback) :
        observer.off('networkStateChange', this.networkStateChangeCallback)
        break
      case 1:
          isOn ? observer.on('signalInfoChange', this.signalInfoChangeCallback) :
        observer.off('signalInfoChange', this.signalInfoChangeCallback)
        break
      case 2:
          isOn ? observer.on('callStateChange', this.callStateChangeCallback) :
        observer.off('callStateChange', this.callStateChangeCallback)
        break
      case 3:
          isOn ? observer.on('cellularDataConnectionStateChange', this.cellularDataConnectionStateChangeCallback) :
        observer.off('cellularDataConnectionStateChange', this.cellularDataConnectionStateChangeCallback)
        break
      case 4:
          isOn ? observer.on('cellularDataFlowChange', this.cellularDataFlowChangeCallback) :
        observer.off('cellularDataFlowChange', this.cellularDataFlowChangeCallback)
        break
      case 5:
          isOn ? observer.on('simStateChange', this.simStateChangeCallback) :
        observer.off('simStateChange', this.simStateChangeCallback)
        break
      default:
        break
    }
  }

  build() {
    Column() {
      Row() {
        Text('observer')
          .fontSize(30)
          .fontColor(Color.White)
      }
      .width('100%')
      .height('8%')
      .padding({ left: 16 })
      .backgroundColor('#0D9FFB')

      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.subscribes, (item, index) => {
          ListItem() {
            Row() {
              Text(item)
                .fontSize(20)
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: false })
                .size({ width: 28, height: 28 })
                .selectedColor('#0D9FFB')
                .onChange((isOn: boolean) => {
                  this.onChangeCallback(index, isOn)
                })
            }.width('100%')
          }
          .width('100%')
        }, item => JSON.stringify(item))
      }
      .width('100%')
      .height('70%')
      .padding({ left: 10, right: 10 })

      Button($r('app.string.details'))
        .width('40%')
        .onClick(() => {
          Logger.info(TAG, `detailData is = ${JSON.stringify(detailData)}`)
          router.push({
            url: 'pages/Detail',
            params: {
              detailData: detailData
            }
          })
        })
    }
    .width('100%')
    .height('100%')
  }
}