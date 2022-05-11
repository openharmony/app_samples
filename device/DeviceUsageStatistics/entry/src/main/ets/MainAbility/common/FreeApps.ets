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

import Logger from '../model/Logger'
import bundleState from '@ohos.bundleState'
import { AppInfo, appInit } from '../model/AppInfo'
import { getAppName, getAppIcon } from '../utils/Util'

const TAG = 'FreeApps'

@Component
export struct FreeApps {
  @State apps: Array<AppInfo> = appInit()
  @State freeApps: Array<AppInfo> = []

  aboutToAppear() {
    for (let i in this.apps) {
      this.isIdleState(this.apps[i].bundleName)
    }
  }

  async isIdleState(bundleName: string) {
    let isIdleState = await bundleState.isIdleState(bundleName)
    if (isIdleState) {
      this.freeApps.push({ bundleName: bundleName, name: getAppName(bundleName), icon: getAppIcon(bundleName) })
    }
    Logger.info(TAG, `freeApps=${JSON.stringify(this.freeApps)}`)
  }

  build() {
    Column() {
      Text($r('app.string.free_apps'))
        .width('80%')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .direction(Direction.Ltr)
        .margin({ bottom: 10 })
      Scroll() {
        Row() {
          ForEach(this.freeApps, (item) => {
            Column() {
              Image(item.icon)
                .width(70)
                .height(70)
                .objectFit(ImageFit.Fill)
              Text(item.name)
                .fontSize(10)
                .margin({ top: 5 })
            }
            .width(70)
            .height(90)
            .margin(10)
          }, item => item.name)
        }
        .borderRadius(10)
        .backgroundColor(Color.White)
      }
      .width('90%')
      .padding(10)
      .scrollable(ScrollDirection.Horizontal)
    }
  }
}