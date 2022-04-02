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

import dataAbility from '@ohos.data.dataAbility'
import router from '@system.router'
import { BASE_URI, COLUMNS, DA_HELPER } from '../model/daHelperConst'
import { BookView } from '../component/bookView'
import { BookModel, initValuesBuckets, getListFromResultSet } from '../model/bookDataModel'
import { TitleBar } from '../component/titleBar'
import { SearchBar } from '../component/searchBar'

const TAG = 'DataAbility.Index'
let self = null

@Entry
@Component
struct Index {
  @State bookList: Array<BookModel> = []

  aboutToAppear() {
    console.info(TAG + ' aboutToAppear')
    self = this
    this.queryAll()
  }

  queryAll() {
    let predicates = new dataAbility.DataAbilityPredicates()
    DA_HELPER.query(BASE_URI, COLUMNS, predicates, (err, resultSet) => {
      this.bookList = getListFromResultSet(resultSet)
    })
  }

  deleteCallback(book) {
    let predicates = new dataAbility.DataAbilityPredicates()
    predicates.equalTo('id', book.id)
    DA_HELPER.delete(BASE_URI, predicates, (err, num) => {
      console.info(TAG + ' delete num=' + num)
      self.bookList.splice(self.bookList.indexOf(book), 1)
    })
  }

  batchInsertCallback() {
    let valuesBuckets = initValuesBuckets()
    DA_HELPER.batchInsert(BASE_URI, valuesBuckets, (err, num) => {
      console.info(TAG + ' batch insert num=' + num)
      self.queryAll()
    })
  }

  build() {
    Column() {
      TitleBar({ batchInsertCallback: this.batchInsertCallback })
      SearchBar()
      Stack({ alignContent: Alignment.BottomEnd }) {
        List() {
          ForEach(this.bookList, item => {
            ListItem() {
              BookView({ book: item, deleteCallback: this.deleteCallback })
            }
            .onClick(() => {
              router.push({ uri: 'pages/update', params: { book: item } })
            })
          }, item => JSON.stringify(item))
        }
        .width('100%')
        .margin({ bottom: 100 })
        .constraintSize({ minHeight: '100%' })
        .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 10, endMargin: 10 })

        Button() {
          Image($r('app.media.add'))
        }
        .type(ButtonType.Circle)
        .width(60).height(60)
        .backgroundColor('#0D9FFB')
        .margin({ bottom: 150, right: 50 })
        .onClick(() => {
          let valuesBuckets = { name: 'Book name', introduction: 'Book introduction' }
          DA_HELPER.insert(BASE_URI, valuesBuckets, (err, num) => {
            console.info(TAG + ' insert num=' + num)
            this.bookList.push({ id: num, name: 'Book name', introduction: 'Book introduction' })
          })
        })
      }
      .width('100%').height('100%')
    }
    .width('100%').height('100%')
  }
}