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

import emitter from '@ohos.events.emitter'

const EVENT_ID: number = 1000

@Entry
@Component
struct Second {
  @State message: string = 'Callee Ability'
  @State receivedMsg: string = ''

  private onMsgChange = (eventData) => {
    this.receivedMsg = eventData.data.receivedMsg
  }

  aboutToAppear() {
    var innerEvent = { eventId: EVENT_ID }
    emitter.on(innerEvent, this.onMsgChange)
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Text(this.receivedMsg)
          .fontSize(16)
          .width('35%')
          .margin({ top: 10 })
          .constraintSize({ minHeight: 40 })
          .padding(10)
          .border({ width: 1, color: Color.Gray, radius: 20 })
      }
      .width('100%')
    }
    .height('100%')
  }
}