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
import { GetHardKeyValue } from './HardKeyUtils'
import inputMethodEngine from '@ohos.inputMethodEngine'
import display from '@ohos.display'
import prompt from '@system.prompt'
import windowManager from '@ohos.window'
import settings from '@ohos.settings';
import featureAbility from '@ohos.ability.featureAbility';
import { ChineseEngine } from './ChineseEngine'
import inputConsumer from '@ohos.multimodalInput.inputConsumer';

globalThis.inputEngine = inputMethodEngine.getInputMethodEngine();

export class KeyboardController {
  private TAG: string = 'inputDemo: KeyboardController ';
  isDebug = false;
  mContext
  WINDOW_TYPE_INPUT_METHOD_FLOAT = 2105
  windowName = 'inputApp';
  intervalID: number = 0;
  isSpecialKeyPress = false;
  isShiftKeyPress = false;
  isKeyboardShow = false;
  isPromptShowOnly = false;
  private keyboardDelegate;
  private helper: any = null;
  private readonly uri = 'dataability:///com.ohos.settingsdata.DataAbility';
  private windowHeight: number = 0;
  private windowWidth: number = 0;
  private getValueRes: string = "1";
  private nonBarPosition: number = 0;
  private barPosition: number = 0;
  private isWindowShowing: boolean = false;
  private isWindowClosing: boolean = false;

  constructor(context) {
    this.addLog('constructor');
    this.mContext = context;
    this.helper = featureAbility.acquireDataAbilityHelper(this.uri);
  }

  public onCreate(): void
  {
    this.addLog('onCreate');
    this.initWindow();
    this.registerListener();
  }

  public onDestroy(): void{
    this.addLog('onDestroy');
    this.unRegisterListener();
    windowManager.find(this.windowName).then(win => {
      win.destroy()
    })
    this.mContext.terminateSelf();
  }

  public getValue(settingDataKey: string) {

  }

  ChnEngShift(data) {
    if (data) {
      this.addLog('ChnEngShift called');
      let isChinese = AppStorage.Get<boolean>('isChinese');
      AppStorage.Set("isChinese",!isChinese);

      if (isChinese) {
        setTimeout(() => {
          this.hideWindow();
        }, 100);
      } else {
        this.showPromptOnly();
      }
    } else {
      this.addLog('ChnEngShift called with null data');
    }
  }

  private initWindow(): void{
    this.addLog('initWindow');
    display.getDefaultDisplay().then(dis => {
      this.addLog('initWindow-oncall display');
      var dWidth = dis.width;
      var dHeight = dis.height;
      var navigationbar_height = dHeight * 0.05;
      var keyHeightRate = 0.47;
      if (dWidth < 1800) {
        keyHeightRate = 0.38;
        globalThis.isPhone = true;
      } else {
        globalThis.isPhone = false;
      }
      var keyHeight = dHeight * keyHeightRate;
      this.addLog("initWindow-dWidth =" + dWidth + ";dHeight =" + dHeight + ";keyboard height = " + keyHeight + ";navibar height = " + navigationbar_height);
      this.windowWidth = dWidth;
      this.windowHeight = keyHeight;
      this.addLog(typeof (this.mContext));
      this.addLog('initWindow-window = ' + typeof (windowManager));
      this.barPosition = dHeight - keyHeight - navigationbar_height;
      this.nonBarPosition = dHeight - keyHeight

      windowManager.create(this.mContext, this.windowName, this.WINDOW_TYPE_INPUT_METHOD_FLOAT).then((win) => {
        win.resetSize(dWidth, keyHeight).then(() => {
          win.moveTo(0, this.barPosition).then(() => {
            win.loadContent('pages/service/index').then(() => {
              this.addLog('loadContent finished');
            });
          });
        });
      });
    });
  }

  private registerListener(): void{
    this.addLog('registerListener')
    this.registerInputListener();
    globalThis.inputEngine.on('keyboardShow', () => {
      if (this.isWindowShowing) {
        console.log('[inputDemo] window is showing')
        return;
      }
      this.isWindowShowing = true;
      console.log("[inputDemo] trigger keyboardShow");
      globalThis.chineseEngine.resetToIdleState(false);
      globalThis.hideState = true;
      globalThis.editorAttribute = globalThis.textInputClient.getEditorAttribute()
      if (globalThis.editorAttribute.inputPattern == inputMethodEngine.PATTERN_PASSWORD) {
        AppStorage.Set("isChinese", false);
      }
      if (globalThis.editorAttribute.inputPattern == inputMethodEngine.PATTERN_NUMBER ||
      globalThis.editorAttribute.inputPattern == inputMethodEngine.PATTERN_PHONE) {
        AppStorage.Set("menuType", 1);
      }
      this.showWindow();
    });
    globalThis.inputEngine.on('keyboardHide', () => {
      if (this.isWindowClosing) {
        console.log("[inputDemo] keyboard is hidden, do not trigger again");
        return;
      }
      this.isWindowClosing = true;
      let timer = setInterval(() => {
        if (globalThis.hideState) {
          console.log("[inputDemo] trigger keyboardHide");
          globalThis.chineseEngine.resetToIdleState(false);
          this.hideWindow();
          clearInterval(timer);
        }
      }, 100)
    });
    this.registerKeyCallback();
    this.ChnEngShift = this.ChnEngShift.bind(this);
    inputConsumer.on('key', {
      preKeys: [2072],
      finalKey: 2050,
      isFinalKeyDown: false,
      finalKeyDownDuration: 0
    }, this.ChnEngShift);
  }

  private registerKeyCallback(): void
  {
    this.keyboardDelegate = inputMethodEngine.createKeyboardDelegate();
    this.keyboardDelegate.on('keyDown', (keyEvent) => {
      var keyCode = keyEvent.keyCode;
      this.addLog("[inputDemo] OnKeyDown: keycode is " + keyCode);
      if (this.isKeyboardShow) {
        AppStorage.Set("isHardKeyPressed", true);
        let isChinese = AppStorage.Get<boolean>("isChinese");
        if (!isChinese) {
          setTimeout(() => {
            this.hideWindow();
          }, 100);
        } else {
          this.showPromptOnly();
        }
      }
      if (keyCode == "2045" || keyCode == "2046") {
        return false;
      }
      if (keyCode == "2047") {
        this.isShiftKeyPress = true
      }
      let isChinese = AppStorage.Get<boolean>("isChinese");
      var keyValue = GetHardKeyValue(keyCode, this.isShiftKeyPress, isChinese);

      if (this.isSpecialKeyPress) {
        return false;
      }
      if (keyValue == "") {
        this.addLog('OnKeyDown: unknown keyCode');
        this.isSpecialKeyPress = true;
        return false;
      }
      if (keyValue == "KEYCODE_DEL" || keyValue == 'KEYCODE_FORWARD_DEL') {
        globalThis.chineseEngine.processKey(keyValue, true);
      }
      return true;
    });

    this.keyboardDelegate.on('keyUp', (keyEvent) => {
      var keyCode = keyEvent.keyCode;
      this.addLog("[inputDemo] OnKeyUp: keyCode is " + keyCode);
      // For KEYCODE_DEL/KEYCODE_FORWARD_DEL, processed in OnKeyDown, so just intercept it
      if (keyCode == "2055" || keyCode == "2071") {
        return true;
      }
      if (keyCode == "2047") {
        this.isShiftKeyPress = false
      }
      let isChinese = AppStorage.Get<boolean>("isChinese");
      var keyValue = GetHardKeyValue(keyCode, this.isShiftKeyPress, isChinese);

      if (this.isSpecialKeyPress) {
        if (keyValue == "") {
          this.isSpecialKeyPress = false;
        }
        return false;
      }
      globalThis.chineseEngine.processKey(keyValue, true);
      return true;
    });

    this.keyboardDelegate.on('textChange', (val: string) => {
      let preStr = val.substr(val.length - 4, 4)
      globalThis.chineseEngine.doPrediction(preStr)
    })
  }

  private registerInputListener() {
    globalThis.inputEngine.on('inputStart', (kbController, textInputClient) => {
      globalThis.textInputClient = textInputClient;
      globalThis.keyboardController = kbController;
    })
    globalThis.inputEngine.on('inputStop', (imeId) => {
      this.addLog("pinyinime inputStop:" + imeId[0]);
      if (imeId[0] == "com.ohos.inputApp/InputDemoService") {
        this.onDestroy();
      }
    });
  }

  private unRegisterListener(): void{
    this.addLog("unRegisterListener");
    globalThis.inputEngine.off('inputStart');
    globalThis.inputEngine.off('inputStop');
    globalThis.inputEngine.off('keyboardShow');
    globalThis.inputEngine.off('keyboardHide');
    this.keyboardDelegate.off('keyDown');
    this.keyboardDelegate.off('keyUp');
    inputConsumer.off('key', {
      preKeys: [2072],
      finalKey: 2050,
      isFinalKeyDown: false,
      finalKeyDownDuration: 0
    }, this.ChnEngShift);
  }

  private showWindow() {
    this.addLog("showWindow");
    if (this.isPromptShowOnly) {
      setTimeout(() => {
        this.showHighWindow();
      }, 150);
      return;
    }
    this.showHighWindow();
  }

  private showHighWindow() {
    this.addLog("showHighWindow");
    try {
      this.getValue('setting.display.navigationbar_status');
    } catch (err) {
      console.log("[inputDemo] get value failed " + err)
      this.isWindowShowing = false;
      return;
    }
    console.log('[inputDemo] current navigation state is ' + this.getValueRes);
    windowManager.find(this.windowName).then((win) => {
      console.log("[inputDemo find target input app window, window size" + this.windowWidth + 'height:' + this.windowHeight);
      win.resetSize(this.windowWidth, this.windowHeight).then(() => {
        console.log('[inputDemo] start to move window to' + this.barPosition);
        win.moveTo(0, this.getValueRes == "1" ? this.barPosition : this.nonBarPosition).then(() => {
          console.log('[inputDemo] start to reload window ');
          win.show().then(() => {
            console.log('[inputDemo] input window show success');
            globalThis.isCurrentTouch = false;
            this.isKeyboardShow = true;
            this.isWindowShowing = false;
            this.isPromptShowOnly = false;
          })
        })
      })
    })

  }

  private hideWindow() {
    this.isWindowClosing = true;
    this.addLog('hideWindow');
    windowManager.find(this.windowName).then((win) => {
      win.hide().then(() => {
        this.isKeyboardShow = false;
        this.isPromptShowOnly = false;
        this.addLog('hideWindow finish');
        this.isWindowClosing = false;
      })
    })
  }

  private showPromptOnly() {
    this.addLog('showPromptOnly');
    this.isKeyboardShow = false;
    setTimeout(() => {
      this.showPromptCore();
    }, 200);
  }

  private showPromptCore() {
    this.addLog('showPromptCore');
    display.getDefaultDisplay().then(dis => {
      windowManager.find(this.windowName).then((win) => {
        win.hide().then(() => {
          win.resetSize(this.windowWidth, this.windowHeight * 0.25).then(() => {
            win.moveTo(0, this.windowHeight * 0.75 + ((this.getValueRes == '1') ? this.barPosition : this.nonBarPosition)).then(() => {
              win.show().then(() => {
                this.isPromptShowOnly = true;
                this.addLog('showPromptCore: window moveTo finish');
              })
            })
          })
        })
      })
    })
  }

  private addLog(message): void{
    console.info(this.TAG + message)
  }
}