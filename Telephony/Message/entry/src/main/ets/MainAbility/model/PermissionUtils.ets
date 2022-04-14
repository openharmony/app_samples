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
import featureAbility from '@ohos.ability.featureAbility'

const PERMISSION_NAME: string = 'ohos.permission.SEND_MESSAGES'
const TAG: string = '[Permission]'
const requestCode: number = 3

export async function grantPermission() {
  Logger.info(`${TAG}, grantPermission`)
  const context = featureAbility.getContext()
  context.requestPermissionsFromUser([PERMISSION_NAME], requestCode, function (result) {
    Logger.info(`${TAG}, grantPermission requestPermissionsFromUser result = ${JSON.stringify(result)}`)
  })
}