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
    context.requestPermissionsFromUser(PERMISSIONS, requestCode, function (result) {
        Logger.log(TAG, `grantPermission,requestPermissionsFromUser,result.requestCode=${result}`)
    })
}