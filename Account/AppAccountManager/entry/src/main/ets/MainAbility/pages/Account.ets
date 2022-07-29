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

import router from '@ohos.router'
import { AccountInfo } from '../common/AccountInfo'
import { NavigationBar } from '../common/NavigationBar'

@Entry
@Component
struct Account {
  @State email: string = <string> router.getParams()['email']
  @State username: string = <string> router.getParams()['username']
  @State signature: string = <string> router.getParams()['signature']
  @State bundleName: string = <string> router.getParams()['bundleName']

  build() {
    Column() {
      NavigationBar({ title: $r('app.string.account'), flag: false })

      AccountInfo({
        email: this.email,
        username: this.username,
        signature: this.signature,
        bundleName: this.bundleName
      })
    }
    .width('100%')
    .height('100%')
  }
}