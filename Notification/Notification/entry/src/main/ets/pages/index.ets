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

import router from '@ohos.router';
import mediaquery from '@ohos.mediaquery';
import notify from '@ohos.notification';
import wantAgent from '@ohos.wantAgent';
import prompt from '@system.prompt';
import Logger from './utils/logger'

const TAG: string = "[Notification]"
async function routePage() {
  let options = {
    uri: 'pages/second'
  }
  try {
    await router.push(options)
  } catch (err) {
    console.error(`fail callback, code: ${err.code}, msg: ${err.msg}`)
  }
}

let tvFunc = null;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button() {
          Text('订阅通知')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('35%')
        .height('5%')
        .onClick(subscribe)

        Button() {
          Text('取消订阅')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('35%')
        .height('5%')
        .onClick(unSubscribe)

        Button() {
          Text('发布通知(普通文本)')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('35%')
        .height('5%')
        .onClick(sendNotify)

        Button() {
          Text('发布通知(wantAgent)')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('35%')
        .height('5%')
        .onClick(sendNotifyWant)

        Button() {
          Text('取消通知')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('35%')
        .height('5%')
        .onClick(cancelNotify)
      }
      .width('100%')
    }
    .height('100%')
  }
}

let subscriber = {
  onConsume: function (data) {
    let req = data.request;
    Logger.info(TAG, `===>onConsume callback req.id: ${req.id}`);
    let message = `Receive notification: ${req.id}`;
    prompt.showToast({ message });
    let wantAgt = req.wantAgent;
    if (wantAgt) {
      wantAgent.getWant(wantAgt)
        .then(data1 => {
          let message = JSON.stringify(data1);
          Logger.info(TAG, `===>getWant success want: ${message}`);
          prompt.showToast({ message });
        }).catch((err) => {
        Logger.error(TAG, `===>getWant failed because ${JSON.stringify(err)}`);
      });
    }
  },
  onCancel: function (data) {
    let req = data.request;
    Logger.info(TAG, `===>onCancel callback req.id: ${req.id}`);
    let message = `onCancel callback data: ${req.id}`;
    prompt.showToast({ message });
  },
  onUpdate: function (data) {
    Logger.info(TAG, '===>onUpdate in test');
    let message = `onUpdate callback data: ${data};`;
    prompt.showToast({ message });
  },
  onConnect: function () {
    Logger.info(TAG, '===>onConnect in test');
  },
  onDisconnect: function () {
    Logger.info(TAG, '===>onDisConnect in test');
  },
  onDestroy: function () {
    Logger.info(TAG, '===>onDestroy in test');
  },
  onDisturbModeChange: function () {
    Logger.info(TAG, '===>onDisturbModeChange in test');
  },
  onDoNotDisturbDateChange: function () {
    Logger.info(TAG, '===>onDoNotDisturbDateChange in test');
  },
};

function subscribe() {
  //this.sub = subscriber;
  notify.subscribe(subscriber, (err) => { // callback形式调用异步接口
    if (err.code) {
      Logger.error(TAG, `===>failed to subscribe because ${JSON.stringify(err)}`);
      return;
    }
    Logger.info(TAG, '===>subscribeTest success');
    let message = "subscribe success";
    prompt.showToast({ message });
  });
}

function unSubscribe() {
  notify.unsubscribe(subscriber, (err) => {
    if (err.code) {
      Logger.error(TAG, `===>failed to unsubscribe because ${JSON.stringify(err)}`);
      return;
    }
    Logger.info(TAG, '===>unsubscribeTest success');
    let message = "unsubscribe success";
    prompt.showToast({ message });
  });
}

let id = 1;
let label = 'TEST' + id;
let userId = 100;

//WantAgentInfo对象
let wantAgentInfo = {
  wants: [
    {
      bundleName: 'ohos.samples.notification',
      abilityName: 'ohos.samples.notification.MainAbility',
    }
  ],
  operationType: wantAgent.OperationType.START_ABILITY,
  requestCode: 0,
  wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
}

//构造NotificationRequest对象
let notificationRequest = {
  content: {
    contentType: notify.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
    normal: {
      title: "AceApplication_Title",
      text: "AceApplication_Text",
      additionalText: "AceApplication_AdditionalText"
    },
  },
  id: 0,
  label: '',
  wantAgent: '',
  slotType: notify.SlotType.OTHER_TYPES,
  deliveryTime: new Date().getTime()
}

function sendNotifyWant() {
  wantAgentInfo.requestCode = id;
  // 获取wantAgent对象
  wantAgent.getWantAgent(wantAgentInfo)
    .then((data) => {
      Logger.info(TAG, `===>Dpitest onShow getWantAgent : ${JSON.stringify(data)}`);
      notificationRequest.wantAgent = data;
      notificationRequest.id = id;
      notificationRequest.label = label;
      Logger.info(TAG, `===>Dpitest onShow wantAgentData: ${JSON.stringify(notificationRequest.wantAgent)}`);
      //通知发送
      notify.publish(notificationRequest)
      id += 1;
      Logger.info(TAG, `===>Dpitest onShow finished===>`);
    })
    .then((data) => {
      Logger.info(TAG, `===>publish promise success req.id : ${notificationRequest.id}`);
    })
}

function sendNotify() {
  //构造NotificationRequest对象
  let notification = {
    id: 0,
    label: '',
    content: {
      contentType: notify.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
      normal: {
        title: "test_title",
        text: "test_text",
        additionalText: "test_additionalText"
      }
    }
  }

  //通知发送
  notification.id = id;
  notification.label = label;
  notify.publish(notification).then((data) => {
    Logger.info(TAG, `===>publish promise success req.id : ${notification.id}`);
  }).catch((err) => {
    Logger.error(TAG, `===>publish promise failed because ${JSON.stringify(err)}`);
  });
  id += 1;
}

function cancelNotify() {
  var cancelId = id - 1;
  console.info('===>cancel notification id : ${cancelId}');
  notify.cancel(cancelId, label, (err, data) => {
    if (err.code) {
      Logger.error(TAG, `===>failed to cancel because ${JSON.stringify(err)}`);
      return;
    }
    Logger.info(TAG, `===>success data : ${JSON.stringify(data)}`);
  });
}