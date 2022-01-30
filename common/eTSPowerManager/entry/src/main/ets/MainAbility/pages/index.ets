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

import power from '@ohos.power';

@Entry
@Component
struct Index {
  @State window: string = ''
  private num: number = 0
  private buttonText: Resource[] = [$r('app.string.turnOff'), $r('app.string.restart'), $r('app.string.checkState')]

  dialog(title:Resource, message:Resource) {
    AlertDialog.show(
      {
        title: title,
        message: message,
        primaryButton: {
          value: $r('app.string.cancel'),
          action: () => {
            console.info(`Callback when the first button is clicked`)
          }
        },
        secondaryButton: {
          value: $r('app.string.determine'),
          action: () => {
            console.info(`Callback when the second button is clicked`)
            if (title === $r('app.string.turnOff')) {
              this.window = 'Is power off'
              power.shutdownDevice('shutdown_test');
              console.info(`power_shutdown_device_test success`)
            } else {
              this.window = 'Is to restart'
              power.rebootDevice('');
              console.info(`power_reboot_device_test success`)
            }
          }
        },
        cancel: () => {
          console.info(`Closed callbacks`)
        }
      }
    )
  }

  checkState() {
    power.isScreenOn((error, screenOn) => {
      if (typeof error === 'undefined') {
        this.window = 'screenOn status is' + screenOn
        console.log(this.window);
      } else {
        console.log(`error: ${error}`);
      }
    })
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Row() {
        Text($r('app.string.entry_MainAbility'))
          .fontColor(Color.White)
          .fontSize(20)
      }
      .size({ width: '100%', height: 50 })
      .padding({ left: 15 })
      .backgroundColor('#0D9FFB')

      Text(this.window)
        .width('90%')
        .height(100)
        .border({ width: 2, radius: 10, color: Color.Black })
        .margin({ top: 20 })
        .padding({ left: 10 })
        .fontSize(20)
        .fontWeight(FontWeight.Bold)


      ForEach(this.buttonText, (item, index) => {
        Button() {
          Text(item)
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }
        .width('80%')
        .margin({ top: '20' })
        .type(ButtonType.Capsule)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          index = this.buttonText.indexOf(item)
          switch (index) {
            case 0:
              this.dialog($r('app.string.turnOff'), $r('app.string.questionTurnOff'))
              break
            case 1:
              this.dialog($r('app.string.restart'), $r('app.string.questionRestart'))
              break
            case 2:
              this.checkState()
              break
            default:
              break
          }
        })
      }, item => JSON.stringify(item))
    }
    .width('100%')
    .height('100%')
  }
}
