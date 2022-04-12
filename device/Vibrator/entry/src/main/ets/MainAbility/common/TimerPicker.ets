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
import TimerData  from '../mode/TimerData'

let TAG = '[TimerPicker]'
const HOURS = 3600
const MINUTES = 60

@CustomDialog
export struct TimerPicker {
  @State hour: number = 0
  @State minute: number = 0
  @State second: number = 0
  @Link hours: number
  @Link minutes: number
  @Link seconds: number
  @Link duration: number
  private selectedTime: Date = new Date()
  private timerData: TimerData = new TimerData()
  private fruitsHour: Array<string>
  private fruitsMinute: Array<string>
  private fruitsSecond: Array<string>
  private controller: CustomDialogController

  aboutToAppear() {
    this.fruitsHour = this.timerData.hourData()
    this.fruitsMinute = this.timerData.timeData()
    this.fruitsSecond = this.timerData.timeData()
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.hour'))
          .fontSize(20)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text($r('app.string.minute'))
          .fontSize(20)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text($r('app.string.second'))
          .fontSize(20)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .margin({ top: 20, bottom: 20 })

      Row() {
        TextPicker({
          range: this.fruitsHour
        })
          .layoutWeight(1)
          .onChange((value: string, index: number) => {
            Logger.info(TAG, `Picker item changed, fruitsHour value: ${value}, index: ${index}`)
            this.hour = parseInt(value, 10)
          })
        TextPicker({
          range: this.fruitsMinute
        })
          .layoutWeight(1)
          .onChange((value: string, index: number) => {
            Logger.info(TAG, `Picker item changed, fruitsHour value: ${value}, index: ${index}`)
            this.minute = parseInt(value, 10)
          })
        TextPicker({
          range: this.fruitsSecond
        })
          .layoutWeight(1)
          .onChange((value: string, index: number) => {
            Logger.info(TAG, `Picker item changed, fruitsHour value: ${value}, index: ${index}`)
            this.second = parseInt(value, 10)
          })
      }
      .height('30%')

      Row() {
        Text($r('app.string.yes'))
          .fontSize(20)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.hours = this.hour
            this.minutes = this.minute
            this.seconds = this.second
            this.duration = this.hour * HOURS + this.minute * MINUTES + this.second
            Logger.info(TAG, `hours: ${ this.hours }, minutes: ${ this.minutes }, seconds: ${ this.seconds}`)
            this.controller.close()
          })

        Text($r('app.string.no'))
          .fontSize(20)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.controller.close()
          })
      }
      .margin({ top: 20, bottom: 20 })
    }
    .width('100%')
  }
}