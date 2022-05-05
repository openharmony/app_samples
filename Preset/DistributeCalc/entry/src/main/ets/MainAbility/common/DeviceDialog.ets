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

const TAG = 'DeviceDialog'

@CustomDialog
export struct DeviceDialog {
  controller: CustomDialogController
  private deviceList: Array<deviceManager.DeviceInfo> = []
  private selectedIndex: number = 0
  private onSelectedIndexChange: (selectedIndex) => void

  build() {
    Column() {
      Text($r('app.string.choiceDevice'))
        .fontSize(30)
        .width('100%')
        .fontColor(Color.Black)
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Bold)
      List() {
        ForEach(this.deviceList, (item, index) => {
          ListItem() {
            Row() {
              Text(item.deviceName)
                .fontSize(21)
                .width('90%')
                .fontColor(Color.Black)
              Image(index === this.selectedIndex ? $r('app.media.checked') : $r('app.media.uncheck'))
                .width('8%')
                .objectFit(ImageFit.Contain)
            }
            .height(55)
            .margin({ top: 17 })
            .onClick(() => {
              Logger.info(TAG, "select device:" + item.deviceId)
              if (index === this.selectedIndex) {
                Logger.info(TAG, 'index === this.selectedIndex')
                return
              }
              this.selectedIndex = index
              this.onSelectedIndexChange(this.selectedIndex)
            })
          }
        }, item => item.deviceName)
      }

      Button() {
        Text($r('app.string.cancel'))
          .width('90%')
          .fontSize(21)
          .fontColor('#0D9FFB')
          .textAlign(TextAlign.Center)
      }
      .margin({ top: 22 })
      .type(ButtonType.Capsule)
      .backgroundColor(Color.White)
      .onClick(() => {
        this.controller.close()
      })
    }
    .width(448)
    .height(290)
    .padding({ left: 32, right: 32, top: 13, bottom: 33 })
    .backgroundColor(Color.White)
    .border({ color: Color.White, radius: 20 })
  }
}