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

import notify from '@ohos.notification';
import wantAgent from '@ohos.wantAgent';
import prompt from '@system.prompt';
import { getNotificationRequest, getNotificationId } from '../model/notificationUtils'
import { Choose } from '../common/choose'

@Entry
@Component
struct Index {
  @State contentType: number = 0
  private slotType: number = 0

  build() {
    Column() {
      Text($r('app.string.app_name'))
        .width('100%')
        .height(50)
        .backgroundColor('#0D9FFB')
        .fontColor(Color.White)
        .fontSize(20)
        .padding({ left: 15 })
      Scroll() {
        Flex({
          direction: FlexDirection.Row,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Center,
          wrap: FlexWrap.Wrap
        }) {
          Choose({ selectIndex: $contentType })
          Column() {
            Button() {
              Text($r('app.string.add_slot'))
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
            }
            .type(ButtonType.Capsule)
            .margin(10)
            .width(340)
            .height(60)
            .backgroundColor('#0D9FFB')
            .onClick(() => {
              console.info('[notification] addSlot')

              function addSlotCallBack() {
                console.info("[notification]==========================>addSlotCallBack=======================>");
                prompt.showToast({ message: 'Add slot succeed' })
              }

              notify.addSlot(notify.SlotType.CONTENT_INFORMATION, addSlotCallBack)
            })

            Button() {
              Text($r('app.string.publish_notification'))
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
            }
            .type(ButtonType.Capsule)
            .margin(10)
            .width(340)
            .height(60)
            .backgroundColor('#0D9FFB')
            .onClick(() => {
              console.info('[notification]publish notification')
              let WantAgentInfo = {
                wants: [
                  {
                    bundleName: 'ohos.samples.etsnotification',
                    abilityName: 'ohos.samples.etsnotification.MainAbility',
                  }
                ],
                operationType: wantAgent.OperationType.START_ABILITY,
                requestCode: 0
              }
              wantAgent.getWantAgent(WantAgentInfo, (err, data) => {
                if (err.code !== 0) {
                  console.info('[notification]getWantAgent failed,err = ' + JSON.stringify(err))
                  return
                }
                let notificationRequest = getNotificationRequest(this.contentType, data)
                notify.publish(notificationRequest).then(() => {
                  console.info("[notification]==========================>publishCallback=======================>");
                });
              })
            })

            Button() {
              Text($r('app.string.cancel_last_notification'))
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
            }
            .type(ButtonType.Capsule)
            .margin(10)
            .width(340)
            .height(60)
            .backgroundColor('#0D9FFB')
            .onClick(() => {
              console.info('[notification]cancel notification')
              let notificationId = getNotificationId(this.contentType)
              notify.cancel(notificationId, () => {
                console.info("[notification]==========================>cancelAllCallback=======================>");
              })
            })

            Button() {
              Text($r('app.string.cancel_all_notification'))
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
            }
            .type(ButtonType.Capsule)
            .margin(10)
            .width(340)
            .height(60)
            .backgroundColor('#0D9FFB')
            .onClick(() => {
              console.info('[notification]cancel notification')
              notify.cancelAll(() => {
                console.info("[notification]==========================>cancelAllCallback=======================>");
              })
            })

            Button() {
              Text($r('app.string.delete_slot'))
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
            }
            .type(ButtonType.Capsule)
            .margin(10)
            .width(340)
            .height(60)
            .backgroundColor('#0D9FFB')
            .onClick(() => {
              console.info('[notification]delete slot')
              notify.removeSlot(notify.SlotType.CONTENT_INFORMATION, () => {
                console.info("[notification]==========================>removeSlotAllCallback=======================>");
                prompt.showToast({ message: 'Delete slot succeed' })
              })
            })
          }
        }
        .margin({ bottom: 50 })
      }
    }
  }
}