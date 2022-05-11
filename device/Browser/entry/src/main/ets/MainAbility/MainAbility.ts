import Ability from '@ohos.application.Ability'
import Logger from '../model/Logger'

const TAG = '[MainAbility]'

export default class MainAbility extends Ability {
    onCreate(want, launchParam) {
        Logger.info(TAG, `MainAbility onCreate`)
        globalThis.abilityWant = want;
    }

    onDestroy() {
        Logger.info(TAG, `MainAbility onDestroy`)
    }

    onWindowStageCreate(windowStage) {
        // Main window is created, set main page for this ability
        Logger.info(TAG, `MainAbility onWindowStageCreate`)

        windowStage.setUIContent(this.context, "pages/Index", null)
    }

    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info(TAG, `MainAbility onWindowStageDestroy`)
    }

    onForeground() {
        // Ability has brought to foreground
        Logger.info(TAG, `MainAbility onForeground`)
    }

    onBackground() {
        // Ability has back to background
        Logger.info(TAG, `MainAbility onBackground`)
    }
};
