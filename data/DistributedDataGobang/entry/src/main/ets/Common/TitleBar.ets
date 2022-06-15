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
import logger from '../Model/Logger'
import { RemoteDeviceModel } from '../Model/RemoteDeviceModel'
import { DeviceDialog } from '../Common/DeviceDialog'

const DEVICE_A: string = 'deviceA'
const EXIT: string = 'exit'
const TAG: string = 'TitleBar'

@Component
export struct TitleBar {
  @State @Watch('selectedIndexChange') selectedIndex: number = 0
  @State deviceList: Array<deviceManager.DeviceInfo> = []
  private startAbilityCallBack: (key: string) => void
  private remoteDeviceModel: RemoteDeviceModel | null = null
  @Link isDistributed: boolean
  @Link dialogShow: boolean
  private deviceFlag: string = 'A'
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: DeviceDialog({ deviceList: this.deviceList, selectedIndex: $selectedIndex }),
    autoCancel: true,
    alignment: DialogAlignment.Center
  })

  clearSelectState() {
    this.deviceList = []
    this.dialogShow = false
    this.dialogController.close()
  }

  selectDevice() {
    logger.info(TAG, `[TitleBar] start ability ......`)
    this.isDistributed = true
    if (this.remoteDeviceModel === null || this.remoteDeviceModel.discoverList.length <= 0) {
      logger.info(TAG, `[TitleBar] continue unauthed device: ${JSON.stringify(this.deviceList)}`)
      this.startAbility(this.deviceList[this.selectedIndex].deviceId)
      this.clearSelectState()
      return
    }
    logger.info(TAG, `[TitleBar] start ability1, needAuth`)
    this.remoteDeviceModel.authenticateDevice(this.deviceList[this.selectedIndex], () => {
      logger.info(TAG, `[TitleBar] auth and online finished`)
      for (let i = 0; i < this.remoteDeviceModel.deviceList.length; i++) {
        if (this.remoteDeviceModel.deviceList[i].deviceName === this.deviceList[this.selectedIndex].deviceName) {
          this.startAbility(this.remoteDeviceModel.deviceList[i].deviceId)
        }
      }
    })
    logger.info(TAG, `[TitleBar] start ability2 ......`)
    this.clearSelectState()
  }

  selectedIndexChange() {
    logger.info(TAG, `[TitleBar] selectedIndexChange`)
    if (this.selectedIndex === 0) {
      logger.info(TAG, `[TitleBar] stop ability`)
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
    logger.info(TAG, `[TitleBar] startAbility deviceId: ${deviceId}`)
    globalThis.abilityContext.startAbility({
      bundleName: 'ohos.samples.distributeddatagobang',
      abilityName: 'MainAbility',
      deviceId: deviceId,
      parameters: {
        isB: 'B',
        isA: 'A'
      }
    }).then((data) => {
      logger.info(TAG, `[TitleBar] start ability finished: ${JSON.stringify(data)}`)
      this.startAbilityCallBack(DEVICE_A)
    })
  }

  showDialog() {
    this.dialogShow = true
    this.deviceList = []
    this.remoteDeviceModel.registerDeviceListCallback(() => {
      logger.info(TAG, `[TitleBar] registerDeviceListCallback, callback entered`)
      this.deviceList.push({
        deviceId: '0',
        deviceName: '本机(结束协同)',
        deviceType: 0,
        networkId: ''
      })
      let deviceTempList = this.remoteDeviceModel.discoverList.length > 0 ? this.remoteDeviceModel.discoverList : this.remoteDeviceModel.deviceList
      for (let i = 0; i < deviceTempList.length; i++) {
        this.deviceList.push(deviceTempList[i])
      }
    })
    this.dialogController.open()
  }

  build() {
    Row() {
      Image($r('app.media.ic_back'))
        .height('80%')
        .margin({ left: 32 })
        .width(32)
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          globalThis.abilityContext.terminateSelf()
        })
      Blank().layoutWeight(1)
      if (this.deviceFlag === 'A') {
        Image($r('app.media.ic_hop'))
          .height('80%')
          .margin({ right: 32 })
          .width(32)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.showDialog()
          })
      }
    }
    .width('100%')
    .height('8%')
    .constraintSize({ minHeight: 50 })
    .alignItems(VerticalAlign.Center)
    .position({ x: 0, y: 0 })
  }
}
