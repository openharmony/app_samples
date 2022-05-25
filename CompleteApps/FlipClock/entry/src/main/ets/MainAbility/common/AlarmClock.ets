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

import reminderAgent from '@ohos.reminderAgent'
import StorageModel from '../model/StorageModel'
import { CustomDatePicker } from '../common/CustomDataPicker'

@Component
export struct AlarmClock {
  @State total: number = 0
  @Link listItems: Array<unknown>
  @StorageLink('clockTime') clockTime: any = []
  private datePicker: CustomDialogController = null
  private storage: StorageModel = StorageModel.getInstance()
  getTest = async () => {
    this.listItems = []
    let amount = await this.storage.getStorageValue('amount')
    for (let i = 0;i <= amount; i++) {
      let alarmClock = await this.storage.getStorageValue(`alarmClock${i}`)
      if (alarmClock != 'null') {
        let dataTime = JSON.parse(alarmClock).hour + ':' + JSON.parse(alarmClock).minute
        this.listItems.push({ key: `alarmClock${i}`, value: dataTime, reminderId: JSON.parse(alarmClock).reminderId })
      }
    }
  }

  aboutToAppear() {
    this.storage.getFromStorage().then(() => {
      this.getTest()
    })
  }

  countChange(result) {
    this.total = result
    this.getTest()
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text($r('app.string.alarmClock'))
          .fontSize('30vp')
        Text('+')
          .width('60%')
          .height('100%')
          .fontSize('50VP')
          .margin({ right: 20 })
          .textAlign(TextAlign.End)
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
      .height(62)
      .backgroundColor('#ffffff')
      .margin({ top: 40, bottom: 40 })
      .padding({ left: '3%', right: '3%' })

      Scroll() {
        List() {
          ForEach(this.listItems, (item, index) => {
            ListItem() {
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text(item.value)
                  .width('50%')
                  .fontSize('30vp')
                Button($r('app.string.delete'))
                  .onClick(() => {
                    this.storage.deleteSync(item.key)
                    this.listItems.splice(index, 1)
                    reminderAgent.cancelReminder(item.reminderId, () => {
                    })
                  })
                  .width('20%')
                  .height('100%')
                  .backgroundColor('#ff676037')
              }
              .padding(10)
              .width('100%')
            }
            .height(62)
            .borderRadius(24)
            .margin({ bottom: 5 })
            .backgroundColor('#f1f3f5')
          }, item => item.value)
        }
        .height('100%')
      }
      .height('100%')
    }
    .height('100%')
  }
}
