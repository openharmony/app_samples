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
import dateTimeUtil from '../Common/DateTimeUtil'

@Component
export struct HistoryShow {
  @State city: string = ''
  private updateTime: string = ''

  aboutToAppear() {
    this.updateTime = dateTimeUtil.getTime()
  }

  build() {
    Column() {
      Row() {
        Button($r('app.string.history'))
          .height(40)
          .fontSize(30)
          .onClick(() => {
            router.push({
              url: 'pages/Detail',
              params: {
                city: this.city
              }
            })
          })
      }
      .height(30)
      .margin({ top: 40 })

      Row() {
        Text($r('app.string.update_time') + `${this.updateTime}`)
          .width('100%')
          .height(35)
          .fontSize(30)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height(35)
      .margin({ top: 20 })

      Row() {
        Text($r('app.string.message_from'))
          .width('100%')
          .height(35)
          .fontSize(30)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height(40)
    }
  }
}