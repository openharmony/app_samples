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

import { CustomDatePicker } from '../common/CustomDataPicker'
import StorageModel from '../mode/StorageModel'
import Logger from '../mode/Logger'
import reminderAgent from '@ohos.reminderAgent'
import { TitleBar } from '../common/TitleBar'

const TAG = 'Index'

@Entry
@Component
struct Index {
  @State total: number = 0
  @State listItems: Array<unknown> = []
  private storage: StorageModel = StorageModel.getInstance()
  private datePicker: CustomDialogController = null
  getTest = async () => {
    Logger.info(TAG, `getTest`)
    this.listItems = []
    let amount = await this.storage.getStorageValue('amount')
    Logger.info(TAG, `getTest amount = ${amount}`)
    if(amount !== 'null'){
      this.total =  parseInt(amount)
    }
    for (let i = 0;i < this.total; i++) {
      let alarmClock = await this.storage.getStorageValue(`alarmClock${i}`)
      if (alarmClock != 'null') {
        let dataTime = JSON.parse(alarmClock).hour + ':' + JSON.parse(alarmClock).minute
        this.listItems.push({ key: `alarmClock${i}`, value: dataTime, reminderId: JSON.parse(alarmClock).reminderId })
      }
    }
    Logger.info(TAG, `ListItem = ${JSON.stringify(this.listItems)}`)
  }

  aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear')
    this.storage.getFromStorage().then(() => {
      this.getTest()
    })
  }

  countChange(result) {
    this.total = result
    Logger.info(TAG, `countChange ${this.total}`)
    this.getTest()
  }

  build() {
    Column() {
      TitleBar()
      Row() {
        Text($r('app.string.alarmClock'))
          .fontSize('30')
        Image($r('app.media.add'))
          .width('30')
          .height('30')
          .margin({ left: '40%' })
          .onClick(() => {
            if (this.datePicker == null) {
              this.datePicker = new CustomDialogController({
                builder: CustomDatePicker({ total: this.total, countChange: this.countChange.bind(this) }),
                autoCancel: true
              })
            }
            this.datePicker.open()
          })
      }
      .margin({ top: 40, bottom: 40 })

      List() {
        ForEach(this.listItems, (item, index) => {
          ListItem() {
            Row() {
              Text(item.value)
                .width('50%')
                .fontSize(30)
              Button() {
                Text($r('app.string.delete'))
                  .fontSize(30)
                  .textAlign(TextAlign.Center)
                  .onClick( async () => {
                    Logger.info(TAG, `key = ${item.key}`)
                    this.storage.deleteSync(item.key)
                    this.listItems.splice(index, 1)
                    reminderAgent.cancelReminder(item.reminderId, () => {
                      Logger.info(TAG, `do next`)
                    })
                  })
              }
              .width('30%')
              .height(50)
              .margin({ left: '20%' })
              .backgroundColor('#0D9FFB')
            }
            .width('100%')
            .padding(15)
            .border({ width: 1, color: '#6b9b9898', style: 0 })
          }
        }, item => item.value)
      }
      .layoutWeight(1)
    }
  }
}