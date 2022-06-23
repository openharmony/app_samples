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

import Logger from '../model/Logger'
import { Geolocation } from '../common/Geolocation'
import featureAbility from '@ohos.ability.featureAbility'

const TAG: string = '[Index]'

@Entry
@Component
struct Index {
  aboutToAppear() {
    let permissionState: number = 666 //  权限申请返回码
    let permission: string[] = [
      'ohos.permission.LOCATION', 'ohos.permission.VIBRATE', 'ohos.permission.LOCATION_IN_BACKGROUND'
    ]
    let context = featureAbility.getContext()
    context.requestPermissionsFromUser(permission, permissionState, function (result) {
      Logger.info(TAG, `grantPermission,requestPermissionsFromUser,result.requestCode = ${JSON.stringify(result)}`)
    })
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.entry_MainAbility'))
          .fontSize(20)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
      }
      .height('6%')
      .width('100%')
      .padding({ left: 15 })
      .backgroundColor('#0D9FFB')
      .constraintSize({ minHeight: 50 })

      Geolocation()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F1F1')
  }
}