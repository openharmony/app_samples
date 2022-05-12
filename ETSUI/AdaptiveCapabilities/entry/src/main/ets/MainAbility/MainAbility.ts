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

export default class MainAbility extends Ability {
    onCreate(want, launchParam) {
        Logger.info('[MainAbility]', 'MainAbility onCreate')
        globalThis.abilityWant = want;
    }

    onDestroy() {
        Logger.info('[MainAbility]', 'MainAbility onDestroy')
    }

    onWindowStageCreate(windowStage) {
        // Main window is created, set main page for this ability
        Logger.info('[MainAbility]', 'onWindowStageCreate')

        windowStage.setUIContent(this.context, "pages/index", null)
    }

    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info('[MainAbility]', 'onWindowStageDestroy')
    }

    onForeground() {
        // Ability has brought to foreground
        Logger.info('[MainAbility]', 'onForeground')
    }

    onBackground() {
        // Ability has back to background
        Logger.info('[MainAbility]', 'onBackground')
    }
};
