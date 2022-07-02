import AbilityStage from "@ohos.application.AbilityStage"

export default class MyAbilityStage extends AbilityStage {
  onCreate() {
    AppStorage.SetOrCreate<number>('windowWidth', -1)
    AppStorage.SetOrCreate<number>('windowHeight', -1)
    console.log("[Demo] MyAbilityStage onCreate")
  }
}