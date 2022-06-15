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
import logger from '../Model/Logger'

const STORE_ID: string = 'game_game'
const TAG: string = 'KvStoreModel'

export class KvStoreModel {
  public kvManager: distributedData.KVManager
  public kvStore: distributedData.KVStore

  constructor() {
  }

  createKvStore(callback) {
    if ((typeof (this.kvStore) !== 'undefined')) {
      callback()
      return
    }
    var config = {
      bundleName: 'ohos.samples.distributeddatagobang',
      userInfo: {
        userId: '0',
        userType: 0
      }
    }
    logger.info(TAG, `[KvStoreModel] createKVManager begin`)
    distributedData.createKVManager(config).then((manager) => {
      logger.info(TAG, `[KvStoreModel] createKVManager success, kvManager= ${JSON.stringify(manager)}`)
      this.kvManager = manager
      let options = {
        createIfMissing: true,
        encrypt: false,
        backup: false,
        autoSync: true,
        kvStoreType: 1,
        securityLevel: 1
      }
      logger.info(TAG, `[KvStoreModel] kvManager.getKVStore begin`)
      this.kvManager.getKVStore(STORE_ID, options).then((store) => {
        logger.info(TAG, `[KvStoreModel] getKVStore success, kvStore= ${store}`)
        this.kvStore = store
        callback()
      })
      logger.info(TAG, `[KvStoreModel] kvManager.getKVStore end`)
    })
    logger.info(TAG, `[KvStoreModel] createKVManager end`)
  }

  put(key, value) {
    logger.info(TAG, `[KvStoreModel] kvStore.put ${key} = ${value}`)
    this.kvStore.put(key, value).then((data) => {
      logger.info(TAG, `[KvStoreModel] kvStore.put ${key} finished, data= ${JSON.stringify(data)}`)
    }).catch((err) => {
      logger.info(TAG, `[KvStoreModel] kvStore.put  ${key} failed, ${JSON.stringify(err)}`)
    })
  }

  setOnMessageReceivedListener(msg, callback) {
    logger.info(TAG, `[KvStoreModel] setOnMessageReceivedListener: ${msg}`)
    this.createKvStore(() => {
      logger.info(TAG, `[KvStoreModel] kvStore.on(dataChange) begin`)
      this.kvStore.on('dataChange', 1, (data) => {
        logger.info(TAG, `[KvStoreModelDate] dataChange, ${JSON.stringify(data)}`)
        let entries = data.insertEntries.length > 0 ? data.insertEntries : data.updateEntries
        for (let i = 0; i < entries.length; i++) {
          if (entries[i].key === msg) {
            let value = entries[i].value.value
            logger.info(TAG, `[KvStoreModel] Entries receive, ${msg} = ${value}`)
            callback(value)
            return
          }
        }
      })
      logger.info(TAG, `[KvStoreModel] kvStore.on(dataChange) end`)
    })
  }
}