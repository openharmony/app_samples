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
import featureAbility from '@ohos.ability.featureAbility'
import prompt from '@system.prompt'
import { Student } from '../model/Student'
import { STORE_CONFIG } from '../model/RdbConst'

const TAG = '[Rdb.rdbModel]'

export class rdbModel {
  private rdbStore: any = null
  private tableName: string = ''
  private sqlCreateTable: string = ''
  private columns: Array<string> = []

  constructor(tableName: string, sqlCreateTable: string, columns: Array<string>) {
    this.tableName = tableName
    this.sqlCreateTable = sqlCreateTable
    this.columns = columns
  }

  getRdbStore(callback) {
    if (this.rdbStore != null) {
      callback()
      return;
    }
    let context = featureAbility.getContext()
    dataRdb.getRdbStore(context,STORE_CONFIG, 1, (err, rdb) => {
      this.rdbStore = rdb
      this.rdbStore.executeSql(this.sqlCreateTable)
      console.log(`${TAG}create table done`)
      callback()
    })
  }

  insertData(student: Student, callback) {
    const valueBucket = {
      'name': student.name,
      'age': student.age,
      'phone': student.phone,
    }
    this.rdbStore.insert(this.tableName, valueBucket, function (err, ret) {
      console.log(`${TAG}insert done:${ret}`)
      callback(ret)
      prompt.showToast({ message: 'insert done:' + ret })
    })
  }

  updateData(student: Student) {
    const valueBucket = {
      'name': student.name,
      'age': student.age,
      'phone': student.phone,
    }
    let predicates = new dataRdb.RdbPredicates(this.tableName)
    console.log(`${TAG}updateData id=${student.id}`)
    predicates.equalTo('id', student.id)
    this.rdbStore.update(valueBucket, predicates, function (err, ret) {
      console.log(`${TAG}updated row count: ${ret}`)
      prompt.showToast({ message: 'updated row done:' + ret })
    })
  }

  deleteByStudent(student: Student) {
    let predicates = new dataRdb.RdbPredicates(this.tableName)
    predicates.equalTo('id', student.id)
    this.rdbStore.delete(predicates, function (err, rows) {
      console.log(`${TAG}delete rows: ${rows}`)
      prompt.showToast({ message: 'delete student' + rows })
    })
  }

  query(predicates, callback) {
    console.log(`${TAG}query start`)
    let self = this
    this.rdbStore.query(predicates, this.columns, function (err, resultSet) {
      let resultList = self.getListFromResultSet(resultSet)
      callback(resultList)
    })
  }

  getListFromResultSet(resultSet) {
    console.log(`${TAG}getListFromResultSet`)
    let studentList = []
    console.log(`${TAG}resultSet column names:${resultSet.columnNames}`)
    console.log(`${TAG}resultSet row count:${resultSet.rowCount}`)
    console.log(`${TAG}resultSet goToFirstRow:${resultSet.goToFirstRow()}`)
    for (let i = 0;i < resultSet.rowCount; i++) {
      let student = new Student(resultSet.getDouble(resultSet.getColumnIndex('id'))
        , resultSet.getString(resultSet.getColumnIndex('name'))
        , resultSet.getDouble(resultSet.getColumnIndex('age'))
        , resultSet.getString(resultSet.getColumnIndex('phone')))
      studentList.push(student)
      resultSet.goToNextRow()
    }
    return studentList
  }
}