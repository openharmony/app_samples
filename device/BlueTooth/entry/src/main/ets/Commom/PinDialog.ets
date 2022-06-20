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
import bluetooth from '@ohos.bluetooth'
import logger from '../Model/Logger'

const TAG: string = 'PinDialog'

@CustomDialog
export struct PinDialog {
  private controller?: CustomDialogController
  private data: bluetooth.PinRequiredParam | null = null
  @State titleText: string = ''
  @State pinCode: string = ''

  @Builder choiceText(message: Resource, handlerClick) {
    Text(message)
      .width('50%')
      .fontSize(30)
      .textAlign(TextAlign.Center)
      .fontColor('#ff0742ef')
      .onClick(handlerClick)
  }

  aboutToAppear() {
    this.titleText = `"${this.data.deviceId}"要与您配对。请确认此配对码已在"${this.data.deviceId}"上直接显示，且不是手动输入的。`
    this.pinCode = JSON.stringify(this.data.pinCode)
  }

  build() {
    Column({ space: 10 }) {
      Text($r('app.string.match_request'))
        .fontSize(30)
        .alignSelf(ItemAlign.Start)
      Text(this.titleText)
        .alignSelf(ItemAlign.Start)
        .margin({ top: 20 })
        .fontSize(21)
      Text(this.pinCode)
        .fontSize(40)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Checkbox({ name: 'checkbox' })
          .select(false)
          .selectedColor('#ff3d6fb8')
        Text($r('app.string.grant_permission'))
          .fontSize(15)
          .margin({ left: 3, top: 6 })
      }
      .alignSelf(ItemAlign.Start)
      .width('95%')
      .margin({ top: 5 })

      Row() {
        this.choiceText($r('app.string.cancel'), () => {
          bluetooth.setDevicePairingConfirmation(this.data.deviceId, false)
          logger.info(TAG, `setDevicePairingConfirmation = ${bluetooth.setDevicePairingConfirmation(this.data.deviceId, false)}`)
          this.controller.close()
        })

        Divider()
          .vertical(true)
          .height(32)

        this.choiceText($r('app.string.match'), () => {
          bluetooth.setDevicePairingConfirmation(this.data.deviceId, true)
          logger.info(TAG, `setDevicePairingConfirmation = ${bluetooth.setDevicePairingConfirmation(this.data.deviceId, true)}`)
          this.controller.close()
        })
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .padding(15)
  }
}