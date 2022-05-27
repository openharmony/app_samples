// @ts-nocheck
/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import featureAbility from '@ohos.ability.featureAbility';
import dataAbility from '@ohos.data.dataAbility'
import dataRdb from '@ohos.data.rdb'

const TABLE_NAME = 'book'
const STORE_CONFIG = { name: 'book.db' }
const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS book(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, introduction TEXT NOT NULL)'
let rdbStore: dataRdb.RdbStore = undefined
const TAG = '[DataAbility].data'

export default {
    onInitialized(abilityInfo) {
        console.info(`${TAG} DataAbility onInitialized`)
        console.log(`${TAG} create table begin`)
        dataRdb.getRdbStore(featureAbility.getContext(), STORE_CONFIG, 1, (err, rdb) => {
            if (err) {
                console.log(`${TAG} create table err = ${JSON.stringify(err)}`)
            }
            console.log(`${TAG} create table done`)
            rdb.executeSql(SQL_CREATE_TABLE)
            rdbStore = rdb
            console.log(`${TAG} create table end`)
        })
    },
    insert(uri, valueBucket, callback) {
        console.info(TAG + ' insert start')
        rdbStore.insert(TABLE_NAME, valueBucket, callback)
    },
    batchInsert(uri, valueBuckets, callback) {
        console.info(TAG + ' batch insert start')
        for (let i = 0;i < valueBuckets.length; i++) {
            console.info(TAG + ' batch insert i=' + i)
            if (i < valueBuckets.length - 1) {
                rdbStore.insert(TABLE_NAME, valueBuckets[i], (err: any, num: number) => {
                    console.info(TAG + ' batch insert ret=' + num)
                })
            } else {
                rdbStore.insert(TABLE_NAME, valueBuckets[i], callback)
            }
        }
    },
    query(uri, columns, predicates, callback) {
        console.info(TAG + ' query start')
        let rdbPredicates = dataAbility.createRdbPredicates(TABLE_NAME, predicates)
        rdbStore.query(rdbPredicates, columns, callback)
    },
    update(uri, valueBucket, predicates, callback) {
        console.info(TAG + 'update start')
        let rdbPredicates = dataAbility.createRdbPredicates(TABLE_NAME, predicates)
        rdbStore.update(valueBucket, rdbPredicates, callback)
    },
    delete(uri, predicates, callback) {
        console.info(TAG + 'delete start')
        let rdbPredicates = dataAbility.createRdbPredicates(TABLE_NAME, predicates)
        rdbStore.delete(rdbPredicates, callback)
    }
};