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

import { DeviceDataModel } from '../model/DeviceDataModel'

@Component
export struct DeviceView {
  private device: DeviceDataModel = null

  build() {
    Column() {
      Row() {
        Text($r('app.string.device_name'))
          .fontColor(Color.Black)
          .fontSize(20)
          .width(130)
        Text(this.device.deviceName)
          .fontColor(Color.Black)
          .fontSize(20)
          .layoutWeight(1)
      }
      .width('100%')

      Row() {
        Text($r('app.string.device_id'))
          .fontColor(Color.Black)
          .fontSize(20)
          .width(130)
        Text(this.device.deviceId)
          .fontColor(Color.Black)
          .fontSize(20)
          .layoutWeight(1)
      }
      .width('100%')
      .margin({ top: 10 })

      Row() {
        Text($r('app.string.device_state'))
          .fontColor(Color.Black)
          .fontSize(20)
          .width(130)
        Text(this.device.state)
          .fontColor(Color.Black)
          .fontSize(20)
          .layoutWeight(1)
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .padding(10)
  }
}