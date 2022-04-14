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
import { AccountModel } from '../model/AccountModel'
import { AccountData } from '../model/AccountData'

const TAG = '[AccountInfo]'

@Component
export struct AccountInfo {
  @State email: string = ''
  @State username: string = ''
  @State signature: string = ''
  @State passWord: string = ''
  private bundleName: string
  private storage: AccountData = AccountData.getInstance()
  private accountModel: AccountModel = new AccountModel()
  @State textData: Array<{
    title: Resource,
    value: string
  }> = []

  async aboutToAppear() {
    this.passWord = await this.accountModel.getAssociatedData(`${this.username}_${this.bundleName}`, `key_${this.bundleName}`)
    try {
      this.email = await this.accountModel.getAccountCredential(`${this.username}_${this.bundleName}`, `email_${this.bundleName}`)
      Logger.info(TAG, `getAccountCredential email is ${this.email}`)
    } catch (err) {
      this.email = ''
    }
    try {
      this.signature = await this.accountModel.getAccountCredential(`${this.username}_${this.bundleName}`, `signature_${this.bundleName}`)
      Logger.info(TAG, `getAccountExtraInfo signature is ${this.signature}`)
    } catch (err) {
      this.signature = ''
    }
    this.textData = [
      { title: $r('app.string.appname'), value: this.bundleName },
      { title: $r('app.string.unusername'), value: this.username },
      { title: $r('app.string.email'), value: this.email },
      { title: $r('app.string.signature'), value: this.signature }
    ]
  }

  build() {
    Scroll() {
      Column() {
        ForEach(this.textData, (item) => {
          Row() {
            Text(item.title)
              .margin(10)
              .fontSize(18)
              .width('25%')
              .textAlign(TextAlign.End)
            Text(item.value)
              .margin(10)
              .width('55%')
              .fontSize(20)
              .textAlign(TextAlign.Start)
          }
          .padding({ left: 5 })
        }, item => item.value.toString())

        Button($r('app.string.modify'))
          .margin(10)
          .width('60%')
          .fontSize(20)
          .fontColor(Color.White)
          .type(ButtonType.Capsule)
          .onClick(() => {
            router.replace({
              uri: 'pages/Modify',
              params: {
                username: this.username,
                bundleName: this.bundleName
              }
            })
          })

        Button($r('app.string.application'))
          .margin(10)
          .width('60%')
          .fontSize(20)
          .fontColor(Color.White)
          .type(ButtonType.Capsule)
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.warning'),
                message: $r('app.string.switch_app'),
                primaryButton: {
                  value: $r('app.string.confirm'),
                  action: () => {
                    router.replace({
                      uri: 'pages/Index'
                    })
                  }
                },
                secondaryButton: {
                  value: $r('app.string.cancel'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          })

        Button($r('app.string.delete'))
          .margin(10)
          .width('60%')
          .fontSize(20)
          .fontColor(Color.White)
          .type(ButtonType.Capsule)
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.warning'),
                message: $r('app.string.delete_account'),
                primaryButton: {
                  value: $r('app.string.confirm'),
                  action: () => {
                    this.storage.deleteStorageValue(this.username, this.bundleName)
                    router.replace({
                      uri: 'pages/Login',
                      params: {
                        bundleName: this.bundleName
                      }
                    })
                  }
                },
                secondaryButton: {
                  value: $r('app.string.cancel'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          })
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
    }
  }
}