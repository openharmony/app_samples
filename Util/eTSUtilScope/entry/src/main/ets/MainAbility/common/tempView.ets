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

import util from '@ohos.util'
import {Temperature} from '../model/temperature'

@Component
export struct TempView {
  @State tempMorning: number= 0
  @State tempNoon: number= 1
  @State tempNight: number= 2

  alertDialog(title, message, value) {
    AlertDialog.show(
      {
        title: title,
        message: message,
        confirm: {
          value: value
        },
      }
    )
  }

  tempRange() {
    let arr = [this.tempMorning, this.tempNoon, this.tempNight]
    arr.sort(function (a, b) {
      return a - b
    })
    let max = arr[2]
    let min = arr[0]
    let newMax = new Temperature(max)
    let newMin = new Temperature(min)
    let range = new util.Scope(newMin, newMax)
    let lower = range.getLower()
    let upper = range.getUpper()
    let tempLower = new Temperature(36)
    let tempUpper = new Temperature(37.2)
    let standardRange = new util.Scope(tempLower, tempUpper)
    console.log('[eTSUtilScope.TempView] lower=' + lower + '[eTSUtilScope.TempView] upper=' + upper
    + '[eTSUtilScope.TempView] standardRange=' + standardRange)
    if (standardRange.contains(lower) && standardRange.contains(upper)) {
      this.alertDialog($r('app.string.temperature'), '您今天的最低体温是' + lower + '您今天的最高体温是'
      + upper + '您的体温在正常范围', $r('app.string.determine'))
    } else {
      this.alertDialog($r('app.string.temperature'), $r('app.string.temp_message_abnormal'), $r('app.string.determine'))
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Row() {
        Text($r('app.string.judge_temp'))
          .fontSize(20)
          .fontColor(Color.White)
          .backgroundColor(Color.Gray)
          .textAlign(TextAlign.Start)
          .margin({ top: 2 })
      }
      .height('12%')
      .margin({ bottom: 8 })
      .padding({ left: 6 })

      Row() {
        Text($r('app.string.temp_morning'))
          .width('45%')
          .fontSize(20)
        TextInput({ placeholder: $r('app.string.morning_placeholder') })
          .width('54%')
          .type(InputType.Number)
          .fontSize(20)
          .fontStyle(FontStyle.Italic)
          .maxLength(20)
          .fontWeight(FontWeight.Bold)
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .enterKeyType(EnterKeyType.Go)
          .onChange((value: string) => {
            this.tempMorning = Number(value)
          })
      }
      .margin({ bottom: 4 })
      .padding({ left: 10 })

      Row() {
        Text($r('app.string.temp_noon'))
          .width('45%')
          .fontSize(20)
        TextInput({ placeholder: $r('app.string.noon_placeholder') })
          .width('54%')
          .type(InputType.Number)
          .fontSize(20)
          .fontStyle(FontStyle.Italic)
          .maxLength(20)
          .fontWeight(FontWeight.Bold)
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .enterKeyType(EnterKeyType.Go)
          .onChange((value: string) => {
            this.tempNoon = Number(value)
          })
      }
      .margin({ bottom: 4 })
      .padding({ left: 10 })

      Row() {
        Text($r('app.string.temp_night'))
          .width('45%')
          .fontSize(20)
        TextInput({ placeholder: $r('app.string.night_placeholder') })
          .width('54%')
          .type(InputType.Number)
          .fontSize(20)
          .fontStyle(FontStyle.Italic)
          .maxLength(20)
          .fontWeight(FontWeight.Bold)
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .enterKeyType(EnterKeyType.Go)
          .onChange((value: string) => {
            this.tempNight = Number(value)
          })
      }
      .padding({ left: 10 })

      Button() {
        Text($r('app.string.temp_analyse'))
          .fontColor(Color.White)
          .fontSize(16)
          .width('30%')
          .textAlign(TextAlign.Center)
      }
      .type(ButtonType.Capsule)
      .margin({ top: 10, bottom: 10 })
      .backgroundColor(0x317aff)
      .onClick(() => {
        this.tempRange()
      })
    }
    .width('100%')
    .height('29%')
  }
}