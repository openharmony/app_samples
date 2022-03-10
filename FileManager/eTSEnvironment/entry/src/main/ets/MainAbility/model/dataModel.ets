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

import statfs from '@ohos.statfs'
import environment from '@ohos.environment'

const TAG = '[Environment.DataModel]'

export class DataModel {
  async getStorageDataDir() {
    const path = await environment.getStorageDataDir()
    console.info(`${TAG} getStorageDataDir path:${path}`)
    return path
  }

  async getUserDataDir() {
    const path = await environment.getUserDataDir()
    console.info(`${TAG} getUserDataDir path:${path}`)
    return path
  }

  async getFreeBytes(path: string) {
    const bytes = await statfs.getFreeBytes(path)
    console.info(`${TAG} getFreeBytes bytes:${bytes}, path:${path}`)
    return bytes
  }

  async getTotalBytes(path: string) {
    const bytes = await statfs.getTotalBytes(path)
    console.info(`${TAG} getTotalBytes bytes:${bytes}, path:${path}`)
    return bytes
  }
}