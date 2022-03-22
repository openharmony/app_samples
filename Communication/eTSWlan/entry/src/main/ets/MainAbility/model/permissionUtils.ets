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

import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import bundle from '@ohos.bundle'
import featureAbility from '@ohos.ability.featureAbility'
import HiLog from '../model/HiLog'

const PERMISSION_NAME: string = 'ohos.permission.LOCATION'
const TAG: string = 'Permission'
let requestCode = 3

export default async function grantPermission() {
  HiLog.log(TAG, 'grantPermission')
  let context = featureAbility.getContext()
  let bundleFlag = 0
  let tokenId = undefined
  let userId = 100
  let appInfo = await bundle.getApplicationInfo('ohos.samples.etswlan', bundleFlag, userId)
  tokenId = appInfo.accessTokenId
  HiLog.log(TAG, `grantPermission,tokenId=${tokenId}`)
  let atManager = abilityAccessCtrl.createAtManager()
  let result = await atManager.verifyAccessToken(tokenId, PERMISSION_NAME)
  HiLog.log(TAG, `grantPermission,verifyPermission,result: ${result}`)
  if (result == abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
    context.requestPermissionsFromUser([PERMISSION_NAME], requestCode, function (result) {
      HiLog.log(TAG, `grantPermission,requestPermissionsFromUser,result.requestCode: ${result}`)
    })
  }
}