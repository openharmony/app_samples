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
import Extension from '@ohos.application.ServiceExtensionAbility'
import { KeyboardController } from './model/KeyboardController'
import preference from '@ohos.data.preferences';
import { ChineseEngine } from './model/ChineseEngine'

export default class InputDemoService extends Extension {
  private keyboardController: KeyboardController;
  private setting;

  onCreate(want) {
    this.keyboardController = new KeyboardController(this.context);
    this.keyboardController.onCreate();
    if (globalThis.chineseEngine == undefined) {
      globalThis.chineseEngine = new ChineseEngine();
      console.log("[InputDemo] start to load ndk resource");
      globalThis.chineseEngine.openDecodeFd(this.context);
    }
    globalThis.chineseEngine.resetToIdleState(false);
    AppStorage.Set("isHardKeyPressed", false);
    this.setSetting();
  }

  onRequest(want, startId) {
  }

  onConnect(want) {
    return null;
  }

  private async setSetting() {
    console.log("[kikaInput] set setting");
    this.setting = await preference.getPreferences(this.context, "setting");
    AppStorage.Set("isPrediction", await this.setting.get("isPrediction", true));
    AppStorage.Set("isVibrate", await this.setting.get("isVibrate", false));
    AppStorage.Set("isBubble", await this.setting.get("isBubble", false));
    AppStorage.Set("isSound", await this.setting.get("isSound", false));
  }

  private async saveSetting() {
    console.log("[kikaInput save setting");
    if (!this.setting) {
      this.setting = await preference.getPreferences(this.context, "setting");
    }
    this.setting.put("isPrediction", AppStorage.Get("isPrediction"));
  }

  onDestroy() {
    console.log("onDestroy**");
    if (globalThis.chineseEngine == undefined) {
      return;
    }
    globalThis.chineseEngine.onDestroy();
    globalThis.chineseEngine = undefined;
    this.saveSetting();
    this.context.terminateSelf()
  }
}