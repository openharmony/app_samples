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

import Ability from '@ohos.application.Ability'
import Logger from '../model/Logger'
import DeviceManager from '@ohos.distributedHardware.deviceManager'
import AccessControl from "@ohos.abilityAccessCtrl"
import Bundle from '@ohos.bundle'

const TAG: string = '[MainAbility]'
const BUNDLE_NAME = "ohos.samples.CallApplication"
const PERMISSION_REJECT = -1

function getDm() {
    DeviceManager.createDeviceManager(BUNDLE_NAME, (error, dm) => {
        if (error) {
            Logger.error(TAG, `getDm failed with ${error.code}`)
            return;
        }
        Logger.log(TAG, 'getDm success')
        globalThis.dmClass = dm
    });
}

export default class MainAbility extends Ability {
    onCreate(want, launchParam) {
        Logger.log(TAG, 'onCreate')
        globalThis.mainAbilityContext = this.context
        getDm()
    }

    onDestroy() {
        Logger.log(TAG, 'onDestroy')
    }

    requestPermissions = async () => {
        let permissions: Array<string> = [
            "ohos.permission.DISTRIBUTED_DATASYNC"
        ];
        let needGrantPermission = false
        let accessManger = AccessControl.createAtManager()
        Logger.log(TAG, 'app permission get bundle info')
        let bundleInfo = await Bundle.getApplicationInfo(BUNDLE_NAME, 0, 100)
        Logger.log(TAG, `app permission query permission ${bundleInfo.accessTokenId.toString()}`)
        for (const permission of permissions) {
            Logger.log(TAG, `app permission query grant status ${permission}`)
            try {
                let grantStatus = await accessManger.verifyAccessToken(bundleInfo.accessTokenId, permission)
                if (grantStatus === PERMISSION_REJECT) {
                    needGrantPermission = true
                    break;
                }
            } catch (err) {
                Logger.log(TAG, `app permission query grant status error ${permission} ${JSON.stringify(err)}`)
                needGrantPermission = true
                break;
            }
        }
        if (needGrantPermission) {
            Logger.log(TAG, 'app permission needGrantPermission')
            try {
                await this.context.requestPermissionsFromUser(permissions)
            } catch (err) {
                Logger.log(TAG, `app permission ${JSON.stringify(err)}`)
            }
        } else {
            Logger.log(TAG, 'app permission already granted')
        }
    }

    onWindowStageCreate(windowStage) {
        Logger.log(TAG, 'onWindowStageCreate')
        this.requestPermissions()
        windowStage.loadContent("pages/index").then((data) => {
            Logger.info(TAG, `load content succeed with data ${JSON.stringify(data)}`)
        }).catch((error) => {
            Logger.error(TAG, `load content failed with error ${JSON.stringify(error)}`)
        })
    }

    onWindowStageDestroy() {
        Logger.log(TAG, 'onWindowStageDestroy')
    }

    onForeground() {
        Logger.log(TAG, 'onForeground')
    }

    onBackground() {
        Logger.error(TAG, 'onBackground')
    }
};
