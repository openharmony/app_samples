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
import HiLogUtil from '../model/HiLogUtil'
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
          router.push({
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
          let result = await this.storage.getStorageValue(this.name)
          let effect = await this.storage.getStorageValue(this.bundleName)
          HiLogUtil.log(TAG, `getStorageValue result is ${result}`)
          HiLogUtil.log(TAG, `getStorageValue effect is ${effect}`)
          if (result === this.password && effect === 'true') {
            router.push({
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
                    HiLogUtil.log(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  HiLogUtil.log(TAG, `AlertDialog close`)
                }
              })
          }
        })
    }
  }
}