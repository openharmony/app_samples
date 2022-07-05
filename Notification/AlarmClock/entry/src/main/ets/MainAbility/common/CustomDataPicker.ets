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
import Logger from '../mode/Logger'
import StorageModel from '../mode/StorageModel'
import reminderAgent from '@ohos.reminderAgent'

const TAG = 'DatePicker'

@CustomDialog
export struct CustomDatePicker {
  @State hour: number = 0
  @State minute: number = 0
  @State reminderId: number = 0
  @State hourTest: string = ''
  @State minuteTest: string = ''
  private total: number
  private countChange: (result: number) => void
  private selectedTime: Date = new Date()
  private controller: CustomDialogController

  aboutToAppear() {
    this.hour = this.selectedTime.getHours()
    this.minute = this.selectedTime.getMinutes()
    this.hourTest = (this.hour > 9 ? '' : '0') + this.hour
    this.minuteTest = (this.minute > 9 ? '' : '0') + this.minute
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.hour'))
          .fontSize('20')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text($r('app.string.minute'))
          .fontSize('20')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .margin({ top: 20, bottom: 10 })

      Column() {
        TimePicker({
          selected: this.selectedTime,
        })
          .useMilitaryTime(true)
          .onChange((date) => {
            Logger.info(TAG, `TimePickerResult = ${JSON.stringify(date)}`)
            this.hour = date.hour
            this.minute = date.minute
            this.hourTest = (date.hour > 9 ? '' : '0') + date.hour
            this.minuteTest = (date.minute > 9 ? '' : '0') + date.minute
          })
      }
      .height('30%')

      Row() {
        Button($r('app.string.yes'))
          .fontSize(20)
          .layoutWeight(1)
          .fontColor(Color.Blue)
          .backgroundColor('#FFFFFF')
          .onClick(async () => {
            let reminderRequest: reminderAgent.ReminderRequestAlarm = {
              reminderType: reminderAgent.ReminderType.REMINDER_TYPE_ALARM,
              hour: this.hour,
              minute: this.minute,
              title: '闹钟',
              maxScreenWantAgent: {
                pkgName: 'ohos.samples.etsalarmclock',
                abilityName: 'ohos.samples.etsalarmclock.MainAbility'
              },
              ringDuration: 5000
            }
            Logger.info(TAG, `ReminderRequest = ${reminderRequest.hour}`)
            this.reminderId = await reminderAgent.publishReminder(reminderRequest)
            Logger.info(TAG, `reminderId = ${this.reminderId}`)
            let dateTime = { hour: this.hourTest, minute: this.minuteTest, reminderId: this.reminderId }
            Logger.info(TAG, `dateTime = ${JSON.stringify(dateTime)}`)
            StorageModel.getInstance().putStorageValue(`alarmClock${this.total}`, dateTime)
            this.total += 1
            StorageModel.getInstance().putStorageValue('amount', this.total)
            this.controller.close()
            this.countChange(this.total)
          })

        Button($r('app.string.no'))
          .fontSize(20)
          .layoutWeight(1)
          .fontColor(Color.Red)
          .backgroundColor('#FFFFFF')
          .onClick(() => {
            this.controller.close()
          })
      }
      .margin({ top: 10, bottom: 20 })
    }
    .width('100%')
  }
}