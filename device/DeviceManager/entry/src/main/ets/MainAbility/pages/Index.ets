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

import { DeviceView } from '../components/DeviceView'
import { RemoteDeviceModel } from '../model/RemoteDeviceModel'
import { DeviceDataModel } from '../model/DeviceDataModel'

@Entry
@Component
struct Index {
  @State deviceList: Array<DeviceDataModel> = []
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()

  refreshDevice() {
    let self = this
    this.remoteDeviceModel.registerDeviceListCallback(() => {
      console.info('[DeviceMnager.IndexPage] registerDeviceListCallback, callback entered')
      self.deviceList = []
      let deviceTempList = self.remoteDeviceModel.discoverList
      for (let i = 0; i < deviceTempList.length; i++) {
        console.info(`[DeviceMnager.IndexPage] discoverList device ${i}/${deviceTempList.length}` +
        `deviceId=${deviceTempList[i].deviceId}, deviceName=${deviceTempList[i].deviceName}` +
        `deviceType=${deviceTempList[i].deviceType}`)
        self.deviceList.push({
          deviceId: deviceTempList[i].deviceId,
          deviceName: deviceTempList[i].deviceName,
          deviceType: deviceTempList[i].deviceType,
          state: 'discover'
        })
      }
      deviceTempList = self.remoteDeviceModel.deviceList
      for (let i = 0; i < deviceTempList.length; i++) {
        console.info(`[DeviceMnager.IndexPage] devicelist device ${i}/${deviceTempList.length}` +
        `deviceId=${deviceTempList[i].deviceId}, deviceName=${deviceTempList[i].deviceName}` +
        `deviceType=${deviceTempList[i].deviceType}`)
        self.deviceList.push({
          deviceId: deviceTempList[i].deviceId,
          deviceName: deviceTempList[i].deviceName,
          deviceType: deviceTempList[i].deviceType,
          state: 'online'
        })
      }
    })
  }

  aboutToAppear() {
    this.refreshDevice()
  }

  build() {
    Column() {
      Row() {
        Text($r("app.string.app_name"))
          .fontColor(Color.White)
          .fontSize(20)
      }
      .size({ width: '100%', height: 50 })
      .padding({ left: 15 })
      .backgroundColor('#0D9FFB')

      List() {
        ForEach(this.deviceList, (item, index) => {
          ListItem() {
            DeviceView({ device: item })
          }
          .onClick(() => {
            let self = this
            if (item.state === 'discover') {
              this.remoteDeviceModel.authenticateDevice(item)
            }
          })
        }, item => JSON.stringify(item))
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 10, endMargin: 10 })
    }
  }
}