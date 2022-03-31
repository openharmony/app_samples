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

import { KvStoreModule } from '../model/KvStoreModule'
import distributedData from '@ohos.data.distributedData'

let kvStoreModule: KvStoreModule = new KvStoreModule('ohos.samples.etsddmquery', 'kvStoreTest')
let query = new distributedData.Query()
const TAG = '[Query]:'

@Component
export struct Query {
  private options: Resource[] = [
    $r('app.string.push'),
    $r('app.string.resultSet'),
    $r('app.string.prefixKey'),
    $r('app.string.orderByDesc'),
    $r('app.string.addResult'),
    $r('app.string.lessThan')
  ]
  @State textTitle: string = ''
  private queryTest = null

  onQuery(data) {
    console.log(`${TAG} onQuery`)
    this.textTitle = data
  }

  aboutToAppear() {
    kvStoreModule.createKvStore()
    this.queryTest = this.onQuery.bind(this)
  }

  build() {
    Scroll() {
      Column() {
        Scroll() {
          Text(this.textTitle)
            .fontSize(25)
            .width('100%')
            .padding(10)
            .layoutWeight(1)
            .constraintSize({ minHeight: 150 })
        }
        .width('90%')
        .height('30%')
        .border({ width: 1, color: '#000000', radius: 10, style: 0 })

        ForEach(this.options, (item, index) => {
          Button() {
            Text(item)
              .width('80%')
              .height(30)
              .fontSize(20)
              .textAlign(TextAlign.Center)
              .onClick(() => {
                console.log(`${TAG} onClick index= ${index}`)
                query.reset()
                switch (index) {
                  case 0:
                    let key = 'batch_test_string_key'
                    kvStoreModule.put(key, this.queryTest)
                    break
                  case 1:
                    kvStoreModule.getResultSet('batch_test', this.queryTest)
                    break
                  case 2:
                    query.prefixKey('batch_test_string')
                    kvStoreModule.getResultSetQuery(query, this.queryTest)
                    break
                  case 3:
                    query.notEqualTo('$.name', 3)
                    query.orderByDesc('$.name')
                    kvStoreModule.getResultSetQuery(query, this.queryTest)
                    break
                  case 4:
                    query.notEqualTo('$.name', 5)
                    query.and()
                    query.notEqualTo('$.name', 3)
                    kvStoreModule.getResultSetQuery(query, this.queryTest)
                    break
                  case 5:
                    query.lessThan('$.name', 7)
                    kvStoreModule.getEntries(query, this.queryTest)
                    break
                  default:
                    break
                }
              })
          }
          .margin({ top: 20 })
          .type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
        }, item => JSON.stringify(item))
      }
      .width('100%')
      .margin({ top: 20 })
    }
    .layoutWeight(1)
  }
}