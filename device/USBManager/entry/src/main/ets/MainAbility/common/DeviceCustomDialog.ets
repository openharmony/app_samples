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
export default struct DeviceCustomDialog {
  private device?: DeviceAttribute
  private onCancel: () => void

  @Builder
  SingleAttribute(title: Resource, info: string) {
    Row() {
      Text(title)
        .fontSize(20)
        .width('100')
        .fontWeight(FontWeight.Bold)
      Text(info)
        .fontSize(20)
        .layoutWeight(1)
        .textAlign(TextAlign.Start)
    }
    .margin({ top: 10 })
    .alignSelf(ItemAlign.Start)
  }

  build() {
    Column() {
      Column() {
        Text(`${this.device.manufacturerName} ${this.device.productName}`)
          .width('100%')
          .fontSize(25)
          .margin({ top: 20 })
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
        this.SingleAttribute($r('app.string.bus_address'), this.device.busAddress.toString())
        this.SingleAttribute($r('app.string.device_address'), this.device.deviceAddress.toString())
        this.SingleAttribute($r('app.string.serial'), this.device.serial)
        this.SingleAttribute($r('app.string.device_name'), this.device.name)
        this.SingleAttribute($r('app.string.manufacturer_name'), this.device.manufacturerName)
        this.SingleAttribute($r('app.string.product_name'), this.device.productName)
        this.SingleAttribute($r('app.string.version'), this.device.version)
        this.SingleAttribute($r('app.string.vendor_id'), this.device.vendorId.toString())
        this.SingleAttribute($r('app.string.product_id'), this.device.productId.toString())
        this.SingleAttribute($r('app.string.device_class'), this.device.clazz.toString())
      }
      .layoutWeight(1)

      Button() {
        Text($r('app.string.confirm'))
          .fontSize(20)
      }
      .height(50)
      .width('50%')
      .margin({ top: 20, bottom: 30 })
      .type(ButtonType.Capsule)
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        this.onCancel()
      })
    }
  }
}