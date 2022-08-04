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

import distributedData from '@ohos.data.distributedData'
import Logger from '../model/Logger'

const STORE_ID: string = 'musicplayer_kvstore'
const TAG: string = 'KvStoreModel'

class KvStoreModel {
  private kvManager: distributedData.KVManager
  private kvStore

  constructor() {
  }

  async createKvStore(context, callback) {
    if (typeof (this.kvStore) === 'undefined') {
      let config = {
        bundleName: 'ohos.samples.etsdistributedmusicplayer',
        userInfo: {
          userId: '0',
          userType: 0
        },
        context: context
      }
      Logger.info(TAG, 'createKVManager begin')
      this.kvManager = await distributedData.createKVManager(config)
      Logger.info(TAG, `createKVManager success, kvManager`)
      let options = {
        createIfMissing: true,
        encrypt: false,
        backup: false,
        autoSync: true,
        kvStoreType: distributedData.KVStoreType.SINGLE_VERSION,
        schema: null,
        securityLevel: 3,
      }
      Logger.info(TAG, 'kvManager.getKVStore begin')
      this.kvStore = await this.kvManager.getKVStore(STORE_ID, options)
      Logger.info(TAG, `getKVStore success`)
      callback()
      Logger.info(TAG, 'kvManager.getKVStore end')
      Logger.info(TAG, 'createKVManager end')
    } else {
      callback()
    }
  }

  broadcastMessage(context, msg) {
    Logger.info(TAG, `broadcastMessage ${msg}`)
    let num = Math.random()
    this.createKvStore(context, () => {
      this.put(msg, num)
    })
  }

  async put(key, value) {
    Logger.info(TAG, `kvStore.put ${key} = ${value}`)
    await this.kvStore.put(key, value)
    this.kvStore.get(key).then((data) => {
      Logger.info(TAG, `kvStore.get ${key} = ${JSON.stringify(data)}`)
    })
    Logger.info(TAG, `kvStore.put ${key} finished`)
  }

  setOnMessageReceivedListener(context, msg, callback) {
    Logger.info(TAG, `setOnMessageReceivedListener ${msg}`)
    this.createKvStore(context, () => {
      Logger.info(TAG, 'kvStore.on(dataChange) begin')
      this.kvStore.on('dataChange', 1, (data) => {
        Logger.info(TAG, `dataChange, ${JSON.stringify(data)}`)
        Logger.info(TAG, `dataChange insert ${data.insertEntries.length} udpate ${data.updateEntries.length}`)
        for (let i = 0; i < data.insertEntries.length; i++) {
          if (data.insertEntries[i].key === msg) {
            Logger.info(TAG, `insertEntries receive ${msg} ${JSON.stringify(data.insertEntries[i].value)}`)
            callback()
            return
          }
        }
        for (let i = 0; i < data.updateEntries.length; i++) {
          if (data.updateEntries[i].key === msg) {
            Logger.info(TAG, `updateEntries receive ${msg} ${JSON.stringify(data.updateEntries[i].value)}`)
            callback()
            return
          }
        }
      })
      Logger.info(TAG, 'kvStore.on(dataChange) end')
    })
  }
}

export default new KvStoreModel()