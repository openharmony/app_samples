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

import display from '@ohos.display'
import Logger from '../model/Logger'

const TAG: string = '[ShowInfo]'

@CustomDialog
export struct ShowInfo {
  private defaultOrAllScreen?: boolean
  private allScreens?: display.Display[]
  private defaultScreens?: display.Display
  private dialogController?: CustomDialogController

  @Builder infoText(types: Resource, infos: string) {
    Row() {
      Text(types)
        .margin({ right: 5 })
        .fontSize(18)
      Text(infos)
        .margin({ left: 5 })
        .fontSize(18)
    }
    .margin(5)
  }

  screenInfo(types: string) {
    Logger.info(TAG, `defaultOrAllScreen = ${this.defaultOrAllScreen}`)
    let info: string = ''
    if (this.defaultOrAllScreen) {
      const SCREEN_INFO = {
        id: `${this.defaultScreens.id}`,
        refreshRate: `${this.defaultScreens.refreshRate}`,
        width: `${this.defaultScreens.width}`,
        height: `${this.defaultScreens.height}`
      }
      info = SCREEN_INFO[types]
    } else {
      let ids: string = ''
      let refreshRates: string = ''
      let widths: string = ''
      let heights: string = ''
      for (let i = 0; i < this.allScreens.length; i++) {
        ids = `${ids} ${this.allScreens[i].id}`
        refreshRates = `${refreshRates} ${this.allScreens[i].refreshRate}`
        widths = `${widths} ${this.allScreens[i].width}`
        heights = `${heights} ${this.allScreens[i].height}`
      }
      const SCREENS_INFO = {
        id: ids,
        refreshRate: refreshRates,
        width: widths,
        height: heights
      }
      info = SCREENS_INFO[types]
    }
    Logger.info(TAG, `this info is ${info}`)
    return info
  }

  build() {
    Column() {
      Text($r('app.string.info'))
        .margin(10)
        .fontSize(20)

      Column() {
        this.infoText($r('app.string.id'), this.screenInfo('id'))
        this.infoText($r('app.string.refreshRate'), this.screenInfo('refreshRate'))
        this.infoText($r('app.string.width'), this.screenInfo('width'))
        this.infoText($r('app.string.height'), this.screenInfo('height'))
      }
      .padding(5)
      .width('100%')
      .borderRadius(10)
      .alignItems(HorizontalAlign.Start)
    }
    .padding(5)
    .width('100%')
    .borderRadius(10)
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      this.dialogController.close()
    })
  }
}