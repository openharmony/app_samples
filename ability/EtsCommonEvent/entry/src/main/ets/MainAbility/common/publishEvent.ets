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
import commonEvent from '@ohos.commonevent';

@Component
export struct PublishEventView {
  private pushlishOptions: Resource[] = [$r('app.string.publish'), $r('app.string.publish_specify_commonEvent')]

  publish() {
    // Publish CommonEvent
    commonEvent.publish("event", (err) => {
      console.log('[CommonEvent]PublishCallBack err=' + err)
    });
  }

  initialPublish() {
    // CommonEvent related information
    var options = {
      code: 0, // Initial code for CommonEvent
      data: "initial data", // Initial data for CommonEvent
      isOrdered: true // Orderly CommonEvent
    }
    // Publish CommonEvent
    commonEvent.publish("event", options, (err) => {
      console.log('[CommonEvent]PublishCallBack' + err)
    });
  }

  build(){
    Column(){
      ForEach(this.pushlishOptions, item => {
        Button() {
          Text(item)
            .fontSize(19)
            .fontWeight(FontWeight.Bold)
            .padding({ left: 10, right: 10 })
            .width('100%')
            .textAlign(TextAlign.Center)
        }.type(ButtonType.Capsule)
        .backgroundColor('#0D9FFB')
        .margin({ top: 15 })
        .onClick(() => {
          var index = this.pushlishOptions.indexOf(item)
          switch (index) {
            case 0:
              console.log('[CommonEvent]Publish1 onClick')
              this.publish()
              break
            case 1:
              console.log('[CommonEvent]Unsubscribe onClick')
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