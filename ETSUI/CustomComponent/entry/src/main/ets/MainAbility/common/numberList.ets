/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import Logger from '../model/Logger'

const TAG = '[Component.numberList]'

@Component
export struct NumberList {
  @Link resMenu: string[]
  @Link colMenu: string[]
  @Link broMenu: string[]

  @Builder columnOfBindMenu(menu: string[], text: Resource) {
    Column() {
      Text(menu.length.toString()).fontSize(30).fontWeight(FontWeight.Bold)
      Text(text).fontSize(15)
    }
    .layoutWeight(1)
    .bindMenu([
      {
        value: menu[0],
        action: () => {
          Logger.info(TAG, `handle Menu1 select`)
        }
      },
      {
        value: menu[1],
        action: () => {
          Logger.info(TAG, `handle Menu2 select`)
        }
      },
      {
        value: menu[2],
        action: () => {
          Logger.info(TAG, `handle Menu3 select`)
        }
      }
    ])
  }

  build() {
    Row() {
      this.columnOfBindMenu(this.resMenu, $r('app.string.appointment'))
      this.columnOfBindMenu(this.colMenu, $r('app.string.collection'))
      this.columnOfBindMenu(this.broMenu, $r('app.string.browse'))
    }
    .width('90%')
    .height(50)
  }
}