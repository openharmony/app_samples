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
import Logger from '../data/Logger'

const TAG: string = 'DeviceDialog'

@CustomDialog
export default struct DeviceDialog {
  private customDialogController?: CustomDialogController
  private devices: Array<deviceManager.DeviceInfo> = []
  private selectedIndex: number = 0
  private onSelectedIndexChange: (selectedIndex) => void

  build() {
    Column() {
      Text($r('app.string.choice_device'))
        .fontSize(30)
        .width('100%')
        .fontColor(Color.Black)
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Bold)
      List() {
        ForEach(this.devices, (item, index) => {
          ListItem() {
            Row() {
              Text(`${item.deviceName} ${index + 1}`)
                .fontSize(22)
                .width('90%')
                .fontColor(Color.Black)
              Image(index === this.selectedIndex ? $r('app.media.checked') : $r('app.media.uncheck'))
                .width('8%')
                .objectFit(ImageFit.Contain)
            }
            .height(56)
            .margin({ top: 18 })
            .onClick(() => {
              Logger.info(TAG, `select device: ${item.deviceId}`)
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
          .fontSize(22)
          .fontColor('#0C9FFC')
          .textAlign(TextAlign.Center)
      }
      .margin({ top: 22 })
      .type(ButtonType.Capsule)
      .backgroundColor(Color.White)
      .onClick(() => {
        this.customDialogController.close()
      })
    }
    .width(448)
    .height(290)
    .backgroundColor(Color.White)
    .padding({ left: 32, right: 32, top: 12, bottom: 32 })
    .border({ color: Color.White, radius: 20 })
  }
}