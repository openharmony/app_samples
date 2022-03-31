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

import HiLogUtil from '../model/HiLogUtil'
import dataStorage from '@ohos.data.storage'
import featureAbility from '@ohos.ability.featureAbility'

const TAG = '[AccountData]'

export class AccountData {
  static instance: AccountData  = null
  private storage = null
  private accountData = []

  public static getInstance() {
    if (this.instance === null) {
      this.instance = new AccountData()
    }
    return this.instance
  }

  async getFromStorage() {
    const context = featureAbility.getContext()
    let path = await context.getOrCreateLocalDir()
    this.storage = await dataStorage.getStorage(`${path}/files/storage`)
    return
  }

  async getStorage() {
    if (this.storage !== null) {
      return this.storage
    } else {
      await this.getFromStorage()
      return this.storage
    }
  }

  async putStorageValue(key: string, value: string) {
    this.storage = await this.getStorage()
    await this.storage.put(key, value)
    HiLogUtil.info(TAG, `put key && value success, key is ${key}, value is ${value}`)
    await this.storage.flush()
    return
  }

  async getStorageValue(key: string) {
    this.storage = await this.getStorage()
    let getValue: string = await this.storage.get(key, 'null')
    HiLogUtil.log(TAG, `getStorageValue success, getValue is ${JSON.stringify(getValue)}`)
    return getValue
  }

  async deleteStorageValue(key: string) {
    this.storage = await this.getStorage()
    await this.storage.delete(key)
    HiLogUtil.log(TAG, `delete success`)
    await this.storage.flush()
    return
  }
}