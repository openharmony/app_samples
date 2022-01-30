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

import wifi from '@ohos.wifi';
import { WifiModel } from '../model/wifiModel'
import { TitleBar } from '../component/titleBar'
import { AvailableWifi } from '../component/availableWifi'

const TAG = '[eTSWiFi]'
let self = null

@Entry
@Component
struct Index {
  private wifiModel: WifiModel = new WifiModel()
  private linkedInfo: any = { ssid: "", bssid: "", networkId: 0, rssi: 0, band: 0 }
  @State wifiList: Array<any> = []
  @State isLinked: boolean = false
  @State isSwitchOn: boolean = false

  scan() {
    this.wifiModel.getScanInfos((result) => {
      if (self.isSwitchOn) {
        self.wifiList = result
        if (result.length === 0) {
          setTimeout(() => {
            self.scan()
          }, 1000)
        }
      }
    })
  }

  getLinkedInfo() {
    wifi.getLinkedInfo((linkedInfo) => {
      console.info(`${TAG} linkedInfo ${JSON.stringify(linkedInfo)}`)
      if (linkedInfo === null) {
        self.isLinked = false
        self.linkedInfo = { ssid: "", bssid: "", networkId: 0, rssi: 0, band: 0 }
        return
      }
      self.linkedInfo = linkedInfo
      self.isLinked = self.linkedInfo.bssid.length > 0 ? true : false
    })
  }

  addListener() {
    this.wifiModel.addConnectListener((state) => {
      console.info(`${TAG}  connectLisener state=' ${state}`)
      if (state === 1 || state === 4) {
        self.isLinked = true
        self.getLinkedInfo()
        return
      }
      self.isLinked = false
    })
    this.wifiModel.addWifiStateListener((state) => {
      console.info(`${TAG}  wifiStateLisener state=' ${state}`)
      self.wifiList = []
      if (state === 2 || state === 3) {
        self.scan()
      }
    })
  }

  aboutToAppear() {
    self = this
    if (wifi.isWifiActive()) {
      console.info(`${TAG}  wifi active`)
      this.isSwitchOn = true
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
              console.info(`${TAG} wifi swtich is ${isOn}`)
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
}