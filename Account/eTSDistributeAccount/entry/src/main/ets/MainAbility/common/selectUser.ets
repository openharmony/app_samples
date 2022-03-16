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

import { User } from '../model/user.ets'

@Component
export struct SelectUser {
  @Link user: User

  build() {
    Column() {
      Row() {
        Text($r('app.string.user_name'))
          .width('25%')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
        TextInput({ placeholder: '请输入用户名' })
          .width('75%')
          .height(50)
          .fontSize(20)
          .type(InputType.Normal)
          .fontWeight(FontWeight.Regular)
          .border({ width: 2, radius: 5, color: Color.Black })
          .onChange((value: string) => {
            this.user.userName = value
          })
      }
      .width('90%')
      .height(50)
      .margin({ top: 100 })

      Row() {
        Text($r('app.string.password'))
          .width('25%')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
        TextInput({ placeholder: '请输入密码' })
          .width('75%')
          .height(50)
          .fontSize(20)
          .fontWeight(FontWeight.Regular)
          .type(InputType.Password)
          .border({ width: 2, radius: 5, color: Color.Black })
          .onChange((value: string) => {
            this.user.password = value
          })
      }
      .width('90%')
      .height(50)
      .margin({ top: 20 })
    }
  }
}