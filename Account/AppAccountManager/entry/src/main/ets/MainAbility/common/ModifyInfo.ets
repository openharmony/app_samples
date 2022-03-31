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

const TAG = '[ModifyInfo]'

@Component
export struct ModifyInfo {
  @State emailInfo: string = ''
  @State signature: string = ''
  @State confirmPassword: string = ''
  private username: string
  private passWord: string
  private bundleName: string
  private storage: AccountData = AccountData.getInstance()
  private accountModel: AccountModel = new AccountModel()
  @State dataSet: Array<{
    text: Resource,
    inputType: InputType,
    event: number
  }> = [
    {
      text: $r('app.string.email'),
      inputType: InputType.Email,
      event: 0
    },
    {
      text: $r('app.string.signature'),
      inputType: InputType.Normal,
      event: 1
    },
    {
      text: $r('app.string.password'),
      inputType: InputType.Password,
      event: 2
    },
    {
      text: $r('app.string.confirm_password'),
      inputType: InputType.Password,
      event: 3
    }
  ]

  aboutToAppear() {
    this.confirmPassword = this.passWord
  }

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
        Text($r('app.string.username'))
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
          TextInput({ placeholder: 'xxxxx' })
            .margin(10)
            .width('55%')
            .fontSize(20)
            .maxLength(20)
            .type(item.inputType)
            .fontWeight(FontWeight.Bold)
            .placeholderFont({ size: 16, weight: FontWeight.Normal })
            .onChange((value: string) => {
              switch (item.event) {
                case 0:
                  this.emailInfo = value
                  HiLogUtil.log(TAG, `setAccountCredential enter`)
                  this.accountModel.setAccountCredential(this.username, 'email', this.emailInfo)
                  break
                case 1:
                  this.signature = value
                  HiLogUtil.log(TAG, `setAccountExtraInfo enter`)
                  this.accountModel.setAccountExtraInfo(this.username, this.signature)
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
        .margin(5)
      }, item => JSON.stringify(item))

      Button($r('app.string.setting'))
        .margin(10)
        .width('60%')
        .fontSize(20)
        .fontColor(Color.White)
        .type(ButtonType.Capsule)
        .onClick(() => {
          if (this.confirmPassword != this.passWord) {
            AlertDialog.show(
              {
                message: $r('app.string.password_error'),
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
          } else {
            this.storage.putStorageValue(this.username, this.passWord)
            router.push({
              uri: 'pages/Account',
              params: {
                bundleName: this.bundleName,
                username: this.username
              }
            })
          }
        })
    }
  }
}