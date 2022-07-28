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

import { Hypium } from '@ohos/hypium'
import Ability from '@ohos.application.Ability'
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import Logger from '../../../../../base/src/main/ets/default/utils/Logger'
import testsuite from '../test/List.test'

const TAG: string = 'TestAbility'

export default class TestAbility extends Ability {
  onCreate(want, launchParam) {
    Logger.info(TAG, 'TestAbility onCreate')
  }

  onDestroy() {
    Logger.info(TAG, 'TestAbility onDestroy')
  }

  onWindowStageCreate(windowStage) {
    Logger.info(TAG, 'TestAbility onWindowStageCreate')
    windowStage.loadContent("TestAbility/pages/index", (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return;
      }
      Logger.error(TAG, `Succeeded in loading the content. Data:: ${JSON.stringify(data)}`)
    })

    globalThis.abilityContext = this.context
    let abilityDelegator: any
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
    let abilityDelegatorArguments: any
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments()
    Logger.info(TAG, 'start run testcase!!!')
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite)
  }

  onWindowStageDestroy() {
    Logger.info(TAG, 'TestAbility onWindowStageDestroy')
  }

  onForeground() {
    Logger.info(TAG, 'TestAbility onForeground')
  }

  onBackground() {
    Logger.info(TAG, 'TestAbility onBackground')
  }
}