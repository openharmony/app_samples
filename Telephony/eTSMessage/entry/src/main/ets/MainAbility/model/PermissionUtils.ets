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
import HiLog from '../model/HiLogUtil'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import featureAbility from '@ohos.ability.featureAbility'

const PERMISSION_NAME: string = 'ohos.permission.SEND_MESSAGES'
const TAG: string = '[Permission]'
const requestCode: number = 3

export async function grantPermission() {
  HiLog.info(TAG, `grantPermission`)
  const context = featureAbility.getContext()
  const bundleFlag = 0
  const userId = 100
  const appInfo = await bundle.getApplicationInfo('ohos.samples.etsmessage', bundleFlag, userId)
  const tokenId = appInfo.accessTokenId
  HiLog.info(TAG, `grantPermission, tokenId = ${tokenId}`)
  const atManager = abilityAccessCtrl.createAtManager()
  const result = await atManager.verifyAccessToken(tokenId, PERMISSION_NAME)
  HiLog.info(TAG, `grantPermission, verifyPermission, result = ${result}`)
  if (result === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
    context.requestPermissionsFromUser([PERMISSION_NAME], requestCode, function (result) {
      HiLog.info(TAG, `grantPermission, requestPermissionsFromUser, result.requestCode = ${result.requestCode}`)
    })
  }
}