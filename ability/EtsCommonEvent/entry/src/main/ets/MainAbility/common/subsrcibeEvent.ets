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
import prompt from '@system.prompt';

@Component
export struct SubsrcibeEventView {
  private subsrcibeOptions: Resource[] = [$r('app.string.create_subscriber'), $r('app.string.subscribe'), $r('app.string.unsubscribe')]
  private subscriber = null
  @Link result:string

  createSubscriber() {
    // Subscriber information
    var subscribeInfo = {
      events: ["event"],
      priority: 100
    };
    // Create subscriber callback
    commonEvent.createSubscriber(subscribeInfo, (err, data) => {
      console.log('[CommonEvent]CreateSubscriberCallBack')
      this.subscriber = data;
      this.result = 'createSubscriber succeed'
    })
  }

  subscribe() {
    // Subscribe
    if (this.subscriber != null) {
      commonEvent.subscribe(this.subscriber, (err, data) => {
        console.log('[CommonEvent]SubscribeCallBack' + JSON.stringify(data))
        this.result = 'receive ,event = ' + data.event + ',data = ' + data.data
      });
      this.result = 'subscribe succeed'
    } else {
      prompt.showToast({ message: 'need createSubscriber' })
    }
  }

  unSubscribe() {
    // Unsubscribe CommonEvent
    if (this.subscriber != null) {
      commonEvent.unsubscribe(this.subscriber, () => {
        console.log('[CommonEvent]UnsubscribeCallBack')
        this.subscriber = null
        this.result = 'unsubscribe succeed'
      })
    }
  }

  build() {
    Column() {
      ForEach(this.subsrcibeOptions, item => {
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
          var index = this.subsrcibeOptions.indexOf(item)
          switch (index) {
            case 0:
              console.log('[CommonEvent]CreateSubscriber onClick')
              this.createSubscriber()
              break
            case 1:
              console.log('[CommonEvent]Subscribe onClick')
              this.subscribe()
              break
            case 2:
              console.log('[CommonEvent]Publish onClick')
              this.unSubscribe()
              break
            default:
              break
          }
        })
      }, item => JSON.stringify(item))
    }
  }
}