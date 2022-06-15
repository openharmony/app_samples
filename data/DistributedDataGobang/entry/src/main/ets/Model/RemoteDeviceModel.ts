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

let subscribeId: number = 100
const NUMBER: number = 65536
const TAG: string = 'RemoteDeviceModel'


export class RemoteDeviceModel {
  public deviceList: Array<deviceManager.DeviceInfo> = []
  public discoverList: Array<deviceManager.DeviceInfo> = []
  public callback: () => void
  public authCallback: () => void
  public deviceManager: deviceManager.DeviceManager

  constructor() {
  }

  registerDeviceListCallback(callback) {
    if (typeof (this.deviceManager) !== 'undefined') {
      this.registerDeviceListCallbackImplement(callback)
      return
    }
    logger.info(TAG, `[RemoteDeviceModel] deviceManager.createDeviceManager begin`)
    deviceManager.createDeviceManager("ohos.samples.distributeddatagobang", (error, value) => {
      if (error) {
        logger.info(TAG, `[RemoteDeviceModel] createDeviceManager failed.`)
        return
      }
      this.deviceManager = value
      this.registerDeviceListCallbackImplement(callback)
      logger.info(TAG, `[RemoteDeviceModel] createDeviceManager callback returned, error= ${error},value= ${value}`)
    })
    logger.info(TAG, `[RemoteDeviceModel] deviceManager.createDeviceManager end`)
  }

  deviceStateChangeActionOnline(device) {
    this.deviceList[this.deviceList.length] = device
    logger.info(TAG, `[RemoteDeviceModel] online, device list= ${JSON.stringify(this.deviceList)}`)
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
    logger.info(TAG, `[RemoteDeviceModel] ready, device list= ${JSON.stringify(device)}`)
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
    logger.info(TAG, `[RemoteDeviceModel] offline, device list= ${JSON.stringify(this.deviceList)}`)
    this.callback()
  }

  registerDeviceListCallbackImplement(callback) {
    logger.info(TAG, `[RemoteDeviceModel] registerDeviceListCallback`)
    this.callback = callback
    if (this.deviceManager === undefined) {
      logger.info(TAG, `[RemoteDeviceModel] deviceManager has not initialized`)
      this.callback()
      return
    }
    logger.info(TAG, `[RemoteDeviceModel] getTrustedDeviceListSync begin`)
    let list = this.deviceManager.getTrustedDeviceListSync()
    logger.info(TAG, `[RemoteDeviceModel] getTrustedDeviceListSync end, deviceList= ${JSON.stringify(list)}`)
    if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
      this.deviceList = list
    }
    this.callback()
    logger.info(TAG, `[RemoteDeviceModel] callback finished`)
    this.deviceManager.on('deviceStateChange', (data) => {
      if (data === null) {
        return
      }
      logger.info(TAG, `[RemoteDeviceModel] deviceStateChange data= ${JSON.stringify(data)}`)
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
      logger.info(TAG, `[RemoteDeviceModel] deviceFound data= ${JSON.stringify(data)}`)
      this.deviceFound(data)
    })
    this.deviceManager.on('discoverFail', (data) => {
      logger.info(TAG, `[RemoteDeviceModel] discoverFail data= ${JSON.stringify(data)}`)
    })
    this.deviceManager.on('serviceDie', () => {
      logger.info(TAG, `[RemoteDeviceModel] serviceDie`)
    })
    this.startDeviceDiscovery()
  }

  deviceFound(data) {
    for (var i = 0;i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId === data.device.deviceId) {
        logger.info(TAG, `[RemoteDeviceModel] device founded ignored`)
        return
      }
    }
    this.discoverList[this.discoverList.length] = data.device
    logger.info(TAG, `[RemoteDeviceModel] deviceFound self.discoverList= ${this.discoverList}`)
    this.callback()
  }

  startDeviceDiscovery() {
    subscribeId = Math.floor(NUMBER * Math.random())
    let info = {
      subscribeId: subscribeId,
      mode: 0xAA,
      medium: 2,
      freq: 2,
      isSameAccount: false,
      isWakeRemote: true,
      capability: 0
    }
    logger.info(TAG, `[RemoteDeviceModel] startDeviceDiscovery ${subscribeId}`)
    this.deviceManager.startDeviceDiscovery(info)
  }

  unregisterDeviceListCallback() {
    logger.info(TAG, `[RemoteDeviceModel] stopDeviceDiscovery $subscribeId}`)
    this.deviceManager.stopDeviceDiscovery(subscribeId)
    this.deviceManager.off('deviceStateChange')
    this.deviceManager.off('deviceFound')
    this.deviceManager.off('discoverFail')
    this.deviceManager.off('serviceDie')
    this.deviceList = []
    this.discoverList = []
  }

  authenticateDevice(device, callBack) {
    logger.info(TAG, `[RemoteDeviceModel] authenticateDevice ${JSON.stringify(device)}`)
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId !== device.deviceId) {
        continue
      }
      let extraInfo = {
        'targetPkgName': 'ohos.samples.distributeddatagobang',
        'appName': 'distributeddatagobang',
        'appDescription': 'distributeddatagobang',
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
          logger.info(TAG, `[RemoteDeviceModel] authenticateDevice error: ${JSON.stringify(err)}`)
          this.authCallback = null
          return
        }
        logger.info(TAG, `[RemoteDeviceModel] authenticateDevice succeed: ${JSON.stringify(data)}`)
        this.authCallback = callBack
      })
    }
  }
}