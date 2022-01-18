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

const TAG = 'DataAbility.BookModel'

export class BookModel {
  id: number
  name: string
  introduction: string

  constructor(id: number, name: string, introduction: string) {
    this.id = id
    this.name = name
    this.introduction = introduction
  }
}

export function initValuesBuckets() {
  let valuesBuckets = [
    { 'name': 'Book name1', 'introduction': 'Book introduction1' },
    { 'name': 'Book name2', 'introduction': 'Book introduction2' },
    { 'name': 'Book name3', 'introduction': 'Book introduction3' }]
  return valuesBuckets
}

export function getListFromResultSet(resultSet) {
  console.info(TAG + ' getListFromResultSet')
  let bookList = []
  console.log(TAG + ' resultSet column names:' + resultSet.columnNames)
  console.log(TAG + ' resultSet row count:' + resultSet.rowCount)
  console.log(TAG + ' resultSet goToFirstRow:' + resultSet.goToFirstRow())
  for (let i = 0;i < resultSet.rowCount; i++) {
    let book = new BookModel(resultSet.getDouble(resultSet.getColumnIndex('id'))
      , resultSet.getString(resultSet.getColumnIndex('name'))
      , resultSet.getString(resultSet.getColumnIndex('introduction')))
    bookList.push(book)
    console.log(TAG + ' resultSet book:' + JSON.stringify(book))
    console.log(TAG + ' resultSet goToNextRow:' + resultSet.goToNextRow())
  }
  return bookList
}