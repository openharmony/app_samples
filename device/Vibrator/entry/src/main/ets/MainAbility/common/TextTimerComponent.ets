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
import vibrator from '@ohos.vibrator'
import { TextDialog } from '../common/TextDialog'
import { TimerPicker } from '../common/TimerPicker'

let TAG = '[TextTimerComponent]'
const HOUR_MS = 3600 * 1000
const MINUTE_MS = 60 * 1000
const SECOND_MS = 1000
const TOTAL = 100

@Component
export struct TextTimerComponent {
  @State @Watch('onChange') hours: number = 0
  @State @Watch('onChange') minutes: number = 0
  @State @Watch('onChange') seconds: number = 0
  @State duration: number = 0
  @State progressValue: number = 0
  @State hourText: string = '00'
  @State minuteText: string = '00'
  @State secondText: string = '00'
  @State textStr: string = ''
  private counts: number
  private timerId: number
  private timerPicker: CustomDialogController = new CustomDialogController({
    builder: TimerPicker({ hours: $hours, minutes: $minutes, seconds: $seconds, duration: $duration }),
    autoCancel: true
  })
  private textDialog: CustomDialogController = new CustomDialogController({
    builder: TextDialog(),
    autoCancel: true
  })

  formatTime(value: number) {
    return (value > 9 ? '' : '0') + value
  }

  onChange() {
    this.hourText = this.formatTime(this.hours)
    this.minuteText = this.formatTime(this.minutes)
    this.secondText = this.formatTime(this.seconds)
    this.textStr = `${this.hourText} : ${this.minuteText} : ${this.secondText}`
  }

  aboutToAppear(){
    this.textStr = `${this.hourText} : ${this.minuteText} : ${this.secondText}`
  }

  build() {
    Column() {
      Progress({ value: this.progressValue, total: TOTAL, style: ProgressStyle.Ring })
        .width(150)
        .margin({ bottom: 60 })

      Row() {
        Text(this.textStr)
          .fontSize(35)
      }
      .margin({ bottom: 80 })
      .onClick(() => {
        this.timerPicker.open()
      })

      Button('start')
        .width(200)
        .fontSize(30)
        .margin({ top: 20 })
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          this.timerId = setInterval(() => {
            Logger.info(TAG, `countdown hours: ${this.hours}, minutes: ${this.minutes }, seconds: ${this.seconds}`)
            this.counts = this.hours * HOUR_MS + this.minutes * MINUTE_MS + this.seconds * SECOND_MS
            this.progressValue += TOTAL / this.duration
            if (this.counts > 0) {
              this.counts = this.counts - SECOND_MS
              Logger.info(TAG, `countdown counts = ${this.counts}, progress = ${this.progressValue}`)

              this.hours = Math.floor(this.counts / HOUR_MS)
              this.counts = this.counts - this.hours * HOUR_MS

              this.minutes = Math.floor(this.counts / MINUTE_MS)
              this.counts = this.counts - this.minutes * MINUTE_MS

              this.seconds = Math.floor(this.counts / SECOND_MS)
            }
            if (this.hours === 0 && this.minutes === 0 && this.seconds === 0) {
              vibrator.vibrate(10000, (error) => {
                if (error) {
                  Logger.error(TAG, `error.code = ${error.code}, error.message = ${error.message}`)
                } else {
                  Logger.info(TAG, `${TAG} Callback returned to indicate a successful vibration`)
                }
                this.textDialog.open()
                setTimeout(() => {
                  this.progressValue = 0
                  clearInterval(this.timerId)
                }, 1000)
              })
            }
          }, 1000)
        })
      Button('reset')
        .width(200)
        .fontSize(30)
        .margin({ top: 40 })
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          this.progressValue = 0
          this.hourText = '00'
          this.minuteText = '00'
          this.secondText = '00'
          clearInterval(this.timerId)
        })
    }
    .width('100%')
    .height('100%')
  }
}