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
import inputMethod from '@ohos.inputmethod';
import display from '@ohos.display';

export default class MainAbility extends Ability {
  WINDOW_TYPE_INPUT_METHOD_FLOAT = 2105

  onCreate(want, launchParam) {
  }

  onDestroy() {
    console.log("jws MainAbility onDestroy is called")
    this.context.terminateSelf()
  }

  onWindowStageCreate(windowStage) {
    try {
      let setting = inputMethod.getInputMethodSetting()
      setting.displayOptionalInputMethod() // 用户列出系统输入法kika 中文输入法
      windowStage.setUIContent(this.context, "pages/ability/index", null)

    } catch (err) {
      console.log("[InputDemo] start input demo failed" + JSON.stringify(err))
    }
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    console.log("[Demo] MainAbility onWindowStageDestroy")
  }

  onForeground() {
    // Ability has brought to foreground
    console.log("[Demo] MainAbility onForeground")
  }

  onBackground() {
    // Ability has back to background
    console.log("[Demo] MainAbility onBackground")
  }
};
