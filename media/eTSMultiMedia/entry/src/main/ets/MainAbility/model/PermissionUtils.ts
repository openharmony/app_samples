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
import Logger from '../model/Logger'

const PERMISSIONS: Array<string> = [
    'ohos.permission.CAMERA',
    'ohos.permission.MICROPHONE',
    'ohos.permission.READ_MEDIA',
    'ohos.permission.WRITE_MEDIA',
    'ohos.permission.MEDIA_LOCATION']
const TAG: string = 'Permission'
const requestCode = 3

export default async function grantPermission() {
    Logger.log(TAG, 'grantPermission')
    let context = featureAbility.getContext()
    let bundleFlag = 0
    let tokenId = undefined
    let userId = 100
    let appInfo = await bundle.getApplicationInfo('ohos.samples.etsmultimedia', bundleFlag, userId)
    tokenId = appInfo.accessTokenId
    Logger.log(TAG, `grantPermission,tokenId=${tokenId}`)
    let atManager = abilityAccessCtrl.createAtManager()
    let requestPermissions: Array<string> = []
    for (let i = 0;i < PERMISSIONS.length; i++) {
        let result = await atManager.verifyAccessToken(tokenId, PERMISSIONS[i])
        Logger.log(TAG, `grantPermission,verifyPermission,result=${result}`)
        if (result === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
            requestPermissions.push(PERMISSIONS[i])
        }
    }
    Logger.log(TAG, `grantPermission,requestPermissions.length=${requestPermissions.length}`)
    if (requestPermissions.length > 0) {
        context.requestPermissionsFromUser(requestPermissions, requestCode, function (result) {
            Logger.log(TAG, `grantPermission,requestPermissionsFromUser,result.requestCode=${result.requestCode}`)
        })
    }
}