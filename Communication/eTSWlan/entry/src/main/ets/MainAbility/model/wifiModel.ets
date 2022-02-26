/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import wifi from '@ohos.wifi';
import prompt from '@system.prompt';

const TAG = '[WiFiModel]'

export class WifiModel {
  private eventListener = null

  constructor() {
    this.eventListener = new wifi.EventListener()
  }

  addConnectListener(callback) {
    this.eventListener.on('wifiConnectionChange', (state) => {
      console.info(`${TAG} wifiConnectionChange ${state}`)
      callback(state)
    })
  }

  addWifiStateListener(callback) {
    this.eventListener.on('wifiStateChange', (state) => {
      console.info(`${TAG} wifiStateChange ${state}`)
      callback(state)
    })
  }

  getScanInfos(callback) {
    wifi.scan()
    console.info(`${TAG} scanWifi`)
    wifi.getScanInfos((result) => {
      let wifiList = []
      console.info(`${TAG} wifi received scan info call back:${JSON.stringify(result)}`)
      if (result === null || result.length === 0) {
        callback(wifiList)
        return
      }
      for (var i = 0; i < result.length; ++i) {
        wifiList.push({
          ssid: result[i].ssid,
          bssid: result[i].bssid,
          securityType: result[i].securityType,
          rssi: result[i].rssi,
          band: result[i].band,
          frequency: result[i].frequency,
          timestamp: result[i].timestamp,
        })
      }
      callback(wifiList)
    })
  }

  connectNetwork(scanInfo, psw) {
    prompt.showToast({ message: 'connecting' })
    console.info(`${TAG} connectNetwork bssid=${scanInfo.bssid}`)
    let deviceConfigs = wifi.getDeviceConfigs()
    console.info(TAG + 'getDeviceConfigs:' + JSON.stringify(deviceConfigs))
    for (let i = 0;i < deviceConfigs.length; i++) {
      if (deviceConfigs[i].bssid === scanInfo.bssid) {
        if (deviceConfigs[i].preSharedKey !== psw) {
          prompt.showToast({ message: 'err password' })
          return
        }
        prompt.showToast({ message: `connect result = ${wifi.connectToDevice(deviceConfigs[i])}` })
        return
      }
    }
    let deviceConfig = {
      ssid: scanInfo.ssid,
      bssid: scanInfo.bssid,
      preSharedKey: psw,
      isHiddenSsid: false,
      securityType: scanInfo.securityType
    }
    if (wifi.connectToDevice(deviceConfig)) {
      prompt.showToast({ message: 'connect success' })
      wifi.addDeviceConfig(deviceConfig)
    } else {
      prompt.showToast({ message: 'connect fail' })
    }
  }

  resolveIP(ip) {
    let address: string = ip.toString()
    if (address === '0') {
      return '00:00:000:000'
    }
    address.substring(0, 2)
    return `${address.substring(0, 2)}:${address.substring(2, 4)}:${address.substring(4, 7)}:${address.substring(7, 10)}`
  }

  getIpInfo() {
    let ipInfoList = []
    let ipInfo = wifi.getIpInfo()
    console.info(`${TAG} getIpInfo=${JSON.stringify(ipInfo)}`)
    ipInfoList.push({ key: $r('app.string.ip_address'), value: this.resolveIP(ipInfo.ipAddress) })
    ipInfoList.push({ key: $r('app.string.gate_way'), value: this.resolveIP(ipInfo.gateway) })
    ipInfoList.push({ key: $r('app.string.net_mask'), value: this.resolveIP(ipInfo.netmask) })
    ipInfoList.push({ key: $r('app.string.primary_dns'), value: this.resolveIP(ipInfo.primaryDns) })
    ipInfoList.push({ key: $r('app.string.second_dns'), value: this.resolveIP(ipInfo.secondDns) })
    ipInfoList.push({ key: $r('app.string.server_ip'), value: this.resolveIP(ipInfo.serverIp) })
    ipInfoList.push({ key: $r('app.string.lease_duration'), value: ipInfo.leaseDuration.toString() })
    return ipInfoList
  }

  getCountryCode() {
    let countryCodeList = []
    let countryCode = wifi.getCountryCode()
    countryCodeList.push({ key: $r('app.string.country_code'), value: 'CH' })
    return countryCodeList
  }

  getFeatureSupport() {
    let featureSupportedList = []
    featureSupportedList.push({
      key: $r('app.string.infrastructure_feature'),
      value: wifi.isFeatureSupported(0x0001).toString()
    })
    featureSupportedList.push({ key: $r('app.string.ghz_feature'), value: wifi.isFeatureSupported(0x0002).toString() })
    featureSupportedList.push({
      key: $r('app.string.gas_anqp_feature'),
      value: wifi.isFeatureSupported(0x0004).toString()
    })
    featureSupportedList.push({ key: $r('app.string.wifi_direct'), value: wifi.isFeatureSupported(0x0008).toString() })
    featureSupportedList.push({ key: $r('app.string.soft_ap'), value: wifi.isFeatureSupported(0x0010).toString() })
    featureSupportedList.push({ key: $r('app.string.wifi_aware'), value: wifi.isFeatureSupported(0x0040).toString() })
    return featureSupportedList
  }
}