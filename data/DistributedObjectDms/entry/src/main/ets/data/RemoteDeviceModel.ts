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
import { dmsConst } from '../data/DmsConst'
import Logger from '../data/Logger'

let SUBSCRIBE_ID: number = 100
const TAG: string = 'RemoteDeviceModel'

export default class RemoteDeviceModel {
  public devices: Array<deviceManager.DeviceInfo> = []
  public discovers: Array<deviceManager.DeviceInfo> = []
  public registerCallback: () => void = null
  public authCallback: () => void = null
  public deviceManager: deviceManager.DeviceManager | undefined = undefined

  constructor() {
  }

  registerDeviceCallback(callback) {
    Logger.info(TAG, `registerDeviceCallback start`)
    if (typeof (this.deviceManager) !== 'undefined') {
      Logger.info(TAG, `registerDeviceCallback undefined`)
      this.registerDeviceCallbackImplement(callback)
      return
    }
    Logger.info(TAG, `deviceManager.createDeviceManager begin`)
    deviceManager.createDeviceManager(dmsConst.BUNDLE_NAME, (error, value) => {
      if (error) {
        Logger.info(TAG, `createDeviceManager failed`)
        return
      }
      this.deviceManager = value
      this.registerDeviceCallbackImplement(callback)
      Logger.info(TAG, `createDeviceManager callback returned, error= ${error} value= ${JSON.stringify(value)}`)
    })
    Logger.info(TAG, `deviceManager.createDeviceManager end`)
  }

  deviceStateChangeActionOnline(device) {
    this.devices[this.devices.length] = device
    Logger.info(TAG, `online device list= ${JSON.stringify(this.devices)}`)
    this.registerCallback()
    if (this.authCallback !== null) {
      this.authCallback()
      this.authCallback = null
    }
  }

  deviceStateChangeActionReady(device) {
    if (this.devices.length <= 0) {
      this.registerCallback()
      return
    }
    let list = new Array()
    for (let i = 0; i < this.devices.length; i++) {
      if (this.devices[i].deviceId !== device.deviceId) {
        list[i] = device
      }
    }
    this.devices = list
    Logger.info(TAG, `ready device list= ${JSON.stringify(device)}`)
    this.registerCallback()
  }

  deviceStateChangeActionOffline(device) {
    if (this.devices.length <= 0) {
      this.registerCallback()
      return
    }
    for (let j = 0; j < this.devices.length; j++) {
      if (this.devices[j ].deviceId === device.deviceId) {
        this.devices[j] = device
        break
      }
    }
    Logger.info(TAG, `offline device list= ${JSON.stringify(this.devices)}`)
    this.registerCallback()
  }

  registerDeviceCallbackImplement(callback) {
    Logger.info(TAG, `registerDeviceCallbackImplement`)
    this.registerCallback = callback
    if (this.deviceManager === undefined) {
      Logger.error(TAG, `deviceManager has not initialized`)
      this.registerCallback()
      return
    }
    Logger.info(TAG, `getTrusteddevicesSync begin`)
    let list = this.deviceManager.getTrustedDeviceListSync()
    Logger.info(TAG, `getTrusteddevicesSync end, devices= ${JSON.stringify(list)}`)
    if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
      this.devices = list
    }
    this.registerCallback()
    Logger.info(TAG, `callback finished devices = ${JSON.stringify(this.devices)}`)

    this.deviceManager.on('deviceStateChange', (data) => {
      if (data === null) {
        return
      }
      Logger.info(TAG, `deviceStateChange data= ${JSON.stringify(data)}`)
      switch (data.action) {
        case deviceManager.DeviceStateChangeAction.ONLINE:
          this.deviceStateChangeActionOnline(data.device)
          break
        case deviceManager.DeviceStateChangeAction.READY:
          this.deviceStateChangeActionReady(data.device)
          break
        case deviceManager.DeviceStateChangeAction.OFFLINE:
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
      Logger.info(TAG, `deviceFound data= ${JSON.stringify(data)}`)
      this.deviceFound(data)
    })

    this.deviceManager.on('discoverFail', (data) => {
      Logger.info(TAG, `discoverFail ${JSON.stringify(data)}`)
    })

    this.deviceManager.on('serviceDie', () => {
      Logger.error(TAG, `serviceDie`)
    })

    this.startDeviceDiscovery()
  }

  deviceFound(data) {
    for (let i = 0;i < this.discovers.length; i++) {
      if (this.discovers[i].deviceId === data.device.deviceId) {
        Logger.info(TAG, `device founded ignored`)
        return
      }
    }
    this.discovers[this.discovers.length] = data.device
    Logger.info(TAG, `deviceFound discovers= ${JSON.stringify(this.discovers)}`)
    this.registerCallback()
  }

  startDeviceDiscovery() {
    // 生成发现标识，随机数确保每次调用发现接口的标识不一致,且SUBSCRIBE_ID在0到65536之间
    SUBSCRIBE_ID = Math.floor(dmsConst.SUBSCRIBE_NUMBER * Math.random())
    let info = {
      subscribeId: SUBSCRIBE_ID, // 发现标识，用于标识不同的发现周期
      mode: 0xAA, // 主动模式
      medium: 2, // WiFi发现类型
      freq: 2, // 高频率
      isSameAccount: false, // 是否同账号
      isWakeRemote: true, // 是否唤醒设备
      capability: 0 // DDMP能力
    }
    Logger.info(TAG, `startDeviceDiscovery ${SUBSCRIBE_ID}`)
    // 当有设备发现时，通过deviceFound回调通知给应用程序
    this.deviceManager.startDeviceDiscovery(info)
  }

  unregisterDeviceCallback() {
    Logger.info(TAG, `stopDeviceDiscovery ${SUBSCRIBE_ID}`)
    this.deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID)
    this.deviceManager.off('deviceStateChange')
    this.deviceManager.off('deviceFound')
    this.deviceManager.off('discoverFail')
    this.deviceManager.off('serviceDie')
    this.devices = []
    this.discovers = []
  }

  authenticateDevice(device, callBack) {
    Logger.info(TAG, `authenticateDevice device: ${JSON.stringify(device)} ,discovers: ${this.discovers}`)
    for (let i = 0; i < this.discovers.length; i++) {
      if (this.discovers[i].deviceId !== device.deviceId) {
        continue
      }
      let extraInfo = {
        'targetPkgName': dmsConst.BUNDLE_NAME,
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
          Logger.info(TAG, `authenticateDevice error: ${JSON.stringify(err)}`)
          this.authCallback = null
          return
        }
        Logger.info(TAG, `authenticateDevice succeed: ${JSON.stringify(data)}`)
        this.authCallback = callBack
      })
    }
  }
}