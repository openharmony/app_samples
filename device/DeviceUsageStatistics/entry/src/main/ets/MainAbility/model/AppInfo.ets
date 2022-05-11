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

export class AppInfo {
  bundleName: string
  name: string
  icon: Resource

  constructor(bundleName: string, name: string, icon: Resource) {
    this.bundleName = bundleName
    this.name = name
    this.icon = icon
  }
}

export function appInit(): Array<AppInfo> {
  let appInfo = [
    { bundleName: 'com.example.myapplication', name: 'myapplication', icon: $r('app.media.icon') },
    { bundleName: 'com.example.distributedcalc', name: '计算器', icon: $r('app.media.calculator') },
    { bundleName: 'com.ohos.camera', name: '相机', icon: $r('app.media.camera') },
    { bundleName: 'com.ohos.contacts', name: '联系人', icon: $r('app.media.contacts') },
    { bundleName: 'com.ohos.distributedmusicplayer', name: '音乐', icon: $r('app.media.musicplayer') },
    { bundleName: 'com.ohos.permissionmanager', name: '信息', icon: $r('app.media.msg') },
    { bundleName: 'com.ohos.note', name: '备忘录', icon: $r('app.media.notes') },
    { bundleName: 'com.ohos.photos', name: '图库', icon: $r('app.media.photos') },
    { bundleName: 'com.ohos.settings', name: '设置', icon: $r('app.media.settings') },
    { bundleName: 'ohos.example.shopping', name: '购物', icon: $r('app.media.shopping') },
    { bundleName: 'ohos.samples.airquality', name: 'AirQuality', icon: $r('app.media.airqulity') },
    { bundleName: 'ohos.samples.clock', name: 'Clock', icon: $r('app.media.clock') },
    { bundleName: "ohos.samples.ecg", name: "ECG", icon: $r("app.media.ecg") },
    { bundleName: 'ohos.samples.flashlight', name: 'FlashLight', icon: $r('app.media.flashlight') }
  ]
  return appInfo
}