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
import {Temperature} from '../model/Temperature'

@Component
export struct SleepView {
  @State shortTime: number= 0
  @State longTime: number= 1

  sleepRange() {
    let timeLower = new Temperature(7)
    let timeUpper = new Temperature(10)
    let timeRange = new util.Scope(timeLower, timeUpper)
    let yTimeLower = new Temperature(this.shortTime)
    let yTimeUpper = new Temperature(this.longTime)
    let yTimeRange = new util.Scope(yTimeLower, yTimeUpper)
    let union = timeRange.expand(yTimeRange)
    let interSect = timeRange.intersect(yTimeRange)
    let unionStr = union.toString()
    let interSectStr = interSect.toString()
    AlertDialog.show(
      {
        title: $r('app.string.sleep_analyse'),
        message: '睡眠区间和正常的睡眠区间的并集为' + unionStr + '睡眠区间和正常的睡眠区间的交集为' + interSectStr,
        confirm: {
          value: $r('app.string.determine'),
          action: () => {}
        },
      }
    )
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Row() {
        Text($r('app.string.judge_sleep'))
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
        Text($r('app.string.short_sleep'))
          .width('52%')
          .fontSize(20)
        TextInput({ placeholder: $r('app.string.enter_sleep_time') })
          .width('46%')
          .type(InputType.Number)
          .fontSize(20)
          .fontStyle(FontStyle.Italic)
          .maxLength(20)
          .fontWeight(FontWeight.Bold)
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .enterKeyType(EnterKeyType.Go)
          .onChange((value: string) => {
            this.shortTime = Number(value)
          })
      }
      .margin({ bottom: 4 })
      .padding({ left: 10 })

      Row() {
        Text($r('app.string.long_sleep'))
          .width('52%')
          .fontSize(20)
        TextInput({ placeholder: $r('app.string.enter_sleep_time') })
          .width('46%')
          .type(InputType.Number)
          .fontSize(20)
          .fontStyle(FontStyle.Italic)
          .maxLength(20)
          .fontWeight(FontWeight.Bold)
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .enterKeyType(EnterKeyType.Go)
          .onChange((value: string) => {
            this.longTime = Number(value)
          })
      }
      .margin({ bottom: 4 })
      .padding({ left: 10 })

      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Text($r('app.string.sleep_time'))
          .fontSize(18)
          .fontColor(Color.Red)
      }
      .height('9.5%')
      .padding({ left: 10 })

      Button() {
        Text($r('app.string.sleep_analyse'))
          .fontColor(Color.White)
          .fontSize(16)
          .width('30%')
          .textAlign(TextAlign.Center)
      }
      .type(ButtonType.Capsule)
      .margin({ top: 10, bottom: 10 })
      .backgroundColor(0x317aff)
      .onClick(() => {
        this.sleepRange()
      })
    }
    .width('100%')
    .height('29%')
  }
}