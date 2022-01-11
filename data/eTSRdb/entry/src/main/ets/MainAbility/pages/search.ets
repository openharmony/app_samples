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
import dataRdb from '@ohos.data.rdb'
import prompt from '@system.prompt'
import {Student} from '../model/student'
import {StudentView} from '../common/studentView'
import {SearchView} from '../common/searchView'
import {rdbModel} from '../model/rdbModel'

let self = null
const TABLE_NAME = 'student'

@Entry
@Component
struct Index {
  @State result: Array<Student> = []
  private rdb = new rdbModel()

  queryByNameCallback(data) {
    console.info('[Rdb.search]search queryByName name =' + data)
    if (data === '') {
      prompt.showToast({ message: 'query name is null' })
      return
    }
    let predicates = new dataRdb.RdbPredicates(TABLE_NAME)
    predicates.equalTo('name', data)
    self.query(predicates)
  }

  queryByAgeCallback() {
    console.info('[Rdb.search]search queryByAge')
    let predicates = new dataRdb.RdbPredicates(TABLE_NAME)
    predicates.between('age', 18, 20)
    self.query(predicates)
  }

  queryByPhoneCallback() {
    console.info('[Rdb.search]search queryByPhone')
    let predicates = new dataRdb.RdbPredicates(TABLE_NAME)
    predicates.beginsWith('phone', '170')
      .and()
      .contains('phone', '5')
    self.query(predicates)
  }

  query(predicates) {
    self.rdb.getRdbStore(() => {
      self.rdb.query(predicates, (studentsList) => {
        self.result = studentsList
      })
    })
  }

  aboutToAppear() {
    self = this
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

      SearchView({ queryByNameCallback: this.queryByNameCallback,
        queryByAgeCallback: this.queryByAgeCallback,
        queryByPhoneCallback: this.queryByPhoneCallback })

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