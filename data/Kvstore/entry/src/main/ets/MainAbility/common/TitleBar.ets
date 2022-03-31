/*
 * Copyright (c) 2020 Huawei Device Co., Ltd.
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
import { DeviceDialog } from '../common/Dialog'
import { RemoteDeviceModel } from '../model/RemoteDeviceModel'
import { DeviceDataModel } from '../model/DeviceDataModel'

const NOTES_CHANGE = 'notesChange'
const EXIT = 'exit'

@Component
export struct TitleBar {
  private selectedIndex: number = 0
  private startAbilityCallBack = null
  private remoteDeviceModel: RemoteDeviceModel = null
  private dialogController: CustomDialogController = null
  @State deviceList: Array<DeviceDataModel> = []
  @Link isDistributed: boolean
  @Link dialogShow: boolean

  clearSelectState() {
    this.deviceList = []
    this.dialogShow = false
    this.dialogController.close()
  }

  selectDevice() {
    console.log('KvStore[IndexPage] start ability ......')
    this.isDistributed = true
    if (this.remoteDeviceModel === null || this.remoteDeviceModel.discoverList.length <= 0) {
      console.log('KvStore[IndexPage] continue unauthed device:' + JSON.stringify(this.deviceList))
      this.startAbility(this.deviceList[this.selectedIndex].deviceId)
      this.clearSelectState()
      return
    }
    console.log('KvStore[IndexPage] start ability1, needAuth：')
    this.remoteDeviceModel.authenticateDevice(this.deviceList[this.selectedIndex], () => {
      console.log("KvStore[IndexPage] auth and online finished")
      for (var i = 0; i < this.remoteDeviceModel.deviceList.length; i++) {
        if (this.remoteDeviceModel.deviceList[i].deviceName === this.deviceList[this.selectedIndex].deviceName) {
          this.startAbility(this.remoteDeviceModel.deviceList[i].deviceId)
        }
      }
    })
    console.log('KvStore[IndexPage] start ability2 ......')
    this.clearSelectState()
  }

  handleSelectDevice = (index) => {
    console.log('KvStore[IndexPage] selectedIndexChange')
    this.selectedIndex = index
    if (this.selectedIndex == 0) {
      console.log("KvStore[IndexPage] stop ability")
      this.dialogController.close()
      this.startAbilityCallBack(EXIT)
      this.isDistributed = false
      this.deviceList = []
      this.dialogShow = false
      return
    }
    this.selectDevice()
  }

  startAbility(deviceId) {
    console.log('KvStore[IndexPage] startAbility deviceId:' + deviceId)
    featureAbility.startAbility({
      want: {
        bundleName: 'ohos.samples.etskvstore',
        abilityName: 'ohos.samples.etskvstore.MainAbility',
        deviceId: deviceId,
        parameters: {
          isFA: 'FA'
        }
      }
    }).then((data) => {
      console.log('KvStore[IndexPage] start ability finished:' + JSON.stringify(data))
      this.startAbilityCallBack(NOTES_CHANGE)
    });
  }

  showDialog() {
    this.dialogShow = true
    this.deviceList = [];
    this.remoteDeviceModel.registerDeviceListCallback(() => {
      console.info('KvStore[IndexPage] registerDeviceListCallback, callback entered')
      this.deviceList.push({
        deviceId: '0',
        deviceName: 'Local device',
        deviceType: 0,
        checked: false
      })
      var deviceTempList = this.remoteDeviceModel.discoverList.length > 0 ? this.remoteDeviceModel.discoverList : this.remoteDeviceModel.deviceList;
      for (var i = 0; i < deviceTempList.length; i++) {
        console.info('KvStore[IndexPage] device ' + i + '/' + deviceTempList.length +
        ' deviceId=' + deviceTempList[i].deviceId + ' deviceName=' + deviceTempList[i].deviceName
        + ' deviceType=' + deviceTempList[i].deviceType)
        this.deviceList.push({
          deviceId: deviceTempList[i].deviceId,
          deviceName: deviceTempList[i].deviceName,
          deviceType: deviceTempList[i].deviceType,
          checked: (this.selectedIndex === i)
        })
      }
    })
    if (this.dialogController === null) {
      this.dialogController = new CustomDialogController({
        builder: DeviceDialog({
          deviceList: this.deviceList,
          selectedIndex: this.selectedIndex,
          handleSelectDevice: this.handleSelectDevice
        }),
        autoCancel: true
      })
    }
    this.dialogController.open()
  }

  build() {
    Row() {
      Text($r("app.string.title"))
        .width('82%')
        .fontColor(Color.White)
        .fontSize(20)
      Blank()
      Button() {
        Image($r('app.media.ic_hop_normal'))
          .width(70).height(40)
          .objectFit(ImageFit.Contain)
      }
      .type(ButtonType.Normal)
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        console.info('KvStore[IndexPage] showDialog start')
        this.showDialog()
      })
    }
    .height('8%')
    .width('100%')
    .constraintSize({ minHeight: 70 })
    .backgroundColor('#0D9FFB')
    .padding({ left: 15, right: 15 })
  }
}