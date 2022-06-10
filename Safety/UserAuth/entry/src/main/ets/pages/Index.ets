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
import userAuth from '@ohos.userIAM.userAuth'
import { AuthCustomDialog } from '../common/AuthCustomDialog'
import { TitleBar } from '../common/TitleBar'
import Logger from '../model/Logger'

const TAG: string = '[Index]'

@Extend(Text) function fancyText () {
  .width('60%')
  .fontSize(20)
  .fontColor(Color.White)
  .textAlign(TextAlign.Center)
}

@Extend(Button) function fancyButton () {
  .height(40)
  .type(ButtonType.Capsule)
  .backgroundColor('#0D9FFB')
  .margin({ top: 20, bottom: 20 })
}

@Entry
@Component
struct Index {
  @State content: string = ''
  @State version: number = 0
  private contextId?: Uint8Array
  private auth: userAuth.UserAuth = new userAuth.UserAuth()
  dialogController: CustomDialogController = new CustomDialogController({
    builder: AuthCustomDialog({ content: this.content, confirm: this.onAccept }),
    autoCancel: true
  })

  onAccept() {
    Logger.info(TAG, 'onAccept')
  }

  aboutToAppear() {
    this.version = this.auth.getVersion()
    Logger.info(TAG, `auth version = ${this.version}`)
    let checkCode = this.auth.getAvailableStatus(userAuth.UserAuthType.FACE, userAuth.AuthTrustLevel.ATL1)
    if (checkCode === userAuth.ResultCode.SUCCESS) {
      Logger.info(TAG, `check support auth success`)
      // 支持指定类型认证的逻辑
      this.dialogShow(null, $r("app.string.support_auth_success"))
    } else {
      Logger.error(TAG, `check support auth fail, checkCode = ${checkCode}`)
      // 不支持指定类型认证的逻辑
      this.dialogShow($r("app.string.support_auth_fail"), $r("app.string.support_auth_message"))
    }
  }

  dialogShow(title: Resource, message: Resource) {
    AlertDialog.show(
      {
        title: title,
        message: message,
        primaryButton: {
          value: 'cancel',
          action: () => {
            Logger.info(TAG, 'dialogShow cancel')
          }
        },
        secondaryButton: {
          value: 'confirm',
          action: () => {
            Logger.info(TAG, 'dialogShow confirm')
          }
        }
      }
    )
  }

  faceAuth() {
    this.contextId = this.auth.auth(null, userAuth.UserAuthType.FACE, userAuth.AuthTrustLevel.ATL1, {
      onResult: (result, extraInfo) => {
          Logger.info(TAG, `faceAuth onResult result = ${result}`)
          Logger.info(TAG, `faceAuth onResult extraInfo = ${JSON.stringify(extraInfo)}`)
          if (result === userAuth.ResultCode.SUCCESS) {
            Logger.info(TAG, `faceAuth onResult success`)
            // 认证成功逻辑
            this.content = 'auth success'
            this.dialogController.open()
          } else {
            Logger.error(TAG, `faceAuth onResult fail`)
            // 认证失败逻辑
            this.content = 'auth fail'
            this.dialogController.open()
          }
      },

      onAcquireInfo: (module, acquire, extraInfo) => {
          Logger.info(TAG, `faceAuth onAcquireInfo module = ${module}`)
          Logger.info(TAG, `faceAuth onAcquireInfo acquire = ${acquire}`)
          Logger.info(TAG, `faceAuth onAcquireInfo extraInfo = ${JSON.stringify(extraInfo)}`)
      }
    })
  }

  cancelAuth() {
    Logger.info(TAG, `cancelAuth contextId = ${this.contextId}`)
    let cancelCode = this.auth.cancelAuth(this.contextId)
    if (cancelCode === userAuth.ResultCode.SUCCESS) {
      Logger.info(TAG, `cancelAuth success`)
      this.dialogShow(null, $r('app.string.cancel_auth_success'))
    } else {
      Logger.error(TAG, `cancelAuth fail`)
      this.dialogShow($r('app.string.cancel_auth_fail'), $r('app.string.cancel_auth_message'))
    }
  }

  build() {
    Row() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        TitleBar()

        Text($r('app.string.camera_tips'))
          .width('90%')
          .height('20%')
          .fontSize(20)
          .textAlign(TextAlign.Center)
          .margin({ bottom: 20 })

        Image($r('app.media.face_auth'))
          .width(150)
          .height(150)
          .animation({
            duration: 2000, // 动画时长
            curve: Curve.EaseOut, // 动画曲线
            delay: 100, // 动画延迟
            iterations: -1, // 播放次数
            playMode: PlayMode.Alternate // 动画模式
          })
          .onClick(() => {
            Logger.info(TAG, 'onClick face_unlock start')
            this.faceAuth()
          })

        Text(`face auth version ${this.version}`)
          .width('90%')
          .height('20%')
          .fontSize(20)
          .textAlign(TextAlign.Center)
          .margin({ bottom: 20 })

        Button() {
          Text($r('app.string.face_unlock'))
            .fancyText()
        }
        .fancyButton()
        .onClick(() => {
          Logger.info(TAG, 'onClick face_unlock start')
          this.faceAuth()
        })

        Button() {
          Text($r('app.string.cancel_auth'))
            .fancyText()
        }
        .fancyButton()
        .onClick(() => {
          Logger.info(TAG, 'onClick cancel_auth start')
          this.cancelAuth()
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}