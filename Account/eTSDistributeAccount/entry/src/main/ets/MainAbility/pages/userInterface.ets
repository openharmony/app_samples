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
import account_distributedAccount from '@ohos.account.distributedAccount'

const TAG: string = '[Record.UserInterface]'

@Entry
@Component
struct UserInterface {
  @State userName: string = router.getParams().userName
  @State userPwd: string = router.getParams().userPwd
  @State active: boolean = false
  @State btnText: Resource[] = [$r('app.string.exit_login'), $r('app.string.written_off')]

  async onBtnClick(item: Resource) {
    HiLog.info(TAG, `this.user.name = ${this.userName}`)
    HiLog.info(TAG, `this.user.pwd = ${this.userPwd}`)
    const accountAbility = account_distributedAccount.getDistributedAccountAbility()
    let accountInfo
    if (item === this.btnText[0]) {
      accountInfo = { id: this.userPwd, name: this.userName, event: 'Ohos.account.event.LOGOUT' }
      accountAbility.updateOsAccountDistributedInfo(accountInfo, (err) => {
        if (err) {
          HiLog.info(TAG, `exit failed！`)
          prompt.showToast({ message: `${accountInfo.name} 退出失败`, duration: 1500 })
        } else {
          HiLog.info(TAG, `退出登录成功`)
          HiLog.info(TAG, `exitLogin: data_id = ${accountInfo.id} \n data_name = ${accountInfo.name}, err: ${JSON.stringify(err)}`)
          prompt.showToast({ message: `${accountInfo.name} 已退出登录`, duration: 1500 })
          router.back()
        }
      })
    } else {
      accountInfo = { id: this.userPwd, name: this.userName, event: 'Ohos.account.event.LOGOFF' }
      accountAbility.updateOsAccountDistributedInfo(accountInfo, (err) => {
        if (err) {
          HiLog.info(TAG, `writtenOff failed！`)
          prompt.showToast({ message: `${accountInfo.name} 注销失败`, duration: 1500 })
        } else {
          HiLog.info(TAG, `注销成功`)
          HiLog.info(TAG, `writtenOff: data_id = ${accountInfo.id} \n data_name = ${accountInfo.name}, err: ${JSON.stringify(err)}`)
          prompt.showToast({ message: `${accountInfo.name} 已注销`, duration: 1500 })
          router.back()
        }
      })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Row() {
        Text($r('app.string.user_name'))
          .width('35%')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
        Text(this.userName)
          .width('75%')
          .height(50)
          .fontSize(30)
          .fontWeight(FontWeight.Regular)
      }.width('80%')

      ForEach(this.btnText, item => {
        Button() {
          Text(item)
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }
        .width('80%')
        .height(50)
        .margin({ top: 20 })
        .backgroundColor('#0D9FFB')
        .borderRadius(30)
        .onClick(() => {
          this.onBtnClick(item)
        })
      }, item => JSON.stringify(item))
    }
    .width('100%')
    .height('100%')
  }
}