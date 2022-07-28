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
import FormManagerComponent from '../components/FormManagerComponent'

@Entry
@Component
struct FormPage {
  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width('10%')
          .aspectRatio(2)
          .margin({ left: 15 })
          .onClick(() => {
            router.back()
          })
      }
      .width('100%')
      .height('8%')

      FormManagerComponent()

    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.form_mgr_bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}