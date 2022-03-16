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

import HiLog from '../mode/HiLog.ets'
import StorageModel from '../mode/StorageModel.ets'
import reminderAgent from '@ohos.reminderAgent'

const TAG = 'DatePicker'
let ReminderRequest = {
  reminderType: reminderAgent.ReminderType.REMINDER_TYPE_ALARM,
  hour: 0,
  minute: 0,
  title: '闹钟',
  maxScreenWantAgent: {
    pkgName: 'ohos.samples.etsalarmclock',
    abilityName: 'ohos.samples.etsalarmclock.MainAbility'
  },
  ringDuration: 5000
}

@CustomDialog
export struct CustomDatePicker {
  @Link total: number
  @State hour: number = 0
  @State minute: number = 0
  @State reminderId: number = 0
  @State hourTest: string = ''
  @State minuteTest: string = ''
  private selectedTime: Date = new Date()
  private controller: CustomDialogController

  build() {
    Column() {
      Row() {
        Text($r('app.string.hour'))
          .fontSize('20')
          .margin({ right: '20%' })

        Text($r('app.string.minute'))
          .fontSize('20')
          .margin({ left: '20%' })
      }
      .margin({ top: 20, bottom: 10 })

      Column() {
        DatePicker({
          start: new Date('00:00:00'),
          end: new Date('23:59:59'),
          selected: this.selectedTime,
          type: DatePickerType.Time
        })
          .useMilitaryTime(true)
          .onChange((date: DatePickerResult) => {
            HiLog.info(TAG, `DatePickerResult = ${JSON.stringify(date)}`)
            this.hour = date.hour
            this.minute = date.minute
            this.hourTest = (date.hour > 9 ? '' : '0') + date.hour
            this.minuteTest = (date.minute > 9 ? '' : '0') + date.minute
          })
      }
      .height('30%')

      Row() {
        Text($r('app.string.yes'))
          .fontSize('20')
          .margin({ right: '20%' })
          .onClick(async () => {
            ReminderRequest.hour = this.hour
            ReminderRequest.minute = this.minute
            this.reminderId = await reminderAgent.publishReminder(ReminderRequest)
            HiLog.log(TAG, `reminderId = ${this.reminderId}`)
            let dateTime = { hour: this.hourTest, minute: this.minuteTest, reminderId: this.reminderId }
            HiLog.log(TAG, `dateTime = ${JSON.stringify(dateTime)}`)
            StorageModel.getInstance().putStorageValue(`alarmClock${this.total}`, dateTime)
            StorageModel.getInstance().putStorageValue('amount', this.total)
            this.total += 1
            this.controller.close()
          })

        Text($r('app.string.no'))
          .fontSize('20')
          .margin({ left: '20%' })
          .onClick(() => {
            this.controller.close()
          })
      }
      .margin({ top: 10, bottom: 20 })
    }
    .width('100%')
  }
}