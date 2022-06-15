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

import DeviceAttribute from '../model/DeviceAttribute'

@Component
export default struct DeviceList {
  @Link isRefreshing: boolean
  @Link device: DeviceAttribute
  @Link devices: Array<DeviceAttribute>
  private getDeviceList?: () => void
  private openDialog?: () => void

  build() {
    Column() {
      Text($r('app.string.device_list'))
        .fontSize(25)
        .margin({ top: 30 })
        .fontWeight(FontWeight.Bold)
      Refresh({ refreshing: this.isRefreshing, offset: 120, friction: 100 }) {
        List() {
          ForEach(this.devices, (item, index) => {
            ListItem() {
              Text(`${this.devices[index].manufacturerName} ${this.devices[index].productName}`)
                .height(50)
                .fontSize(20)
                .width('100%')
                .borderRadius(30)
                .fontColor(Color.Black)
                .textAlign(TextAlign.Center)
            }
            .margin({ top: 20 })
            .onClick(() => {
              this.device = this.devices[index]
              this.openDialog()
            })
          }, item => item.name)
        }
        .height(300)
        .divider({ strokeWidth: 1, color: Color.Black, startMargin: 50, endMargin: 50 })
      }
      .height(300)
      .width('90%')
      .margin({ bottom: 20 })
      .onStateChange(() => {
        this.getDeviceList()
      })
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
        }, 1000)
      })
    }
    .width('90%')
    .borderRadius(20)
    .backgroundColor('#e5e5e5')
    .margin({ top: 20, bottom: 100 })
  }
}