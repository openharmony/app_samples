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

import router from '@system.router'
import Logger from '../model/Logger'
import { AccountData } from '../model/AccountData'
import { AccountModel } from '../model/AccountModel'

const TAG = '[LoginInfo]'

@Component
export struct LoginInfo {
  @State name: string = ''
  @State password: string = ''
  private bundleName: string
  private storage: AccountData = AccountData.getInstance()
  private accountModel: AccountModel = new AccountModel()

  build() {
    Column() {
      Row() {
        Text($r('app.string.appname'))
          .margin(10)
          .fontSize(18)
          .width('20%')
          .textAlign(TextAlign.End)
        Text(this.bundleName)
          .margin(10)
          .width('55%')
          .fontSize(20)
          .textAlign(TextAlign.Center)
      }
      .margin({ top: '10%' })
      .padding({ left: 5 })

      Row() {
        Text($r('app.string.username'))
          .margin(10)
          .fontSize(18)
          .width('20%')
          .textAlign(TextAlign.End)

        TextInput({ placeholder: 'xxxxxxx' })
          .margin(10)
          .width('55%')
          .fontSize(20)
          .maxLength(20)
          .fontWeight(FontWeight.Bold)
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .onChange((value: string) => {
            this.name = value
          })
      }
      .padding({ left: 5 })

      Row() {
        Text($r('app.string.password'))
          .margin(10)
          .fontSize(18)
          .width('20%')
          .textAlign(TextAlign.End)

        TextInput({ placeholder: 'xxxxxxx' })
          .margin(10)
          .width('55%')
          .fontSize(20)
          .maxLength(20)
          .type(InputType.Password)
          .fontWeight(FontWeight.Bold)
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .onChange((value: string) => {
            this.password = value
          })
      }
      .padding({ left: 5 })

      Button($r('app.string.register'))
        .margin(10)
        .width('60%')
        .fontSize(20)
        .fontColor(Color.White)
        .type(ButtonType.Capsule)
        .onClick(() => {
          router.replace({
            uri: 'pages/Register',
            params: {
              bundleName: this.bundleName
            }
          })
        })

      Button($r('app.string.login'))
        .margin(10)
        .width('60%')
        .fontSize(20)
        .fontColor(Color.White)
        .type(ButtonType.Capsule)
        .onClick(async () => {
          let result = await this.storage.getStorageValue(this.name, this.bundleName)
          Logger.info(TAG, `This result is ${result}`)
          let effect = await this.storage.getStorageValue(this.bundleName, this.bundleName)
          Logger.info(TAG, `getStorageValue effect is ${effect}`)
          if (this.name === '') {
            AlertDialog.show(
              {
                message: $r('app.string.blank'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          } else if (this.password === '') {
            AlertDialog.show(
              {
                message: $r('app.string.password_blank'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          } else if (result === this.password && effect === 'true') {
            router.replace({
              uri: 'pages/Account',
              params: {
                username: this.name,
                bundleName: this.bundleName
              }
            })
          } else {
            AlertDialog.show(
              {
                message: $r('app.string.password_message'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          }
        })
    }
  }
}