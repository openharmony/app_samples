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
import deviceManager from '@ohos.distributedHardware.deviceManager'

var SUBSCRIBE_ID = 100

export class RemoteDeviceModel {
  deviceList = []
  discoverList = []
  callback
  authCallback
  deviceManager

  constructor() {
  }

  registerDeviceListCallback(callback) {
    if (typeof (this.deviceManager) != 'undefined') {
      this.registerDeviceListCallbackImplement(callback)
      return
    }
    console.log('[RemoteDeviceModel] deviceManager.createDeviceManager begin')
    let self = this
    deviceManager.createDeviceManager("ohos.samples.etskvstore", (error, value) => {
      if (error) {
        console.error('[RemoteDeviceModel] createDeviceManager failed.')
        return;
      }
      self.deviceManager = value
      self.registerDeviceListCallbackImplement(callback)
      console.log('[RemoteDeviceModel] createDeviceManager callback returned, error=' + error + ' value=' + value)
    });
    console.log('[RemoteDeviceModel] deviceManager.createDeviceManager end')
  }

  deviceStateChangeActionOnline(device) {
    this.deviceList[this.deviceList.length] = device
    console.info('[RemoteDeviceModel] online, device list=' + JSON.stringify(this.deviceList))
    this.callback()
    if (this.authCallback != null) {
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
      if (this.deviceList[i].deviceId != device.deviceId) {
        list[i] = device
      }
    }
    this.deviceList = list
    console.info('[RemoteDeviceModel] ready, device list=' + JSON.stringify(device))
    this.callback()
  }

  deviceStateChangeActionOffline(device) {
    if (this.deviceList.length <= 0) {
      this.callback()
      return
    }
    for (let j = 0; j < this.deviceList.length; j++) {
      if (this.deviceList[j ].deviceId == device.deviceId) {
        this.deviceList[j] = device
        break
      }
    }
    console.info('[RemoteDeviceModel] offline, device list=' + JSON.stringify(this.deviceList))
    this.callback()
  }

  registerDeviceListCallbackImplement(callback) {
    console.info('[RemoteDeviceModel] registerDeviceListCallback')
    this.callback = callback
    if (this.deviceManager === undefined) {
      console.error('[RemoteDeviceModel] deviceManager has not initialized')
      this.callback()
      return
    }
    console.info('[RemoteDeviceModel] getTrustedDeviceListSync begin')
    let list = this.deviceManager.getTrustedDeviceListSync()
    console.info('[RemoteDeviceModel] getTrustedDeviceListSync end, deviceList=' + JSON.stringify(list))
    if (typeof (list) != 'undefined' && typeof (list.length) != 'undefined') {
      this.deviceList = list
    }
    this.callback()
    console.info('[RemoteDeviceModel] callback finished');
    let self = this;
    this.deviceManager.on('deviceStateChange', (data) => {
      if (data == null) {
        return
      }
      console.info('[RemoteDeviceModel] deviceStateChange data=' + JSON.stringify(data))
      switch (data.action) {
        case deviceManager.DeviceStateChangeAction.ONLINE:
          self.deviceStateChangeActionOnline(data.device)
          break;
        case deviceManager.DeviceStateChangeAction.READY:
          self.deviceStateChangeActionReady(data.device)
          break;
        case deviceManager.DeviceStateChangeAction.OFFLINE:
        case deviceManager.DeviceStateChangeAction.CHANGE:
          self.deviceStateChangeActionOffline(data.device)
          break
        default:
          break
      }
    });
    this.deviceManager.on('deviceFound', (data) => {
      if (data == null) {
        return
      }
      console.info('[RemoteDeviceModel] deviceFound data=' + JSON.stringify(data))
      self.deviceFound(data)
    });
    this.deviceManager.on('discoverFail', (data) => {
      console.info('[RemoteDeviceModel] discoverFail data=' + JSON.stringify(data))
    });
    this.deviceManager.on('serviceDie', () => {
      console.error('[RemoteDeviceModel] serviceDie')
    });
    this.startDeviceDiscovery()
  }

  deviceFound(data) {
    for (var i = 0;i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId == data.device.deviceId) {
        console.info('[RemoteDeviceModel] device founded ignored')
        return
      }
    }
    this.discoverList[this.discoverList.length] = data.device
    console.info('[RemoteDeviceModel] deviceFound self.discoverList=' + this.discoverList)
    this.callback();
  }

  startDeviceDiscovery() {
    SUBSCRIBE_ID = Math.floor(65536 * Math.random())
    var info = {
      subscribeId: SUBSCRIBE_ID,
      mode: 0xAA,
      medium: 2,
      freq: 2,
      isSameAccount: false,
      isWakeRemote: true,
      capability: 0
    };
    console.info('[RemoteDeviceModel] startDeviceDiscovery ' + SUBSCRIBE_ID)
    this.deviceManager.startDeviceDiscovery(info)
  }

  unregisterDeviceListCallback() {
    console.info('[RemoteDeviceModel] stopDeviceDiscovery ' + SUBSCRIBE_ID)
    this.deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID);
    this.deviceManager.off('deviceStateChange')
    this.deviceManager.off('deviceFound')
    this.deviceManager.off('discoverFail')
    this.deviceManager.off('serviceDie')
    this.deviceList = []
    this.discoverList = []
  }

  authenticateDevice(device, callBack) {
    console.info('[RemoteDeviceModel] authenticateDevice ' + JSON.stringify(device));
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId != device.deviceId) {
        continue
      }
      let extraInfo = {
        'targetPkgName': 'ohos.samples.etskvstore',
        'appName': 'Distributed kvstore',
        'appDescription': 'Distributed kvstore',
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
          console.info('[RemoteDeviceModel] authenticateDevice error:' + JSON.stringify(err))
          this.authCallback = null
          return
        }
        console.info('[RemoteDeviceModel] authenticateDevice succeed:' + JSON.stringify(data))
        this.authCallback = callBack
      })
    }
  }
}