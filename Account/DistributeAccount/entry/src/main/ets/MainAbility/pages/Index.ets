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

import prompt from '@ohos.prompt'
import router from '@system.router';
import HiLog from '../model/HiLogUtil'
import { User } from '../model/User'
import { SelectUser } from '../common/SelectUser'
import account_distributedAccount from '@ohos.account.distributedAccount'

const TAG: string = '[Account.Index]'

@Entry
@Component
struct Index {
  @State user: User = new User('', '')
  @State active: boolean = false

  async onLoginClick() {
    HiLog.info(TAG, `this.user = ${JSON.stringify(this.user)}`)
    HiLog.info(TAG, `this.user.name = ${this.user.userName}`)
    HiLog.info(TAG, `this.user.pwd = ${this.user.password}`)
    prompt.showToast({ message: 'userName' + this.user.userName + ',password:' + this.user.password, duration: 2000 })
    const accountAbility = account_distributedAccount.getDistributedAccountAbility()
    let accountInfo = { id: this.user.password, name: this.user.userName, event: 'Ohos.account.event.LOGIN' }
    accountAbility.updateOsAccountDistributedInfo(accountInfo, (err) => {
      if (err) {
        HiLog.info(TAG, `login failed！`)
        HiLog.info(TAG, `err = ${JSON.stringify(err)}`)
        prompt.showToast({ message: `${accountInfo.name} 登录失败 err = ${JSON.stringify(err)}`, duration: 2000 })
      } else {
        HiLog.info(TAG, `login success`)
        HiLog.info(TAG, `login: data_id = ${accountInfo.id} \n data_name = ${accountInfo.name}, err: ${JSON.stringify(err)}`)
        prompt.showToast({ message: `${accountInfo.name} 登录成功`, duration: 2000 })
        HiLog.info(TAG, `aboutToAppear1111 this.user.name = ${JSON.stringify(this.user)}`)
        setTimeout(() => {
          router.push({
            uri: 'pages/userInterface',
            params: {
              userName: this.user.userName, password: this.user.password
            }
          })
        }, 2000)
      }
    })
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Text($r('app.string.distribute_account_manager'))
        .width('100%')
        .fontSize(25)
        .padding(10)
        .backgroundColor('#0D9FFB')
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
      SelectUser({ user: $user })
      Button() {
        Text($r("app.string.login"))
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
      }
      .width('80%')
      .height(50)
      .borderRadius(30)
      .margin({ top: 40 })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        this.onLoginClick()
      })
    }
    .width('100%')
    .height('100%')
  }
}