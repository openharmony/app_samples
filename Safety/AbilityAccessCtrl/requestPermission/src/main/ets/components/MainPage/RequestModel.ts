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


import bundle from '@ohos.bundle'
import Logger from '../model/Logger'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import featureAbility from '@ohos.ability.featureAbility'

const TAG: string = '[requestPermission]'
const BUNDLE_NAME: string = 'ohos.samples.abilityaccessctrl'

export class requestModel {
  private permissions: Array<string> = []

  constructor(permissions: Array<string>) {
    this.permissions = permissions
  }

  async requestPermission(bundleName: string) {
    let bundleFlag = 0
    let appInfo = await bundle.getApplicationInfo(bundleName, bundleFlag)
    let tokenID = appInfo.accessTokenId
    let atManager = abilityAccessCtrl.createAtManager()
    Logger.info(TAG, `atManager = ${JSON.stringify(atManager)}`)
    for (let i = 0;i < this.permissions.length; i++) {
      let result = await atManager.verifyAccessToken(tokenID, this.permissions[i])
      Logger.info(TAG, `result = ${JSON.stringify(result)}`)
      if (result === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        Logger.info(TAG, `result = ${JSON.stringify(result)}`)
        featureAbility.startAbility({
          want: {
            bundleName: BUNDLE_NAME,
            abilityName: `${BUNDLE_NAME}.VerifyAbility`,
            parameters: {
              bundleName: BUNDLE_NAME,
              permissions: this.permissions[i]
            }
          }
        })
      }
    }
  }
}