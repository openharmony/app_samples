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
import prompt from '@system.prompt'
import { ServiceModel } from '../model/ServiceModel'
import { TitleBar } from '../component/TitleBar'
import { OperateView } from '../component/OperateView'
import rpc from "@ohos.rpc"
import reminderAgent from '@ohos.reminderAgent';
import notification from '@ohos.notification';
import logger from '../utils/logger'

const TAG = "flybirdDebug"

async function routePage() {
  let options = {
    url: 'pages/selects'
  }
  try {
    await router.push(options)
  } catch (err) {
    logger.error('fail callback,code: ${err.code},msh: ${err.msg}')
  }
}

@Entry
@Component
struct Index {
  private btnResources: Array<Resource> = [$r('app.string.connect_service'), $r('app.string.disconnect_service'), $r('app.string.set_alarm'), $r('app.string.set_calendar'), $r('app.string.start_game')]
  private serviceModel = new ServiceModel()
  private isStart: boolean = false;
  @State beforeSortString: string = ''
  @State afterSortString: string = ''

  async sortString() {
    logger.log(`${TAG} sortString begin`)
    let mRemote = this.serviceModel.getRemoteObject()
    if (mRemote === null) {
      prompt.showToast({
        message: 'please connect service'
      })
    }
    if (this.beforeSortString.length === 0) {
      prompt.showToast({
        message: 'please input a string'
      })
    }
    let option: rpc.MessageOption = new rpc.MessageOption()
    let data: rpc.MessageParcel = rpc.MessageParcel.create()
    let reply: rpc.MessageParcel = rpc.MessageParcel.create()
    data.writeString(this.beforeSortString)
    await mRemote.sendRequest(1, data, reply, option)
    let msg = reply.readString()
    this.afterSortString = msg
  }

  async setGameRenmindAlarm() {
    logger.log(`${TAG} setGameRenmindAlarm begin`)

    // publish reminder
    let reminder: reminderAgent.ReminderRequestAlarm = {
      reminderType: reminderAgent.ReminderType.REMINDER_TYPE_ALARM,
      hour: 7,
      minute: 24,
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      actionButton: [
        {
          title: "snooze",
          type: reminderAgent.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE,
        }
      ],
      wantAgent: {
        pkgName: "com.example.flybird",
        abilityName: "com.example.flybird.MainAbility"
      },
      maxScreenWantAgent: {
        pkgName: "com.example.flybird",
        abilityName: "com.example.flybird.MainAbility"
      },
      ringDuration: 10,
      snoozeTimes: 2,
      timeInterval: 5 * 60,
      snoozeContent: "later",
      title: "game alarm",
      content: "remember play game",
      expiredContent: "expiredContent",
      notificationId: 200,
    }
    reminderAgent.publishReminder(reminder);
  }

  async callback(err, data) {
    if (err) {
      logger.error(TAG + " setGameRenmindAlarm failed Cause: " + err);
    } else {
      logger.info(TAG + " setGameRenmindAlarm succeeded");
    }
  }

  async setGameRenmindCalendar() {
    logger.log(`${TAG} setGameRenmindCalendar begin`)
    let calendar: {
      reminderType: reminderAgent.ReminderType.REMINDER_TYPE_CALENDAR,
      dateTime: {
        year: 2022,
        month: 4,
        day: 14,
        hour: 7,
        minute: 50,
        second: 30
      },
      repeatMonths: [1],
      repeatDays: [1],
      wantAgent: {
        pkgName: "com.example.flybird",
        abilityName: "com.example.flybird.MainAbility"
      },
      maxScreenWantAgent: {
        pkgName: "com.example.flybird",
        abilityName: "com.example.flybird.MainAbility"
      },
      ringDuration: 5,
      snoozeTimes: 2,
      timeInterval: 5,
      title: "game calendar",
      content: "game calender",
      expiredContent: "this reminder has expired",
      snoozeContent: "remind later",
      notificationId: 100,
      slotType: notification.SlotType.SOCIAL_COMMUNICATION
    }
    reminderAgent.publishReminder(calendar);
  }

  async disconenctService() {
    logger.log(`${TAG} disconenctService begin`)
    let mRemote = this.serviceModel.getRemoteObject()
    if (mRemote === null) {
      prompt.showToast({
        message: 'please connect service'
      })
    }

    let option: rpc.MessageOption = new rpc.MessageOption()
    let data: rpc.MessageParcel = rpc.MessageParcel.create()
    let reply: rpc.MessageParcel = rpc.MessageParcel.create()
    data.writeString("disconnect_service")
    await mRemote.sendRequest(1, data, reply, option)
    let msg = reply.readString()
    this.afterSortString = msg
  }

  async restartMusic() {
    logger.log(`${TAG} restartMusic begin`)
    let mRemote = this.serviceModel.getRemoteObject()
    if (mRemote === null) {
      prompt.showToast({
        message: 'please connect service'
      })
    }

    let option: rpc.MessageOption = new rpc.MessageOption()
    let data: rpc.MessageParcel = rpc.MessageParcel.create()
    let reply: rpc.MessageParcel = rpc.MessageParcel.create()
    data.writeString("restart_music")
    await mRemote.sendRequest(1, data, reply, option)
    let msg = reply.readString()
    this.afterSortString = msg
  }

  async startGame() {
    let mRemote = this.serviceModel.getRemoteObject()
    if (mRemote === null) {
      prompt.showToast({
        message: 'please connect service'
      })
    } else {
      if (!this.isStart) {
        this.startGameEx()
        this.isStart = true
      } else {
        this.restartMusic()
      }
      routePage()
    }
  }

  async startGameEx() {
    logger.log(`${TAG} startGame begin`)
    let mRemote = this.serviceModel.getRemoteObject()
    if (mRemote === null) {
      prompt.showToast({
        message: 'please connect service'
      })
    }

    let option: rpc.MessageOption = new rpc.MessageOption()
    let data: rpc.MessageParcel = rpc.MessageParcel.create()
    let reply: rpc.MessageParcel = rpc.MessageParcel.create()
    data.writeString("start_game")
    await mRemote.sendRequest(1, data, reply, option)
    let msg = reply.readString()
    this.afterSortString = msg
  }

  build() {
    Column() {
      TitleBar()
      Scroll() {
        Column() {
          OperateView({ before: $beforeSortString, after: $afterSortString })
          ForEach(this.btnResources, (item, index) => {
            Button() {
              Text(item)
                .fontColor(Color.White)
                .fontSize(20)
            }
            .type(ButtonType.Capsule)
            .backgroundColor('#0D9FFB')
            .width('94%')
            .height(50)
            .margin(10)
            .onClick(() => {
              logger.info(`${TAG} button clicked,index=${index}`)
              switch (index) {
                case 0:
                  this.serviceModel.connectService()
                  break
                case 1:
                  this.disconenctService();
                  this.serviceModel.disconnectService()
                  break
                case 2:
                  this.setGameRenmindAlarm();
                  break
                case 3:
                  this.setGameRenmindCalendar();
                  break
                case 4:
                  this.startGame()
                  break
                default:
                  break
              }
            })
          }, item => JSON.stringify(item))
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}