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
import {TempView} from '../common/TempView'
import {SleepView} from '../common/SleepView'

@Entry
@Component
struct Index {
  @State age: number= 0
  @State tempMorning: number= 0
  @State tempNoon: number= 1
  @State tempNight: number= 2
  @State shortTime: number= 0
  @State longTime: number= 0

  dialog(title, message, value) {
    AlertDialog.show(
      {
        title: title,
        message: message,
        confirm: {
          value: value,
          action: () => {
          }
        },
      }
    )
  }

  ageRange() {
    let tempLower = new Temperature(18)
    let tempUpper = new Temperature(62)
    let range = new util.Scope(tempLower, tempUpper)
    let ageTemp = new Temperature(this.age)
    if (range.contains(ageTemp)) {
      this.dialog($r('app.string.age'), $r('app.string.age_message_confirm'), $r('app.string.determine'))
    } else {
      this.dialog($r('app.string.age'), $r('app.string.age_message_not_confirm'), $r('app.string.determine'))
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Text($r('app.string.range'))
        .textAlign(TextAlign.Center)
        .width('100%')
        .height('8%')
        .backgroundColor("#0D9FFB")
        .fontSize(25)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)


      Row() {
        Text($r('app.string.judge_age'))
          .fontSize(20)
          .fontColor(Color.White)
          .backgroundColor(Color.Gray)
          .textAlign(TextAlign.Start)
          .margin({ top: 2 })
      }
      .height('5%')
      .margin({ bottom: 8, top: 5 })
      .padding({ left: 6 })

      Row({ space: 5 }) {
        TextInput({ placeholder: $r('app.string.age_placeholder') })
          .height('100%')
          .width('60%')
          .type(InputType.Number)
          .fontSize(24)
          .fontStyle(FontStyle.Italic)
          .maxLength(20)
          .fontWeight(FontWeight.Bold)
          .placeholderFont({ size: 24, weight: FontWeight.Normal })
          .enterKeyType(EnterKeyType.Go)
          .onChange((value: string) => {
            this.age = Number(value)
          })

        Button() {
          Text($r('app.string.age_analyse'))
            .fontColor(Color.White)
            .fontSize(16)
            .width('30%')
            .textAlign(TextAlign.Center)
            .lineHeight(26)
        }
        .type(ButtonType.Capsule)
        .backgroundColor(0x317aff)
        .onClick(() => {
          this.ageRange();
        })
      }
      .height('6%')
      .margin({ bottom: 10 })

      TempView()
      SleepView()
    }
    .width('100%').height('100%')

  }
}