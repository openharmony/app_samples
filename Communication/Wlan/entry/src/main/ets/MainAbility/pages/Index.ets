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
import featureAbility from '@ohos.ability.featureAbility'
import wifi from '@ohos.wifi'
import { AvailableWifi } from '../component/AvailableWifi'
import Logger from '../model/Logger'
import { TitleBar } from '../component/TitleBar'
import { WifiModel } from '../model/WifiModel'

const TAG = 'Index'
const PERMISSION_NAME: string = 'ohos.permission.LOCATION'

@Entry
@Component
struct Index {
  private wifiModel: WifiModel = new WifiModel()
  private linkedInfo: any = {
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
        setTimeout(() => {
          this.scan()
        }, 2000)
      }
    })
  }

  getLinkedInfo() {
    wifi.getLinkedInfo((err, linkedInfo) => {
      if (err) {
        Logger.error(TAG, `getLinkedInfo err: ${JSON.stringify(err)}`)
        return
      }
      Logger.log(TAG, `linkedInfo: ${JSON.stringify(linkedInfo)}`)
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
      this.isLinked = true
      this.linkedInfo = linkedInfo
    })
  }

  addListener() {
    wifi.on('wifiConnectionChange', state => {
      Logger.log(TAG, `wifiConnectionChange: ${state}`)
      this.getLinkedInfo()
    })
    wifi.on('wifiStateChange', state => {
      Logger.log(TAG, `wifiStateLisener state: ${state}`)
      this.wifiList = []
      if (state === 1) { // 1: wifi is enable, 0:wifi is disable
        wifi.scan()
        this.scan()
      }
    })
  }

  aboutToAppear() {
    let context = featureAbility.getContext()
    context.requestPermissionsFromUser([PERMISSION_NAME], 3, function (result) {
      Logger.log(TAG, `grantPermission,requestPermissionsFromUser,result.requestCode: ${result}`)
    })
    if (wifi.isWifiActive()) {
      Logger.log(TAG, 'wifi is active')
      this.isSwitchOn = true
      wifi.scan()
      this.scan()
      this.getLinkedInfo()
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
              Logger.log(TAG, `wifi swtich is: ${isOn}`)
              this.wifiList = []
              if (isOn) {
                this.isSwitchOn = true
                wifi.enableWifi()
                wifi.scan()
                this.scan()
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