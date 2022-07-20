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
import { distributedConst } from '../data/DistributedConst'

let SUBSCRIBE_ID: number = 100
const TAG: string = 'RemoteDeviceModel'

class RemoteDeviceModel {
  public deviceList: Array<deviceManager.DeviceInfo> = []
  public discoverList: Array<deviceManager.DeviceInfo> = []
  public registerCallback: () => void | null = null
  public authCallback: (device: deviceManager.DeviceInfo) => void = null
  public deviceManager: deviceManager.DeviceManager | undefined = undefined

  registerDeviceListCallback(callback) {
    if (typeof (this.deviceManager) !== 'undefined') {
      this.registerDeviceListCallbackImplement(callback)
      return
    }
    Logger.info(TAG, `deviceManager.createDeviceManager begin`)
    deviceManager.createDeviceManager(distributedConst.BUNDLE, (error, value) => {
      if (error) {
        Logger.error(TAG, `createDeviceManager failed.`)
        return
      }
      this.deviceManager = value
      this.registerDeviceListCallbackImplement(callback)
      Logger.info(TAG, `createDeviceManager callback returned,value=${value}`)
    })
    Logger.info(TAG, `deviceManager.createDeviceManager end`)
  }

  deviceStateChangeActionOnline(device) {
    this.deviceList[this.deviceList.length] = device
    Logger.info(TAG, `online, device list=${JSON.stringify(this.deviceList)}`)
    if (this.authCallback !== null) {
      this.authCallback(device)
      this.authCallback = null
    }
  }

  deviceStateChangeActionReady(device) {
    if (this.deviceList.length <= 0) {
      this.registerCallback()
      return
    }
    let list = new Array()
    for (let i = 0; i < this.deviceList.length; i++) {
      if (this.deviceList[i].deviceId !== device.deviceId) {
        list[i] = device
      }
    }
    this.deviceList = list
    Logger.info(TAG, `ready, device list=${JSON.stringify(this.deviceList)}`)
    this.registerCallback()
  }

  deviceStateChangeActionOffline(device) {
    if (this.deviceList.length <= 0) {
      this.registerCallback()
      return
    }
    for (let j = 0; j < this.deviceList.length; j++) {
      if (this.deviceList[j ].deviceId === device.deviceId) {
        this.deviceList[j] = device
        break
      }
    }
    Logger.info(TAG, `offline, device list=${JSON.stringify(this.deviceList)}`)
  }

  getLocalDevice() {
    let deviceInfo: deviceManager.DeviceInfo = this.deviceManager.getLocalDeviceInfoSync()
    Logger.info(TAG, `local deviceInfo=${JSON.stringify(deviceInfo)}`)
    return deviceInfo.deviceId
  }

  registerDeviceListCallbackImplement(callback) {
    Logger.info(TAG, `registerDeviceListCallback`)
    this.registerCallback = callback
    if (this.deviceManager === undefined) {
      Logger.error(TAG, `deviceManager has not initialized`)
      this.registerCallback()
      return
    }
    let list = this.deviceManager.getTrustedDeviceListSync()
    Logger.info(TAG, `getTrustedDeviceListSync end, deviceList=${JSON.stringify(list)}`)
    if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
      this.deviceList = list
    }
    this.registerCallback()
    this.deviceManager.on('deviceStateChange', (data) => {
      if (data === null) {
        return
      }
      Logger.info(TAG, `[RemoteDeviceModel] deviceStateChange data= ${JSON.stringify(data)}`)
      switch (data.action) {
        case deviceManager.DeviceStateChangeAction.ONLINE:
          this.deviceStateChangeActionOnline(data.device)
          break;
        case deviceManager.DeviceStateChangeAction.READY:
          this.deviceStateChangeActionReady(data.device)
          break;
        case deviceManager.DeviceStateChangeAction.OFFLINE:
        case deviceManager.DeviceStateChangeAction.CHANGE:
          this.deviceStateChangeActionOffline(data.device)
          break
        default:
          break
      }
    })
    this.deviceManager.on('deviceFound', (data) => {
      if (data === null) {
        return
      }
      Logger.info(TAG, `deviceFound data=${JSON.stringify(data)}`)
      this.deviceFound(data)
    })
    this.deviceManager.on('discoverFail', (data) => {
      Logger.info(TAG, `discoverFail data=${JSON.stringify(data)}`)
    })
    this.deviceManager.on('serviceDie', () => {
      Logger.info(TAG, `serviceDie`)
    })
    this.startDeviceDiscovery()
  }

  deviceFound(data) {
    for (let i = 0;i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId === data.device.deviceId) {
        Logger.info(TAG, `device founded ignored`)
        return
      }
    }
    this.discoverList[this.discoverList.length] = data.device
    Logger.info(TAG, `deviceFound self.discoverList=${this.discoverList}`)
    this.registerCallback()
  }

  startDeviceDiscovery() {
    // 生成发现标识，随机数确保每次调用发现接口的标识不一致,且SUBSCRIBE_ID在0到65536之间
    SUBSCRIBE_ID = Math.floor(distributedConst.SUBSCRIBE_NUMBER * Math.random())
    let info = {
      subscribeId: SUBSCRIBE_ID, // 发现标识，用于标识不同的发现周期
      mode: 0xAA, // 主动模式
      medium: 2, // WiFi发现类型
      freq: 2, // 高频率
      isSameAccount: false, // 是否同账号
      isWakeRemote: true, // 是否唤醒设备
      capability: 0 // DDMP能力
    }
    Logger.info(TAG, `startDeviceDiscovery${SUBSCRIBE_ID}`)
    // 当有设备发现时，通过deviceFound回调通知给应用程序
    this.deviceManager.startDeviceDiscovery(info)
  }

  unregisterDeviceListCallback() {
    Logger.info(TAG, `stopDeviceDiscovery${SUBSCRIBE_ID}`)
    this.deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID);
    this.deviceManager.off('deviceStateChange')
    this.deviceManager.off('deviceFound')
    this.deviceManager.off('discoverFail')
    this.deviceManager.off('serviceDie')
    this.deviceList = []
    this.discoverList = []
  }

  authenticateDevice(device, callBack) {
    Logger.info(TAG, `authenticateDevice${JSON.stringify(device)}`)
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId !== device.deviceId) {
        continue
      }
      let extraInfo = {
        'targetPkgName': distributedConst.BUNDLE,
        'appName': 'Distributed object',
        'appDescription': 'Distributed object',
        'business': '0'
      }
      let authParam = {
        'authType': 1,
        'appIcon': '',
        'appThumbnail': '',
        'extraInfo': extraInfo
      }
      this.deviceManager.authenticateDevice(device, authParam, (err, data) => {
        if (err) {
          Logger.info(TAG, `[RemoteDeviceModel] authenticateDevice error: ${JSON.stringify(err)}`)
        }
        Logger.info(`[RemoteDeviceModel] authenticateDevice succeed:${JSON.stringify(data)}`)
        this.authCallback = callBack
      })
    }
  }
}

export default new RemoteDeviceModel()

