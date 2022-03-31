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

const SUBSCRIBE_ID = 100

export class RemoteDeviceModel {
  deviceList: Array<any> = []
  discoverList: Array<any> = []
  callback
  deviceManager

  constructor() {
  }

  registerDeviceListCallback(callback) {
    if (typeof (this.deviceManager) != 'undefined') {
      this.registerDeviceListCallbackImplement(callback)
      return
    }
    console.log('[DeviceMnager.RemoteDeviceModel] deviceManager.createDeviceManager begin')
    let self = this
    deviceManager.createDeviceManager('ohos.samples.etsdevicemanager', (error, value) => {
      if (error) {
        console.error('[DeviceMnager.RemoteDeviceModel] createDeviceManager failed.')
        return;
      }
      self.deviceManager = value
      self.registerDeviceListCallbackImplement(callback)
      console.log('[DeviceMnager.RemoteDeviceModel] createDeviceManager callback returned, error=' + error + ' value=' + value)
    });
    console.log('[DeviceMnager.RemoteDeviceModel] deviceManager.createDeviceManager end')
  }

  deviceStateChangeActionOnline(device) {
    this.deviceList[this.deviceList.length] = device
    console.info('[DeviceMnager.RemoteDeviceModel] online, device list=' + JSON.stringify(this.deviceList))
    for (let i = this.discoverList.length - 1; i >= 0; i--) {
      if (this.discoverList[i].deviceId != device.deviceId) {
        this.discoverList.splice(i, 1)
        break
      }
    }
    for (let j = 0; j < this.deviceList.length; j++) {
      if (this.deviceList[j].deviceId === device.deviceId) {
        this.deviceList[j] = device
        break
      }
    }
    this.callback()
  }

  deviceStateChangeActionOffline(device) {
    console.info('[DeviceMnager.RemoteDeviceModel] offline, this.deviceList.length=' + this.deviceList.length)
    let list = []
    for (let i = 0; i < this.deviceList.length; i++) {
      if (this.deviceList[i].deviceId !== device.deviceId) {
        list.push(device)
      }
    }
    this.deviceList = list
    console.info('[DeviceMnager.RemoteDeviceModel] offline, device list=' + JSON.stringify(this.deviceList))
    this.callback()
  }

  registerDeviceListCallbackImplement(callback) {
    console.info('[DeviceMnager.RemoteDeviceModel] registerDeviceListCallback')
    this.callback = callback
    if (this.deviceManager === undefined) {
      console.error('[DeviceMnager.RemoteDeviceModel] deviceManager has not initialized')
      this.callback()
      return
    }
    console.info('[DeviceMnager.RemoteDeviceModel] getTrustedDeviceListSync begin')
    let list = this.deviceManager.getTrustedDeviceListSync()
    console.info('[DeviceMnager.RemoteDeviceModel] getTrustedDeviceListSync end, deviceList=' + JSON.stringify(list))
    if (typeof (list) != 'undefined' && typeof (list.length) != 'undefined') {
      this.deviceList = list
    }
    this.callback()
    console.info('[DeviceMnager.RemoteDeviceModel] callback finished');
    let self = this
    this.deviceManager.on('deviceStateChange', (data) => {
      if (data == null) {
        return
      }
      console.info('[DeviceMnager.RemoteDeviceModel] deviceStateChange data=' + JSON.stringify(data))
      switch (data.action) {
        case deviceManager.DeviceStateChangeAction.ONLINE:
          console.info('[DeviceMnager.RemoteDeviceModel] deviceStateChange ONLINE')
          self.deviceStateChangeActionOnline(data.device)
          break
        case deviceManager.DeviceStateChangeAction.READY:
          console.info('[DeviceMnager.RemoteDeviceModel] deviceStateChange READY')
          break
        case deviceManager.DeviceStateChangeAction.OFFLINE:
          console.info('[DeviceMnager.RemoteDeviceModel] deviceStateChange OFFLINE')
          self.deviceStateChangeActionOffline(data.device)
          break
        default:
          break
      }
    })
    this.deviceManager.on('deviceFound', (data) => {
      if (data == null) {
        return
      }
      console.info('[DeviceMnager.RemoteDeviceModel] deviceFound data=' + JSON.stringify(data))
      self.deviceFound(data)
    })
    this.deviceManager.on('discoverFail', (data) => {
      console.info('[DeviceMnager.RemoteDeviceModel] discoverFail data=' + JSON.stringify(data))
    })
    this.deviceManager.on('serviceDie', () => {
      console.error('[DeviceMnager.RemoteDeviceModel] serviceDie')
    })
    this.startDeviceDiscovery()
  }

  deviceFound(data) {
    for (let i = 0;i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId == data.device.deviceId) {
        console.info('[DeviceMnager.RemoteDeviceModel] device founded ignored')
        return
      }
    }
    this.discoverList[this.discoverList.length] = data.device
    console.info('[DeviceMnager.RemoteDeviceModel] deviceFound self.discoverList=' + this.discoverList)
    this.callback()
  }

  startDeviceDiscovery() {
    let info = {
      subscribeId: SUBSCRIBE_ID,
      mode: 0xAA,
      medium: 2,
      freq: 2,
      isSameAccount: false,
      isWakeRemote: true,
      capability: 0
    }
    console.info('[DeviceMnager.RemoteDeviceModel] startDeviceDiscovery ' + SUBSCRIBE_ID)
    this.deviceManager.startDeviceDiscovery(info)
  }

  unregisterDeviceListCallback() {
    console.info('[DeviceMnager.RemoteDeviceModel] stopDeviceDiscovery ' + SUBSCRIBE_ID)
    this.deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID)
    this.deviceManager.off('deviceStateChange')
    this.deviceManager.off('deviceFound')
    this.deviceManager.off('discoverFail')
    this.deviceManager.off('serviceDie')
    this.deviceList = []
    this.discoverList = []
  }

  authenticateDevice(device) {
    console.info('[DeviceMnager.RemoteDeviceModel] authenticateDevice ' + JSON.stringify(device))
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId != device.deviceId) {
        continue
      }
      let extraInfo = {
        'targetPkgName': 'ohos.samples.etsdevicemanager',
        'appName': 'eTSDeviceManger',
        'appDescription': 'eTSDeviceManger Ability',
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
          console.info('[DeviceMnager.RemoteDeviceModel] authenticateDevice error:' + JSON.stringify(err))
          return
        }
        console.info('[DeviceMnager.RemoteDeviceModel] authenticateDevice succeed:' + JSON.stringify(data))
      })
    }
  }
}