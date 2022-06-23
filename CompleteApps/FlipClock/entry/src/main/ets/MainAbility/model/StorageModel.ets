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

import dataStorage from '@ohos.data.storage'
import featureAbility from '@ohos.ability.featureAbility'


export default class StorageModel {
  static instance: StorageModel  = null
  private storage = null

  public static getInstance() {
    if (this.instance == null) {
      this.instance = new StorageModel()
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

  async putStorageValue(putKey: string, alarmClock) {
    let value = JSON.stringify(alarmClock)
    this.storage = await this.getStorage()
    await this.storage.put(putKey, value)

    await this.storage.flush()
  }

  async getStorageValue(getKey: string) {
    this.storage = await this.getStorage()
    let getValue = this.storage.get(getKey, 'null')

    return getValue
  }

  async deleteSync(key: string) {
    await this.storage.delete(key)
    await this.storage.flush()
    let result = await this.storage.get(key, 'null')
    return result
  }
}
