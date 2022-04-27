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

const TAG: string = 'PlayAbility'

export default class PlayAbility extends Ability {
    onCreate(want, launchParam) {
        Logger.info(TAG, 'PlayAbility onCreate')
        globalThis.abilityWant = want
        globalThis.abilityContext = this.context
    }

    onDestroy() {
        Logger.info(TAG, 'PlayAbility onDestroy')
    }

    onWindowStageCreate(windowStage) {
        // Main window is created, set main page for this ability
        Logger.info(TAG, 'PlayAbility onWindowStageCreate')
        windowStage.setUIContent(this.context, "pages/Play", null)
    }

    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info(TAG, 'PlayAbility onWindowStageDestroy')
    }

    onForeground() {
        // Ability has brought to foreground
        Logger.info(TAG, 'PlayAbility onForeground')
    }

    onBackground() {
        // Ability has back to background
        Logger.info(TAG, 'PlayAbility onBackground')
    }
};
