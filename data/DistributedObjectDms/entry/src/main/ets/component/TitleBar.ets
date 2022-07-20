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
import DeviceDialog from '../component/DeviceDialog'
import Logger from '../data/Logger'
import RemoteDeviceModel from '../data/RemoteDeviceModel'
import { distributedDataModel } from '../data/DistributedDataModel'
import { dmsConst } from '../data/DmsConst'

const TAG: string = 'TitleBar'

@Component
export default struct TitleBar {
  @State selectedIndex: number = 0
  @Link devices: Array<deviceManager.DeviceInfo>
  @Link dialogShow: boolean
  @Link remoteDeviceModel: RemoteDeviceModel
  private customDialogController: CustomDialogController = null
  private isStart: boolean = false

  build() {
    Row() {
      Image($r('app.media.back'))
        .height(40)
        .width(40)
        .margin({ left: 10 })
        .onClick(() => {
          Logger.info(TAG, `onClick app exit`)
          distributedDataModel.distributedObject.setSessionId()
          globalThis.abilityContext.terminateSelf()
        }
        )
      Text($r('app.string.MainAbility_label'))
        .width('68%')
        .fontColor(Color.White)
        .fontSize(25)
        .margin({ left: 30 })

      if (!this.isStart) {
        Image($r('app.media.ic_hop'))
          .width(40)
          .height(40)
          .margin({ left: 15 })
          .objectFit(ImageFit.Fill)
          .backgroundColor('#0C9FFC')
          .onClick(() => {
            this.showDialogInfo()
          })
      }
    }
    .width('100%')
    .height(60)
    .backgroundColor('#0C9FFC')
    .alignItems(VerticalAlign.Center)
  }

  clearSelectState() {
    this.dialogShow = false
    this.customDialogController.close()
  }

  selectDevice() {
    Logger.info(TAG, `selectDevice  start......`)
    if (this.remoteDeviceModel === null || this.remoteDeviceModel.discovers.length <= 0) {
      Logger.info(TAG, `continue unauthed device: ${JSON.stringify(this.devices)}`)
      this.clearSelectState()
      return
    }
    Logger.info(TAG, 'selectDevice, needAuth：')
    this.remoteDeviceModel.authenticateDevice(this.devices[this.selectedIndex], () => {
      Logger.info(TAG, 'selectDevice auth and online finished')
    })
    Logger.info(TAG, 'selectDevice  end......')
    this.clearSelectState()
  }

  onSelectedIndexChange = (index: number) => {
    Logger.info(TAG, 'selectedIndexChange')
    this.selectedIndex = index
    if (this.selectedIndex === dmsConst.ZERO) {
      Logger.info(TAG, 'stop ability')
      this.devices = []
      this.customDialogController.close()
      this.dialogShow = false
      return
    }
    this.selectDevice()
  }

  showDialogInfo() {
    this.dialogShow = true
    this.devices = []
    this.remoteDeviceModel.registerDeviceCallback(() => {
      Logger.info(TAG, 'registerDeviceCallback, callback entered')
      this.devices.push({
        deviceId: '0',
        deviceName: '本机(结束协同)',
        deviceType: dmsConst.ZERO,
        networkId: ''
      })
      Logger.info(TAG, `registerDeviceCallback discovers: ${JSON.stringify(this.remoteDeviceModel.discovers)}`)
      Logger.info(TAG, `registerDeviceCallback devices: ${JSON.stringify(this.remoteDeviceModel.devices)}`)
      this.remoteDeviceModel.devices.map((item) => {
        this.devices.push(item)
      })
      this.remoteDeviceModel.discovers.map((item) => {
        this.devices.push(item)
      })

      Logger.info(TAG, `registerDeviceCallback devices--: ${JSON.stringify(this.devices)}`)
    })
    let alignments = DialogAlignment.Bottom
    if (this.customDialogController !== null) {
      this.customDialogController.close()
      this.customDialogController = null
    }
    this.customDialogController = new CustomDialogController({
      builder: DeviceDialog({
        devices: this.devices,
        selectedIndex: this.selectedIndex,
        onSelectedIndexChange: this.onSelectedIndexChange
      }),
      autoCancel: true,
      alignment: alignments
    })
    this.customDialogController.open()
  }
}
