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

import wifi from '@ohos.wifi'
import { AvailableWifi } from '../component/availableWifi'
import grantPermission from '../model/permissionUtils'
import HiLog from '../model/HiLog'
import { TitleBar } from '../component/titleBar'
import { WifiModel } from '../model/wifiModel'

const TAG = 'Index'

@Entry
@Component
struct Index {
  private wifiModel: WifiModel = new WifiModel()
  private linkedInfo: unknown = {
    ssid: "",
    bssid: "",
    networkId: 0,
    rssi: 0,
    band: 0
  }
  @State wifiList: Array<any> = []
  @State isLinked: boolean = false
  @State isSwitchOn: boolean = false

  scan() {
    this.wifiModel.getScanInfos((result) => {
      if (this.isSwitchOn) {
        this.wifiList = result
        if (result.length === 0) {
          setTimeout(() => {
            this.scan()
          }, 1000)
        }
      }
    })
  }

  getLinkedInfo() {
    wifi.getLinkedInfo((err, linkedInfo) => {
      if (err) {
        HiLog.error(TAG, `getLinkedInfo err: ${JSON.stringify(err)}`)
        return
      }
      HiLog.log(TAG, `linkedInfo: ${JSON.stringify(linkedInfo)}`)
      if (linkedInfo === null || linkedInfo.bssid === '') {
        this.isLinked = false
        this.linkedInfo = {
          ssid: "",
          bssid: "",
          networkId: 0,
          rssi: 0,
          band: 0
        }
        return
      }
      this.linkedInfo = linkedInfo
    })
  }

  addListener() {
    wifi.on('wifiConnectionChange', state => {
      HiLog.log(TAG, `wifiConnectionChange: ${state}`)
      if (state === 1) { // 1: wifi is connected, 0:wifi is disConnected
        this.isLinked = true
        this.getLinkedInfo()
        return
      }
      this.isLinked = false
    })
    wifi.on('wifiStateChange', state => {
      HiLog.log(TAG, `wifiStateLisener state: ${state}`)
      this.wifiList = []
      if (state === 1) { // 1: wifi is enable, 0:wifi is disable
        wifi.scan()
        this.scan()
      }
    })
  }

  aboutToAppear() {
    grantPermission()
    if (wifi.isWifiActive()) {
      HiLog.log(TAG, 'wifi is active')
      this.isSwitchOn = true
      wifi.scan()
      this.scan()
      if (wifi.isConnected()) {
        this.getLinkedInfo()
      }
    }
    this.addListener()
  }

  build() {
    Column() {
      TitleBar()
      Row() {
        Text($r('app.string.wlan'))
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
        Column() {
          Toggle({ type: ToggleType.Switch, isOn: this.isSwitchOn })
            .onChange((isOn: boolean) => {
              HiLog.log(TAG, `wifi swtich is: ${isOn}`)
              if (isOn) {
                this.isSwitchOn = true
                wifi.enableWifi()
                return
              }
              this.isSwitchOn = false
              this.isLinked = false
              wifi.disconnect()
              wifi.disableWifi()
            })
        }
      }
      .width('95%')

      if (this.isLinked) {
        Text($r('app.string.connected'))
          .fontSize(22)
          .width('95%')
        Row() {
          Text(this.linkedInfo.ssid)
            .fontSize(20)
            .fontColor(Color.Black)
            .layoutWeight(1)
          Text($r('app.string.connected'))
            .fontSize(18)
            .fontColor(Color.Black)
        }
        .width('95%')
        .padding(10)
        .margin(10)
        .border({ radius: 15, color: Color.Gray, width: 1 })
        .backgroundColor(Color.White)
      }
      AvailableWifi({ wifiList: this.wifiList, linkedInfo: this.linkedInfo })
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor('#F5F5F5')
  }

  aboutToDisappear() {
    wifi.off('wifiConnectionChange')
    wifi.off('wifiStateChange')
  }
}