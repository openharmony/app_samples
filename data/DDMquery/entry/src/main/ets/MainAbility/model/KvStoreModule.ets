/*
 * Copyright (c) 2020 Huawei Device Co., Ltd.
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

const TAG = '[KvStoreModule]:'

export class KvStoreModule {
  private bundleName: string = ''
  private storeId: string = ''
  SingleKVStore

  constructor(bundleNme: string, storeId: string) {
    this.bundleName = bundleNme
    this.storeId = storeId
  }

  createKvStore() {
    let config = {
      bundleName: this.bundleName,
      userInfo: {
        userId: '0',
        userType: 0
      }
    }
    let options = {
      createIfMissing: true,
      encrypt: false,
      backup: false,
      autoSync: true,
      kvStoreType: 1,
      securityLevel: 3,
      schema: undefined
    }
    distributedData.createKVManager(config).then((manager) => {
      console.info(`${TAG} createKVManager success, kvManager = ${JSON.stringify(manager)}`)

      let name = new distributedData.FieldNode('name')
      name.type = 1
      name.nullable = false
      name.default = '0'

      let schema = new distributedData.Schema()
      schema.root.appendChild(name)
      schema.indexes = ['$.name']
      schema.mode = 1
      options.schema = schema
      console.log(`${TAG} ${schema}`)
      manager.getKVStore(this.storeId, options).then((store) => {
        console.info(`${TAG} getKVStore success, SingleKVStore = ${store}`)
        this.SingleKVStore = store
      })
    })
  }

  put(key, callback) {
    for (let i = 0; i < 10; i++) {
      let value = `{ "name": ${i} }`
      console.log(`${TAG} this.SingleKVStore = ${this.SingleKVStore} ${key} ${i} ${value}`)
      this.SingleKVStore.put(key + i, value).then((data) => {
        console.info(`${TAG} SingleKVStore.put success`)
        callback('put success')
      }).catch((err) => {
        console.error(`${TAG} SingleKVStore.put failed ${JSON.stringify(err)}`)
      })
    }
  }

  getResultSet(key, callback) {
    this.SingleKVStore.getResultSet(key, function(err, result){
      this.resultSet(result, callback)
    }.bind(this))
  }

  resultSet(result, callback) {
    console.log(`${TAG} getResultSet success  result.getCount = ${result.getCount()}`)
    console.log(`${TAG} getResultSet success  result.moveToFirst = ${result.moveToFirst()}`)
    console.log(`${TAG} getResultSet success  result.entry = ${JSON.stringify(result.getEntry())}`)
    let entries = ''
    for (let i = 0; i < result.getCount(); i++) {
      console.info(`${TAG} key = ${JSON.stringify(result.getEntry().key)}`)
      console.info(`${TAG} value = ${JSON.stringify(result.getEntry().value.value)}`)
      entries += `key: ${JSON.stringify(result.getEntry().key)}, value: ${JSON.stringify(
        result.getEntry()
        .value.value)}\n`
      console.info(`${TAG} moveToNext = ${result.moveToNext()}`)
    }
    callback(entries)
    this.SingleKVStore.closeResultSet(result, function (err, data) {
      console.info(`${TAG} getResultSet closeResultSet success`)
    })
  }

  getResultSetQuery(query, callback) {
    console.log(`${TAG} getResultSetQuery enter`)
    this.SingleKVStore.getResultSet(query, function(err, result){
      console.log(`${TAG} getResultSetQuery getResultSet, err=${err}, ${query.getSqlLike()}, ${JSON.stringify(result)}`)
      this.resultSet(result, callback)
    }.bind(this))
  }

  getEntries(query, callback) {
    try {
      this.SingleKVStore.getEntries(query, function(err, result){
        console.log(`${TAG} getEntries success err=${err}, ${query.getSqlLike()},  ${JSON.stringify(result)}, ${result.length}`)
        let entries = ''
        for (let i = 0; i < result.length; i++) {
          entries += `key: ${JSON.stringify(result[i].key)}, value: ${JSON.stringify(result[i].value.value)}\n`
        }
        console.log(`${TAG} getEntries success ${entries}`)
        callback(entries)
      }.bind(this))
    } catch (err) {
      console.info(`${TAG} getEntries fail ${JSON.stringify(err)}`)
    }
  }
}