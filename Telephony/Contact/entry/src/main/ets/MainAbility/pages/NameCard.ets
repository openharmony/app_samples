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

import contact from '@ohos.contact'
import router from '@ohos.router'
import { ContactInfo } from '../component/ContactInfo'

@Entry
@Component
struct NameCard {
  private contact = <contact.Contact> router.getParams()['data']

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .objectFit(ImageFit.Contain)
          .width(32)
          .height(32)
          .margin({ left: 32 })
      }
      .height('6%')
      .width('100%')
      .constraintSize({ minHeight: 50 })
      .onClick(() => {
        router.back({
          url: 'pages/Index'
        })
      })

      ContactInfo({ contact: this.contact })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}