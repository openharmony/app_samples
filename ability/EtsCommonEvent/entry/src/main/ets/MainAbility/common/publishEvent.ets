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
import Logger from './Logger'

const TAG: string = "[PublishEvent]"

@Component
export struct PublishEventView {
  private publishOptions: Resource[] = [$r("app.string.publish"), $r("app.string.publish_specify_commonEvent")]

  publish() {
    // Publish CommonEvent
    commonEvent.publish("event", (err) => {
      if (err.code) {
        Logger.error(TAG, `[CommonEvent]PublishCallBack err = ${JSON.stringify(err)}`)
      } else {
        Logger.info(TAG, "[CommonEvent]Publish1")
      }
    })
  }

  initialPublish() {
    // CommonEvent related information
    var options = {
      code: 1, // Initial code for CommonEvent
      data: "initial data", // Initial data for CommonEvent
    }
    // Publish CommonEvent
    commonEvent.publish("event", options, (err) => {
      if (err.code) {
        Logger.error(TAG, `[CommonEvent]PublishCallBack err = ${JSON.stringify(err)}`)
      } else {
        Logger.info(TAG, "[CommonEvent]Publish2")
      }
    })
  }

  build() {
    Column() {
      ForEach(this.publishOptions, item => {
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
          let index = this.publishOptions.indexOf(item)
          switch (index) {
            case 0:
              Logger.info(TAG, "[CommonEvent]Publish1 onClick")
              this.publish()
              break
            case 1:
              Logger.info(TAG, "[CommonEvent]Publish2 onClick")
              this.initialPublish()
              break
            default:
              break
          }
        })
      }, item => JSON.stringify(item))
    }
  }
}