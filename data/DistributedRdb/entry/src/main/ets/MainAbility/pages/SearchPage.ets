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
import Contact from '../model/Contact'
import RdbModel from '../model/RdbModel'
import { QueryItem } from '../common/QueryItem'
import { TABLE_NAME } from '../model/RdbConst'

@Entry
@Component
struct SearchPage {
  private searchText: string = ''
  @State contacts: Array<Contact> = []

  async getData() {
    if (this.searchText === '') {
      this.contacts = []
      return
    }
    let predicates = new dataRdb.RdbPredicates(TABLE_NAME)
    predicates.contains('name', this.searchText)
      .or()
      .contains('phone', this.searchText)
      .or()
      .contains('remark', this.searchText)
    this.contacts = await RdbModel.query(predicates)
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.search_gray'))
          .height('100%').width(40)
          .margin({ left: 16 })
          .objectFit(ImageFit.Contain)
        TextInput({ placeholder: $r('app.string.search_placeholder') })
          .height('85%')
          .width('80%')
          .fontSize(25)
          .margin({ right: 10 })
          .backgroundColor('#FAFAFA')
          .onChange((value: string) => {
            this.searchText = value
            this.getData()
          })
      }
      .width('95%')
      .height('7%')
      .backgroundColor('#FAFAFA')
      .constraintSize({ minHeight: 60 })
      .border({ radius: 45 })
      .margin({ top: 10 })

      List() {
        ForEach(this.contacts, (item, index) => {
          ListItem() {
            QueryItem({ contact: item })
          }
        }, item => item.name)
      }
      .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 16, endMargin: 16 })
    }
  }
}