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
import Logger from '../../../../../updatedialog/src/main/ets/components/util/Logger'

const TAG: string = 'MainAbility'

export default class MainAbility extends Ability {
  async onCreate(want, launchParam) {
    Logger.info(TAG, `[Demo] MainAbility onCreate`)
    await this.context.requestPermissionsFromUser(['ohos.permission.INTERNET'])
  }

  onDestroy() {
    Logger.info(TAG, `[Demo] MainAbility onDestroy`)
  }

  onWindowStageCreate(windowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, `[Demo] MainAbility onWindowStageCreate`)

    windowStage.loadContent('pages/index', (err, data) => {
      if (err.code) {
        Logger.info(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return
      }
      Logger.info(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data)}`)
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, `[Demo] MainAbility onWindowStageDestroy`)
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, `[Demo] MainAbility onForeground`)
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, `[Demo] MainAbility onBackground`)
  }
}
