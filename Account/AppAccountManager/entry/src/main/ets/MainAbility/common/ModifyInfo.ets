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

const TAG = '[ModifyInfo]'

@Component
export struct ModifyInfo {
  @State passWord: string = ''
  @State emailInfo: string = ''
  @State signature: string = ''
  @State confirmPassword: string = ''
  private username: string
  private bundleName: string
  private storage: AccountData = AccountData.getInstance()
  private accountModel: AccountModel = new AccountModel()
  @State dataSet: Array<{
    text: Resource,
    inputType: InputType,
    length: number,
    event: number
    promptText: Resource
  }> = [
    {
      text: $r('app.string.email'),
      inputType: InputType.Email,
      length: 18,
      event: 0,
      promptText: $r('app.string.prompt_email')
    },
    {
      text: $r('app.string.signature'),
      inputType: InputType.Normal,
      length: 18,
      event: 1,
      promptText: $r('app.string.prompt_signature')
    },
    {
      text: $r('app.string.unpassword'),
      inputType: InputType.Password,
      length: 18,
      event: 2,
      promptText: $r('app.string.prompt_password')
    },
    {
      text: $r('app.string.unconfirm_password'),
      inputType: InputType.Password,
      length: 18,
      event: 3,
      promptText: $r('app.string.prompt_confirm_password')
    }
  ]

  build() {
    Column() {
      Row() {
        Text($r('app.string.appname'))
          .margin(10)
          .fontSize(18)
          .width('25%')
          .textAlign(TextAlign.End)
        Text(this.bundleName)
          .margin(20)
          .width('55%')
          .fontSize(20)
          .textAlign(TextAlign.Start)
      }
      .margin(5)

      Row() {
        Text($r('app.string.unusername'))
          .margin(10)
          .fontSize(18)
          .width('25%')
          .textAlign(TextAlign.End)
        Text(this.username)
          .margin(10)
          .width('55%')
          .fontSize(20)
          .textAlign(TextAlign.Start)
      }
      .margin(5)

      ForEach(this.dataSet, item => {
        Row() {
          Text(item.text)
            .margin(10)
            .fontSize(18)
            .width('25%')
            .textAlign(TextAlign.End)
            .backgroundColor('#ffffff')
          Column() {
            Text(item.promptText)
              .fontSize(14)
              .width('80%')
              .fontColor('#ffb0b0b0')
              .textAlign(TextAlign.Center)

            TextInput({ placeholder: 'xxxxx' })
              .margin(10)
              .width('55%')
              .fontSize(20)
              .maxLength(20)
              .type(item.inputType)
              .maxLength(item.length)
              .fontWeight(FontWeight.Bold)
              .placeholderFont({ size: 16, weight: FontWeight.Normal })
              .onChange((value: string) => {
                switch (item.event) {
                  case 0:
                    this.emailInfo = value
                    Logger.info(TAG, `setAccountCredential enter ${this.emailInfo}`)
                    break
                  case 1:
                    this.signature = value
                    Logger.info(TAG, `setAccountExtraInfo enter ${this.signature}`)
                    break
                  case 2:
                    this.passWord = value
                    break
                  case 3:
                    this.confirmPassword = value
                    break
                  default:
                    break
                }
              })
          }
        }
        .margin(5)
      }, item => JSON.stringify(item))

      Button($r('app.string.setting'))
        .margin(10)
        .width('60%')
        .fontSize(20)
        .fontColor(Color.White)
        .type(ButtonType.Capsule)
        .onClick(async () => {
          let res = /^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$/
          let userPassWord = await this.storage.getStorageValue(this.username, this.bundleName)
          Logger.info(TAG, `This userPassWord is ${userPassWord}`)
          Logger.info(TAG, `This passWord is ${this.passWord}`)
          await this.accountModel.setAccountCredential(`${this.username}_${this.bundleName}`, `email_${this.bundleName}`, this.emailInfo)
          await this.accountModel.setAccountCredential(`${this.username}_${this.bundleName}`, `signature_${this.bundleName}`, this.signature)
          if (this.emailInfo !== '' && !res.test(this.emailInfo)) {
            AlertDialog.show(
              {
                message: $r('app.string.emailinfo'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    this.emailInfo = ''
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          } else if (this.passWord !== '' && this.passWord.length < 6) {
            AlertDialog.show(
              {
                message: $r('app.string.min_password'),
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
          } else if (this.passWord !== '' && this.passWord === userPassWord) {
            AlertDialog.show(
              {
                message: $r('app.string.userpassword'),
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
          } else if (this.confirmPassword !== this.passWord) {
            AlertDialog.show(
              {
                message: $r('app.string.password_error'),
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
          } else if (this.passWord !== '' && this.confirmPassword !== '') {
            this.storage.putStorageValue(this.username, this.passWord, this.bundleName)
            AlertDialog.show(
              {
                message: $r('app.string.modify_info'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    router.replace({
                      uri: 'pages/Account',
                      params: {
                        bundleName: this.bundleName,
                        username: this.username
                      }
                    })
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          }
          else {
            AlertDialog.show(
              {
                message: $r('app.string.modify_info'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    router.replace({
                      uri: 'pages/Account',
                      params: {
                        bundleName: this.bundleName,
                        username: this.username
                      }
                    })
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