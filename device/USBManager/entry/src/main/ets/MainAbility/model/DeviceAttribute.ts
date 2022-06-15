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

export default class DeviceAttribute {
  public busAddress: number // 总线地址
  public deviceAddress: number // 设备地址
  public serial: string // 序列号
  public name: string // 设备名字
  public manufacturerName: string // 产商信息
  public productName: string // 产品信息
  public version: string // 版本
  public vendorId: number // 厂商ID
  public productId: number // 产品ID
  public clazz: number // 设备类

  constructor() {
    this.busAddress = 0
    this.deviceAddress = 0
    this.serial = ''
    this.name = ''
    this.manufacturerName = ''
    this.productName = ''
    this.version = ''
    this.vendorId = 0
    this.productId = 0
    this.clazz = 0
  }
}
