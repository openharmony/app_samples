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
import dataRdb from '@ohos.data.rdb'
import prompt from '@system.prompt'
import { Student } from '../model/Student'
import { StudentView } from '../common/StudentView'
import { SearchView } from '../common/SearchView'
import { rdbModel } from '../model/RdbModel'
import { TABLE_NAME, SQL_CREATE_TABLE, COLUMNS } from '../model/RdbConst'

const TAG = '[Rdb.Search]'

@Entry
@Component
struct Index {
  private rdb = new rdbModel(TABLE_NAME, SQL_CREATE_TABLE, COLUMNS)
  @State result: Array<Student> = []

  queryByNameCallback(data) {
    console.log(`${TAG}search queryByName name:${data}`)
    if (data === '') {
      prompt.showToast({ message: 'query name is empty' })
      return
    }
    let predicates = new dataRdb.RdbPredicates(TABLE_NAME)
    predicates.equalTo('name', data)
    this.query(predicates)
  }

  queryByAgeCallback() {
    console.log(`${TAG}search queryByAge`)
    let predicates = new dataRdb.RdbPredicates(TABLE_NAME)
    predicates.between('age', 18, 20)
    this.query(predicates)
  }

  queryByPhoneCallback() {
    console.log(`${TAG}search queryByPhone`)
    let predicates = new dataRdb.RdbPredicates(TABLE_NAME)
    predicates.beginsWith('phone', '170')
      .and()
      .contains('phone', '5')
    this.query(predicates)
  }

  query(predicates) {
    console.log(`${TAG}query`)
    this.rdb.getRdbStore(function () {
      this.rdb.query(predicates, (studentsList) => {
        this.result = studentsList
      })
    }.bind(this))
  }

  build() {
    Column() {
      Row() {
        Text($r("app.string.title"))
          .width('90%')
          .fontColor(Color.White)
          .fontSize(20)
      }
      .height(50).width('100%')
      .backgroundColor('#0D9FFB')
      .padding({ left: 15 })

      SearchView({ queryByNameCallback: this.queryByNameCallback.bind(this),
        queryByAgeCallback: this.queryByAgeCallback.bind(this),
        queryByPhoneCallback: this.queryByPhoneCallback.bind(this) })

      List() {
        ForEach(this.result, item => {
          ListItem() {
            StudentView({ student: item, deleteCallBack: null })
          }
        }, item => item.toString())
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 10, endMargin: 10 })
    }
  }
}