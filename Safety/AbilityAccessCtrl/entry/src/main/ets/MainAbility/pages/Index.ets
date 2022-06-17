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
import prompt from '@ohos.prompt';
import bundle from '@ohos.bundle'
import Logger from '../model/Logger'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { requestModel } from '@ohos/requestModel'

const TAG: string = '[Index]'

@Entry
@Component
struct Index {
  private request?: requestModel
  private atManager: abilityAccessCtrl.AtManager = undefined

  aboutToAppear() {
    this.request = new requestModel(['ohos.permission.MICROPHONE'])
    this.request.requestPermission('ohos.samples.abilityaccessctrl')
  }

  build() {
    Row() {
      Column() {

        Button($r('app.string.button'))
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let bundleFlag = 0 // 返回的应用信息对象中包含信息的标记,默认值：0
            bundle.getApplicationInfo('ohos.samples.abilityaccessctrl', bundleFlag).then((data) => {
              let appInfo = data
              let tokenID = appInfo.accessTokenId
              Logger.info(TAG, `test AccessTokenTest accessTokenId = ${appInfo.accessTokenId}, name = ${appInfo.name}`)
              this.atManager = abilityAccessCtrl.createAtManager()
              this.atManager.verifyAccessToken(tokenID, "ohos.permission.MICROPHONE").then((data) => {
                Logger.info(TAG, `test grantUserGrantedPermission = ${JSON.stringify(data)}`)
                if (data === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
                  prompt.showToast({ message: '权限已被授予' })
                } else {
                  prompt.showToast({ message: '权限授予失败' })
                }
              })
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}