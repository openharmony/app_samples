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
import app from '@system.app'
import deviceManager from '@ohos.distributedHardware.deviceManager'
import featureAbility from '@ohos.ability.featureAbility'
import Logger from '../model/Logger'
import { DeviceDialog } from '../common/DeviceDialog'
import { RemoteDeviceModel } from '../model/RemoteDeviceModel'

const TAG = 'TitleBar'
const DATA_CHANGE = 'dataChange'
const EXIT = 'exit'

@Component
export struct TitleBar {
  @Prop isLand: boolean
  @State selectedIndex: number = 0
  @State deviceList: Array<deviceManager.DeviceInfo> = []
  private startAbilityCallBack: (key) => void
  private remoteDeviceModel: RemoteDeviceModel = null
  @Link isDistributed: boolean
  @Link dialogShow: boolean
  private dialogController: CustomDialogController = null

  clearSelectState() {
    this.deviceList = []
    this.dialogShow = false
    this.dialogController.close()
  }

  selectDevice() {
    Logger.info(TAG, 'start ability ......')
    this.isDistributed = true
    if (this.remoteDeviceModel === null || this.remoteDeviceModel.discoverList.length <= 0) {
      Logger.info(TAG, `continue unauthed device: ${JSON.stringify(this.deviceList)}`)
      this.startAbility(this.deviceList[this.selectedIndex].deviceId)
      this.clearSelectState()
      return
    }
    Logger.info(TAG, 'start ability1, needAuth：')
    this.remoteDeviceModel.authenticateDevice(this.deviceList[this.selectedIndex], () => {
      Logger.info(TAG, 'auth and online finished')
      for (var i = 0; i < this.remoteDeviceModel.deviceList.length; i++) {
        if (this.remoteDeviceModel.deviceList[i].deviceName === this.deviceList[this.selectedIndex].deviceName) {
          this.startAbility(this.remoteDeviceModel.deviceList[i].deviceId)
        }
      }
    })
    Logger.info(TAG, 'start ability2 ......')
    this.clearSelectState()
  }

  onSelectedIndexChange = (index: number) => {
    Logger.info(TAG, 'selectedIndexChange')
    this.selectedIndex = index
    if (this.selectedIndex === 0) {
      Logger.info(TAG, 'stop ability')
      this.startAbilityCallBack(EXIT)
      this.isDistributed = false
      this.deviceList = []
      this.dialogController.close()
      this.dialogShow = false
      return
    }
    this.selectDevice()
  }

  startAbility(deviceId) {
    Logger.info(TAG, `startAbility deviceId: ${deviceId}`)
    featureAbility.startAbility({
      want: {
        bundleName: 'ohos.samples.DistributeCalc',
        abilityName: 'ohos.samples.DistributeCalc.MainAbility',
        deviceId: deviceId,
        parameters: {
          isFA: 'FA'
        }
      }
    }).then((data) => {
      Logger.info(TAG, `start ability finished: ${JSON.stringify(data)}`)
      this.startAbilityCallBack(DATA_CHANGE)
    })
  }

  showDiainfo() {
    this.dialogShow = true
    this.deviceList = [];
    // 注册监听回调，发现设备或查找到已认证设备会弹窗显示
    this.remoteDeviceModel.registerDeviceListCallback(() => {
      Logger.info(TAG, 'registerDeviceListCallback, callback entered')
      this.deviceList.push({
        deviceId: '0',
        deviceName: '本机(结束协同)',
        deviceType: 0,
        networkId: ''
      })
      let deviceTempList = this.remoteDeviceModel.discoverList.length > 0 ? this.remoteDeviceModel.discoverList : this.remoteDeviceModel.deviceList
      for (let i = 0; i < deviceTempList.length; i++) {
        Logger.info(TAG, `device ${i}/${deviceTempList.length} deviceId= ${deviceTempList[i].deviceId},
        deviceName= ${deviceTempList[i].deviceName}, deviceType= ${deviceTempList[i].deviceType}`)
        this.deviceList.push({
          deviceId: deviceTempList[i].deviceId,
          deviceName: deviceTempList[i].deviceName,
          deviceType: deviceTempList[i].deviceType,
          networkId: deviceTempList[i].networkId
        })
      }
    })
    let alignments = DialogAlignment.Bottom
    if (this.isLand) {
      alignments = DialogAlignment.Center
    }
    if (this.dialogController === null) {
      this.dialogController = new CustomDialogController({
        builder: DeviceDialog({
          deviceList: this.deviceList,
          selectedIndex: this.selectedIndex,
          onSelectedIndexChange: this.onSelectedIndexChange
        }),
        autoCancel: true,
        alignment: alignments
      })
      this.dialogController.open()
    }
  }

  build() {
    Row() {
      Image($r("app.media.ic_back"))
        .height('60%')
        .margin({ left: 32 })
        .width(this.isLand ? '5%' : '8%')
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          app.terminate()
        })
      Blank().layoutWeight(1)
      Image($r("app.media.ic_hop"))
        .height('60%')
        .margin({ right: 32 })
        .width(this.isLand ? '5%' : '8%')
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          this.showDiainfo()
        })
    }
    .width('100%')
    .height(this.isLand ? '10%' : '8%')
    .constraintSize({ minHeight: 50 })
    .alignItems(VerticalAlign.Center)
  }
}
