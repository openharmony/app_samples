/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
import commonEvent from '@ohos.commonEvent'
import prompt from '@ohos.prompt'
import Logger from './Logger'

const TAG: string = "[SubscribeEvent]"

@Component
export struct SubscribeEventView {
  private subscribeOptions: Resource[] = [$r("app.string.create_subscriber"), $r("app.string.subscribe"), $r("app.string.unsubscribe")]
  private subscriber = null
  @Link result: string

  createSubscriber() {
    // Subscriber information
    var subscribeInfo = {
      events: ["event"],
    }

    // Create subscriber callback
    commonEvent.createSubscriber(subscribeInfo, (err, subscriber) => {
      if (err.code) {
        Logger.error(TAG, `[CommonEvent]CreateSubscriberCallBack err = ${JSON.stringify(err)}`)
      } else {
        Logger.log(TAG, "[CommonEvent]CreateSubscriber")
        this.subscriber = subscriber
        this.result = "Create subscriber succeed"
      }
    })
  }

  subscribe() {
    // Subscribe
    if (this.subscriber != null) {
      commonEvent.subscribe(this.subscriber, (err, data) => {
        if (err.code) {
          Logger.error(TAG, `[CommonEvent]SubscribeCallBack err= = ${JSON.stringify(err)}`)
        } else {
          Logger.info(TAG, `[CommonEvent]SubscribeCallBack data= = ${JSON.stringify(data)}`)
          this.result = `receive, event = ${data.event} , data = ${data.data}, code = ${data.code}`
        }
      })
      this.result = "Subscribe succeed"
    } else {
      prompt.showToast({ message: "Need create subscriber" })
    }
  }

  unsubscribe() {
    // Unsubscribe CommonEvent
    if (this.subscriber != null) {
      commonEvent.unsubscribe(this.subscriber, (err) => {
        if (err.code) {
          Logger.error(TAG, `[CommonEvent]UnsubscribeCallBack err= = ${JSON.stringify(err)}`)
        } else {
          Logger.info(TAG, "[CommonEvent]Unsubscribe")
          this.subscriber = null
          this.result = "Unsubscribe succeed"
        }
      })
    }
  }

  build() {
    Column() {
      ForEach(this.subscribeOptions, item => {
        Button() {
          Text(item)
            .fontSize(19)
            .fontWeight(FontWeight.Bold)
            .padding({ left: 10, right: 10 })
            .width("100%")
            .textAlign(TextAlign.Center)
        }
        .type(ButtonType.Capsule)
        .backgroundColor("#0D9FFB")
        .margin({ top: 15 })
        .onClick(() => {
          let index = this.subscribeOptions.indexOf(item)
          switch (index) {
            case 0:
              Logger.info(TAG, "[CommonEvent]CreateSubscriber onClick")
              this.createSubscriber()
              break
            case 1:
              Logger.info(TAG, "[CommonEvent]Subscribe onClick")
              this.subscribe()
              break
            case 2:
              Logger.info(TAG, "[CommonEvent]Unsubscribe onClick")
              this.unsubscribe()
              break
            default:
              break
          }
        })
      }, item => JSON.stringify(item))
    }
  }
}
