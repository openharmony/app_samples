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
import Logger from '../model/Logger'

const TAG = 'RemoteDeviceModel'
let SUBSCRIBE_ID = 100

export class RemoteDeviceModel {
  public deviceList: Array<deviceManager.DeviceInfo> = []
  public discoverList: Array<deviceManager.DeviceInfo> = []
  private callback: () => void = null
  private authCallback: () => void = null
  private deviceManager: deviceManager.DeviceManager = undefined

  constructor() {
  }

  registerDeviceListCallback(callback) {
    if (typeof (this.deviceManager) !== 'undefined') {
      this.registerDeviceListCallbackImplement(callback)
      return
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager begin')
    deviceManager.createDeviceManager("ohos.samples.DistributeCalc", (error, value) => {
      if (error) {
        Logger.error(TAG, `createDeviceManager failed.${error}`)
        return
      }
      this.deviceManager = value
      this.registerDeviceListCallbackImplement(callback)
      Logger.info(TAG, `createDeviceManager callback returned, error= ${error} value= ${value}`)
    })
    Logger.info(TAG, 'deviceManager.createDeviceManager end')
  }

  deviceStateChangeActionOnline(device) {
    this.deviceList[this.deviceList.length] = device
    Logger.info(TAG, `online, device list= ${JSON.stringify(this.deviceList)}`)
    this.callback()
    if (this.authCallback !== null) {
      this.authCallback()
      this.authCallback = null
    }
  }

  deviceStateChangeActionReady(device) {
    if (this.deviceList.length <= 0) {
      this.callback()
      return
    }
    let list = new Array()
    for (let i = 0; i < this.deviceList.length; i++) {
      if (this.deviceList[i].deviceId !== device.deviceId) {
        list[i] = device
      }
    }
    this.deviceList = list
    Logger.info(TAG, `ready, device list= ${JSON.stringify(device)}`)
    this.callback()
  }

  deviceStateChangeActionOffline(device) {
    if (this.deviceList.length <= 0) {
      this.callback()
      return
    }
    for (let j = 0; j < this.deviceList.length; j++) {
      if (this.deviceList[j ].deviceId === device.deviceId) {
        this.deviceList[j] = device
        break
      }
    }
    Logger.info(TAG, `offline, device list= ${JSON.stringify(this.deviceList)}`)
    this.callback()
  }

  registerDeviceListCallbackImplement(callback) {
    Logger.info(TAG, 'registerDeviceListCallback')
    this.callback = callback
    if (this.deviceManager === undefined) {
      Logger.error(TAG, 'deviceManager has not initialized')
      this.callback()
      return
    }
    Logger.info(TAG, 'getTrustedDeviceListSync begin')
    let list = this.deviceManager.getTrustedDeviceListSync()
    Logger.info(TAG, `getTrustedDeviceListSync end, deviceList= ${JSON.stringify(list)}`)
    if (typeof (list) != 'undefined' && typeof (list.length) != 'undefined') {
      this.deviceList = list
    }
    this.callback()
    Logger.info(TAG, 'callback finished')
    this.deviceManager.on('deviceStateChange', (data) => {
      if (data == null) {
        return
      }
      Logger.info(TAG, `deviceStateChange data= ${JSON.stringify(data)}`)
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
      if (data == null) {
        return
      }
      Logger.info(TAG, `deviceFound data=${JSON.stringify(data)}`)
      this.deviceFound(data)
    })
    this.deviceManager.on('discoverFail', (data) => {
      Logger.info(TAG, `discoverFail data= ${JSON.stringify(data)}`)
    })
    this.deviceManager.on('serviceDie', () => {
      Logger.error(TAG, 'serviceDie')
    })
    this.startDeviceDiscovery()
  }

  deviceFound(data) {
    for (var i = 0;i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId === data.device.deviceId) {
        Logger.info(TAG, 'device founded ignored')
        return
      }
    }
    this.discoverList[this.discoverList.length] = data.device
    Logger.info(TAG, `deviceFound self.discoverList= ${this.discoverList}`)
    this.callback()
  }

  startDeviceDiscovery() {
    SUBSCRIBE_ID = Math.floor(65536 * Math.random())
    let info = {
      subscribeId: SUBSCRIBE_ID,
      mode: 0xAA,
      medium: 2,
      freq: 2,
      isSameAccount: false,
      isWakeRemote: true,
      capability: 0
    }
    Logger.info(TAG, `startDeviceDiscovery ${SUBSCRIBE_ID}`)
    this.deviceManager.startDeviceDiscovery(info)
  }

  unregisterDeviceListCallback() {
    Logger.info(TAG, `stopDeviceDiscovery ${SUBSCRIBE_ID}`)
    this.deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID);
    this.deviceManager.off('deviceStateChange')
    this.deviceManager.off('deviceFound')
    this.deviceManager.off('discoverFail')
    this.deviceManager.off('serviceDie')
    this.deviceList = []
    this.discoverList = []
  }

  authenticateDevice(device, callBack) {
    Logger.info(TAG, `authenticateDevice ${JSON.stringify(device)}`)
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId !== device.deviceId) {
        continue
      }
      let extraInfo = {
        'targetPkgName': 'ohos.samples.DistributeCalc',
        'appName': 'Distributed DistributeCalc',
        'appDescription': 'Distributed DistributeCalc',
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
          Logger.error(TAG, `authenticateDevice error: ${JSON.stringify(err)}`)
          this.authCallback = null
          return
        }
        Logger.info(TAG, `authenticateDevice succeed: ${JSON.stringify(data)}`)
        this.authCallback = callBack
      })
    }
  }
}