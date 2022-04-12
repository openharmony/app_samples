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
import vibrator from '@ohos.vibrator'
import Logger from '../mode/Logger'

let TAG = '[TextDialog]'

@CustomDialog
export struct TextDialog {
  private controller: CustomDialogController

  build() {
    Column() {
      Text($r('app.string.prompt'))
        .fontSize(25)
        .fontWeight(20)
        .margin(10)
        .fontColor('#1a1919')
        .textAlign(TextAlign.Center)
      Text($r('app.string.dialogText'))
        .fontSize(20)
      Row() {
        Button() {
          Text($r('app.string.yes'))
            .fontSize(30)
        }
        .backgroundColor(Color.White)
        .margin({ top: 20, right: 40, bottom: 20 })
        .onClick(() => {
          vibrator.stop(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME, (error) => {
            if (error) {
              Logger.error(TAG, `error.code: ${error.code} , error.message: ${error.message}`)
            } else {
              Logger.info(TAG, `Callback returned to indicate successful.`)
            }
            this.controller.close()
          })
        })

        Divider()
          .height(30)
          .vertical(true)
          .strokeWidth(2)
          .color('#999999')
        Button() {
          Text($r('app.string.no'))
            .fontSize(30)
        }
        .backgroundColor(Color.White)
        .margin({ top: 20, left: 40, bottom: 20 })
        .onClick(() => {
          this.controller.close()
        })
      }
    }

  }
}