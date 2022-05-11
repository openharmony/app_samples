import AbilityStage from "@ohos.application.AbilityStage"
import Logger from '../model/Logger'

export default class MyAbilityStage extends AbilityStage {
    onCreate() {
        Logger.info("[MyAbilityStage] MyAbilityStage onCreate")
    }
}