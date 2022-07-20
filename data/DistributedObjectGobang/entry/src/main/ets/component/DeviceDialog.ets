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

import deviceManager from '@ohos.distributedHardware.deviceManager'
import Logger from '../data/Logger'
import RemoteDeviceModel from '../data/RemoteDeviceModel'
import { distributedConst } from '../data/DistributedConst'

const TAG: string = 'DeviceDialog'

@CustomDialog
export struct DeviceDialog {
  private customDialogController?: CustomDialogController
  private selectedIndex: number = 0
  @State devices: Array<deviceManager.DeviceInfo> = []

  build() {
    Column() {
      Text($r('app.string.check_device'))
        .fontSize(20)
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
      List() {
        ForEach(this.devices, (item, index) => {
          ListItem() {
            Row() {
              Text(item.deviceName)
                .fontSize(20)
                .width('90%')
                .fontColor(Color.Black)
              Image(index === this.selectedIndex ? $r('app.media.checked') : $r('app.media.uncheck'))
                .width('8%')
                .objectFit(ImageFit.Contain)
            }
            .height(55)
            .onClick(() => {
              this.selectedIndex = index
              this.onSelectedIndexChange(this.selectedIndex)
            })
          }
        }, item => item.deviceName)
      }

      Button() {
        Text($r('app.string.cancel'))
          .fontColor('#0D9FFB')
          .width('90%')
          .textAlign(TextAlign.Center)
          .fontSize(20)
      }
      .type(ButtonType.Capsule)
      .backgroundColor(Color.White)
      .onClick(() => {
        this.customDialogController.close()
      })
    }
    .backgroundColor(Color.White)
    .border({ color: Color.White, radius: 20 })
    .padding(10)
  }

  /**
   * 选择需要拉起的设备，设备为本机
   *
   * @param selectedIndex 设备的索引
   */
  async onSelectedIndexChange(selectedIndex) {
    Logger.info(TAG, `selectedIndexChange,selectedIndex=${selectedIndex}`)
    if (selectedIndex === 0 && this.devices.length > this.selectedIndex) {
      Logger.info(TAG, `stop sync`)
      await globalThis.abilityContext.startAbility({
        bundleName: distributedConst.BUNDLE,
        abilityName: distributedConst.ABILITY,
        deviceId: this.devices[this.selectedIndex].deviceId,
      })
      this.customDialogController.close()
      this.devices = []
      return
    }
    this.selectDevice()
  }

  /**
   * 选择的设备非本机时拉起设备
   */
  selectDevice() {
    Logger.info(TAG, `start ability ......`)
    if (RemoteDeviceModel === null || RemoteDeviceModel.discoverList.length <= 0) {
      Logger.info(TAG, `start ability device:${JSON.stringify(this.devices)}`)
      this.startAbility(this.devices[this.selectedIndex].deviceId)
      this.clearSelectState()
      return
    }
    RemoteDeviceModel.authenticateDevice(this.devices[this.selectedIndex], (device) => {
      Logger.info(TAG, `auth and online finished`)
      this.startAbility(device.deviceId)
    })
    this.clearSelectState()
  }

  async startAbility(deviceId) {
    let localDevice = RemoteDeviceModel.getLocalDevice()
    Logger.info(TAG, `startAbility localDevice:${localDevice}`)
    await globalThis.abilityContext.startAbility(
      {
        bundleName: distributedConst.BUNDLE,
        abilityName: distributedConst.ABILITY,
        deviceId: deviceId,
      })
  }

  clearSelectState() {
    this.devices = []
    this.customDialogController.close()
    this.customDialogController = null
  }
}