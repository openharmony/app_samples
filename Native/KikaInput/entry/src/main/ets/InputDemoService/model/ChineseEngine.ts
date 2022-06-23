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
// @ts-nocheck
import { DecodeInfo, CharacterState } from './DecodeInfo';
import { EnglishProcessor } from './EnglishProcessor';
import inputMethodEngine from '@ohos.inputmethodengine';
import resourceManager from '@ohos.resourceManager';

export class ChineseEngine {
  private TAG: string = 'chinese engine debug :'
  private state: CharacterState;
  private keyboardType: number = 2;
  private decodeInfo: DecodeInfo;
  isUpper: boolean = false;
  private resultStr: string = ""
  mCurrentText: string = "";
  choiceId: number = 0;
  private englishProcessor: EnglishProcessor;

  constructor() {
    this.state = CharacterState.Idle;
    this.decodeInfo = new DecodeInfo();
    this.englishProcessor = new EnglishProcessor()
  }

  openDecodeFd(context): void
  {
    this.decodeInfo.openDecodeFd(context.resourceManager, "dict_pinyin.dat")
  }

  onDestroy() {
    this.decodeInfo.closeDecoder();
  }

  setPageSize(pageSize: number) {
    this.decodeInfo.pageSize = pageSize;
  }

  updateEnglishCandidate(keyValue) {

  }

  requirePage() {
    return this.decodeInfo.requirePageData(this.state);
  }

  getComposingStrForDisplay() {
    return this.decodeInfo.mComposingStrDisplay;
  }

  processKey(keyValue: string, realAction: boolean): boolean
  {
    if (this.state == CharacterState.ByPass) {
      return false;
    }

    if (keyValue == "") {
      return false
    }
    if (this.processFunctionKeys(keyValue, realAction)) {
      return true
    }
    let isChinese = AppStorage.Get("isChinese");
    let isHardKeyPressed = AppStorage.Get("isHardKeyPressed");
    if (!isChinese && (AppStorage.Get<number>('menuType') == 0 || isHardKeyPressed)) {
      return this.englishProcessor.processKey(keyValue, realAction)
    } else if (isChinese && (AppStorage.Get<number>('menuType') == 0 || isHardKeyPressed)) {
      this.addCharacterState(this.state);
      if (this.state == CharacterState.Idle || (this.state == CharacterState.Completion)) {
        this.state = CharacterState.Idle;
        return this.processStateIdle(keyValue, realAction)
      } else if (this.state == CharacterState.Input) {
        this.processStateInput(keyValue, realAction);
      } else if (this.state == CharacterState.Predict) {
        this.processStatePredict(keyValue, realAction);
      } else if (this.state == CharacterState.Composing) {
        this.processStateEditComposing(keyValue, realAction);
      }
    } else {
      if (keyValue! = "" && realAction) {
        this.commitResult(keyValue);
      }
    }
    return false
  }

  getCandidateList() {
    return this.decodeInfo.mCandidateList;
  }

  getCandidateNum() {
    return this.decodeInfo.mTotalChoicesNum;
  }

  private processFunctionKeys(keyValue: string, realAction: boolean) {
    if (keyValue == "KEYCODE_BACK") {
      AppStorage.Set("hidden", true);
      globalThis.keyboardController.hideKeyboard();
      return true;
    }
    if (keyValue == "KEYCODE_CAPS_LOCK") {
      let isUpper = AppStorage.Get<boolean>("isUpper");
      AppStorage.Set("isUpper",!isUpper);
      return true;
    }
    if (keyValue == "KEYCODE_ALT_LEFT" || keyValue == "KEYCODE_ALT_RIGHT") {
      let isChinese = AppStorage.Get<boolean>("isChinese");
      AppStorage.Set("isChinese",!isChinese);
      return true;
    }

    let isHardKeyPressed = AppStorage.Get("isHardKeyPressed");
    if (AppStorage.Get("isChinese") && (AppStorage.Get<number>("menuType") == 0 || isHardKeyPressed)) {
      console.log("[kikaInput] trigger chinese");
      return false
    }
    if (!this.decodeInfo.isCandidateEmpty()) {
      console.log("[kikaInput] keyvalue is" + keyValue);
      if (keyValue == 'KEYCODE_DPAD_CENTERE') {
        if (!realAction) {
          return true;
        }
        this.chooseCandidate(-1);
        return true;
      }
      if (keyValue == 'KEYCODE_DPAD_LEFT') {
        if (!realAction) {
          return true;
        }
        // 处理游标
        globalThis.inputEngine.moveCursor(inputMethodEngine.CURSOR_LEFT);
        return true;
      }
      if (keyValue == 'KEYCODE_DPAD_RIGHT') {
        if (!realAction) {
          return true;
        }
        // 处理游标
        globalThis.inputEngine.moveCursor(inputMethodEngine.CURSOR_RIGHT);
        return true;
      }
      if (keyValue == 'KEYCODE_DPAD_DOWN') {
        if (!realAction) {
          return true;
        }
        // 处理游标
        globalThis.inputEngine.moveCursor(inputMethodEngine.CURSOR_DOWN);
        return true;
      }
      if (keyValue == 'KEYCODE_DPAD_UP') {
        if (!realAction) {
          return true;
        }
        // 处理游标
        globalThis.inputEngine.moveCursor(inputMethodEngine.CURSOR_UP);
        return true;
      }
    } else {
      if (keyValue == 'KEYCODE_DEL') {
        if (!realAction) {
          return true;
        }
        globalThis.textInputClient.deleteForward(1);
        return true;
      }
      if (keyValue == 'KEYCODE_FORWARD_DEL') {
        if (!realAction) {
          return true;
        }
        globalThis.textInputClient.deleteBackward(1);
        return true;
      }
      if (keyValue == "KEYCODE_ENTER") {
        if (!realAction) {
          return true;
        }
        globalThis.textInputClient.insertText('\n');
        globalThis.textInputClient.sendKeyFunction(globalThis.editorAttribute.enterKeyType);
        return true;
      }
      if (keyValue == '' || keyValue == 'KEYCODE_SPACE') {
        if (!realAction) {
          return true;
        }
        globalThis.textInputClient.insertText('');
        return true;
      }
    }
    return false
  }

  private processStateIdle(keyValue: string, realAction: boolean): boolean
  {
    this.addLog("processStateIdle keyValue:" + keyValue + "realAction:" + realAction);
    if (keyValue == "KEYCODE_DEL") {
      if (!realAction) {
        return true;
      }
      globalThis.textInputClient.deleteForward(1);
    } else if (keyValue == "KEYCODE_FORWARD_DEL") {
      if (!realAction) {
        return true;
      }
      globalThis.textInputClient.deleteBackward(1);
    } else if (keyValue == "KEYCODE_ENTER") {
      if (!realAction) {
        return true;
      }
      globalThis.textInputClient.insertText('\n');
      globalThis.textInputClient.sendKeyFunction(globalThis.editorAttribute.enterKeyType)
      this.resetToIdleState(false);
      return true;
    }
    else if (keyValue == "KEYCODE_DPAD_LEFT" ||
    keyValue == "KEYCODE_DPAD_RIGHT" ||
    keyValue == "KEYCODE_DPAD_UP" ||
    keyValue == "KEYCODE_DPAD_DOWN" ||
    keyValue == "KEYCODE_SHIFT_LEFT") {
      this.hardKeyDirection(keyValue, realAction)
    }
    else if (keyValue == "KEYCODE_SPACE") {
      globalThis.textInputClient.insertText("");
    }
    else if (keyValue == "KEYCODE_ALT_LEFT" || keyValue == "KEYCODE_ALT_RIGHT" ||
    keyValue == "KEYCODE_SHIFT_LEFT" || keyValue == "KEYCODE_SHIFT_RIGHT") {
      return true;
    }
    else if (keyValue >= 'a' && keyValue <= 'z') {
      if (!realAction) {
        return true;
      }
      this.decodeInfo.addSplChar(keyValue, true);
      this.chooseAndUpdate(-1);
      return true;
    } else if (keyValue != '\t') {
      if (!realAction) {
        return true;
      }
      else {
        if (keyValue != '') {
          this.commitResult(keyValue);
        }
      }
      return true;
    }
    return false;
  }

  private isNumberKey(keyValue: string) {
    var num = parseInt(keyValue);
    if (isNaN(num) || num < 1 || num > 9) {
      return false;
    }
    return true;
  }

  private processStateInput(keyValue: string, realAction: boolean): boolean
  {
    this.addLog("processStateInput keyValue:" + keyValue + "realAction:" + realAction);
    var isNumberKey = this.isNumberKey(keyValue);
    if (keyValue >= "a" && keyValue <= "z" || keyValue == '\'' &&
    !this.decodeInfo.charBeforeCursorIsSeperator() || keyValue == "KEYCODE_DEL" || keyValue == "KEYCODE_FORWARD_DEL") {
      if (!realAction) {
        return true;
      }
      return this.processSurfaceChange(keyValue);
    } else if (keyValue == "," || keyValue == ".") {
      if (!realAction) {
        return true;
      }
      this.inputCommaPeriod(this.decodeInfo.getCurrentFullSent(AppStorage.Get<number>('activeNo')), keyValue, true, CharacterState.Idle);
      return true;
    } else if (keyValue == 'KEYCODE_DPAD_UP' || keyValue == 'KEYCODE_DPAD_DOWN' || keyValue == 'KEYCODE_DPAD_LEFT'
    || keyValue == 'KEYCODE_DPAD_RIGHT') {
      if (!realAction) {
        return true;
      }
      // TODD 虚拟上下左右键处理
      if (keyValue == 'KEYCODE_DPAD_LEFT') {
        let current: number = AppStorage.Get<number>('activeNo');
        this.addLog('DPAD_LEFT current=' + current);
        if (current - 1 >= 0) {
          AppStorage.Set<number>('activeNo', current - 1);
        } else {
          // 适配翻页
        }
      } else if (keyValue == 'KEYCODE_DPAD_RIGHT') {
        let current: number = AppStorage.Get<number>('activeNo');
        this.addLog('DPAD_RIGHT current=' + current);
        if (current + 1 < this.decodeInfo.mCandidateList.length) {
          AppStorage.Set<number>('activeNo', current + 1);
        } else {
          // TODD 适配翻页
        }
      } else if (keyValue == 'KEYCODE_DPAD_UP') {
        let currentPage = AppStorage.Get<number>('currentPage');
        // 待适配上一页下一页
        if (this.decodeInfo.mCandidateList.length >= 0) {
          AppStorage.Set("candidateList", this.decodeInfo.mCandidateList);
          AppStorage.Set("currentPage", currentPage--);
        } else {
          this.changeToStateComposing(true);
          this.updateComposingText(true);
        }
      } else {
        let currentPage = AppStorage.Get<number>('currentPage') + 1;
        if (this.decodeInfo.mCandidateList.length >= 0) {
          AppStorage.Set("candidateList", this.decodeInfo.mCandidateList);
          AppStorage.Set("currentPage", currentPage);
        }
      }
      return true;
    } else if (keyValue == "KEYCODE_ENTER") {
      if (!realAction) {
        return true;
      }
      let enterType = this.prepareToggleState();
      if (enterType) {
        this.commitResult(this.decodeInfo.getOriginalStr());
        this.resetToIdleState(false);
      } else {
        this.commitResult(this.decodeInfo.getCurrentFullSent(AppStorage.Get<number>('activeNo')));
        this.resetToIdleState(false);
      }
      return true;
    } else if (keyValue == "KEYCODE_DPAD_CENTER" || keyValue == '' || keyValue == 'KEYCODE_SPACE' || isNumberKey) {
      if (!realAction) {
        return true;
      }
      if (isNumberKey) {
        this.chooseCandidate(parseInt(keyValue) - 1);
      } else {
        this.chooseCandidate(-1);
      }
      return true;
    } else if (keyValue == 'KEYCODE_BACK') {
      if (!realAction) {
        return true;
      }
      this.resetToIdleState(false);
      globalThis.keyboardController.hideKeyboard();
      return true;
    }
    return false;
  }

  private processStatePredict(keyValue: string, realAction: boolean) {
    if (!realAction) {
      return true;
    }
    // process shift state
    if (this.isUpper != AppStorage.Get("isUpper")) {
      // 待添加中文键盘字符处理
      this.commitResult(this.decodeInfo.mCandidateList[AppStorage.Get<number>('activeNo')]);
      this.resetToIdleState(false);
    }
    if (keyValue >= 'a' && keyValue <= 'z') {
      this.state = CharacterState.Input;
      this.decodeInfo.addSplChar(keyValue, true);
      this.chooseAndUpdate(-1);
    } else if (keyValue == ',' || keyValue == '.') {
      this.inputCommaPeriod("", keyValue, true, CharacterState.Idle);
    } else if (keyValue == "KEYCODE_DPAD_LEFT" || keyValue == "KEYCODE_DPADRIGHT"
    || keyValue == "KEYCODE_DPAD_UP" || keyValue == "KEYCODE_DPAD_DOWN") {
      // todo处理上下左右键的逻辑
    } else if (keyValue == 'KEYCODE_DEL' || keyValue == 'KEYCODE_FORWARD_DEL') {
      this.resetToIdleState(false);
    } else if (keyValue == 'KEYCODE_BACK') {
      this.resetToIdleState(false);
      globalThis.keyboardController.hideKeyboard();
    } else if (keyValue == "KEYCODE_ENTER") {
      globalThis.textInputClient.sendKeyFunction(globalThis.editorAttribute.enterKeyType);
      this.resetToIdleState(false);
    } else if (keyValue == "KEYCODE_DPAD_CENTER" || keyValue == "" || keyValue == "KEYCODE_SPACE") {
      this.chooseCandidate(-1);
    }
    return true;
  }

  private processStateEditComposing(keyValue: string, realAction: boolean) {
    this.addLog("processStateEditComposing keyValue:" + keyValue + "realAction:" + realAction);
    if (!realAction) {
      return true;
    }
    // 处理alt按住逻辑
    if (keyValue == 'KEYCODE_DPAD_DOWN') {
      if (!this.decodeInfo.mFinishSelection) {
        this.changeToStateInput(true);
      }
    } else if ((keyValue == "KEYCODE_DPAD_LEFT") || (keyValue == "KEYCODE_DPAD_RIGHT")) {
      this.hardKeyDirection(keyValue, realAction)
    } else if (keyValue == "KEYCODE_DPAD_ENTER" || keyValue == '' || keyValue == 'KEYCODE_DPAD_CENTER'
    || keyValue == 'KEYCODE_SPACE') {
      if (this.decodeInfo.mFixLen == 0) {
        let str = this.decodeInfo.getOriginalStr();
        this.commitResult(str.toLowerCase());
      } else {
        let str = this.decodeInfo.mComposingStr;
        this.commitResult(str);
      }
      this.resetToIdleState(false);
    } else if (keyValue == 'KEYCODE_ENTER') {
      let retStr;
      if (this.decodeInfo.mCandidateList.length > 0) {
        retStr = this.decodeInfo.getCurrentFullSent(AppStorage.Get<number>("activeNo"));
      } else {
        retStr = this.decodeInfo.mComposingStr;
      }
      this.commitResult(retStr);
      globalThis.textInputClient.insertText('\n');
      globalThis.textInputClient.sendKeyFunction(globalThis.editorAttribute.enterKeyType);
      this.resetToIdleState(false);
    } else if (keyValue == 'KEYCODE_BACK') {
      this.resetToIdleState(false);
      globalThis.keyboardController.hideKeyboard();
      return true;
    } else {
      return this.processSurfaceChange(keyValue);
    }
    return true;
  }

  private processSurfaceChange(keyValue: string) {
    this.addLog('processSurfaceChange keyValue:' + keyValue);
    if (this.decodeInfo.isSplStrFull() && (keyValue == 'KEYCODE_DEL' || keyValue == 'KEYCODE_FORWARD_DEL')) {
      return true;
    }
    if (keyValue >= 'a' && keyValue <= 'z' || (keyValue == '\'' && !this.decodeInfo.charBeforeCursorIsSeperator())
    || ((keyValue >= '0' && keyValue <= '9') || keyValue == '' || keyValue == 'KEYCODE_SPACE') && this.state == CharacterState.Composing) {
      this.decodeInfo.addSplChar(keyValue, false);
      this.chooseAndUpdate(-1);
    } else if (keyValue == 'KEYCODE_DEL' || keyValue == 'KEYCODE_FORWARD_DEL') {
      this.decodeInfo.prepareDeleteBeforeCursor();
      this.chooseAndUpdate(-1);
    }
    return true;
  }

  private changeToStateComposing(updateUi) {
    this.state = CharacterState.Composing;
    if (!updateUi) {
      return;
    }
  }

  private changeToStateInput(updateUi: boolean) {
    this.state = CharacterState.Input;
    // 刷新promptText
    if (!updateUi) {
      return;
    }
    this.showCandidateWindow();
  }

  private showCandidateWindow() {
    AppStorage.Set('activeNo', 0);
    if (this.state == CharacterState.Predict) {
      AppStorage.Set('promptText', '');
    } else {
      AppStorage.Set('promptText', this.getComposingStrForDisplay());
    }
    AppStorage.Set('candidateList', this.decodeInfo.mCandidateList);
  }

  private inputCommaPeriod(preEdit: string, keyValue: string, isDismissCandi: boolean, state: CharacterState) {
    if (keyValue == ',') {
      preEdit += '\uff0c'
    } else if (keyValue == '.') {
      preEdit += '\u3002'
    } else {
      return;
    }
    globalThis.textInputClient.insertText(preEdit);
    if (isDismissCandi) {
      this.resetCandidateWindow();
      this.state = state;
    }
  }

  resetToIdleState(resetInlineText: boolean) {
    if (this.state == CharacterState.Idle) {
      return;
    }
    this.state = CharacterState.Idle;
    this.decodeInfo.reset();
    if (resetInlineText) {
      globalThis.textInputClient.insertText('');
    }
    this.resetCandidateWindow();
  }

  choiceTouched(activeNo: number): void
  {
    this.addCharacterState(this.state);
    if (this.state == CharacterState.Composing) {
      this.changeToStateInput(true);
    } else if (this.state == CharacterState.Input || this.state == CharacterState.Predict) {
      this.addCharacterState(this.state);
      this.chooseCandidate(activeNo);
    } else if (this.state == CharacterState.Completion) {
      this.resetToIdleState(false);
    }
  }

  doPrediction(val: string) {
    if (!this.decodeInfo.canDoPrediction()) {
      return
    }
    this.decodeInfo.preparePredicts(val, this.state);
    this.showCandidateWindow()
  }

  private async chooseAndUpdate(candidateId: number) {
    let isHardKeyPressed = AppStorage.Get('isHardKeyPressed');
    if (!AppStorage.Get("isChinese") || (AppStorage.Get('menuType') != 0) && !isHardKeyPressed) {
      let choice = this.decodeInfo.getCandidate(candidateId);
      if (choice) {
        await globalThis.textInputClient.insertText(choice);
      }
      this.resetToIdleState(false);
      return;
    }
    if (this.state != CharacterState.Predict) {
      this.decodeInfo.chooseDecodingCandidate(candidateId, this.state);
    } else {
      this.decodeInfo.choosePredictChoice(candidateId, this.state);
    }
    do {
      if (this.decodeInfo.mComposingStr.length == 0) {
        this.resetToIdleState(false);
        break;
      }
      if (candidateId >= 0 && this.decodeInfo.canDoPrediction()) {
        this.addCharacterState(this.state);
        await this.commitResult(this.decodeInfo.getComposingStrActivePart());
        this.state = CharacterState.Predict;
        if (AppStorage.Get('prediction') == true) {
          this.decodeInfo.resetCandidate();
          this.resetToIdleState(false);
        }
        break;
      }
      if (this.state == CharacterState.Idle) {
        if (this.decodeInfo.mSurfaceDecodeLen == 0) {
          this.changeToStateComposing(true);
        } else {
          this.changeToStateInput(false);
        }
      } else {
        if (this.decodeInfo.mFinishSelection) {
          this.changeToStateComposing(true);
        }
      }
      this.showCandidateWindow();
    } while (0);
  }

  private chooseCandidate(activeCandidateNo: number) {
    if (activeCandidateNo < 0) {
      // get currentIndex
      console.log("[kikaInput] set invalid candidate value 0");
      activeCandidateNo = AppStorage.Get<number>("activeNo");
    }
    if (activeCandidateNo >= 0) {
      this.chooseAndUpdate(activeCandidateNo);
    }
  }

  private dismissCandidateWindow() {
    AppStorage.Set('hidden', true);
  }

  private resetCandidateWindow() {
    // todo关闭候选文字框以及上方popup
    this.decodeInfo.resetCandidate();
    this.showCandidateWindow();
  }

  private async commitResult(val: string) {
    await globalThis.textInputClient.insertText(val);
    AppStorage.Set('PromptText', '');
  }

  private updateComposingText(visible: boolean) {
    AppStorage.Set("promptText", this.decodeInfo.getOriginalStr());
  }

  private addLog(log) {
    console.log(this.TAG + log)
  }

  private addCharacterState(state: CharacterState) {
    let value = '';
    switch (state) {
      case CharacterState.ByPass:
        value = 'byPass';
        break
      case CharacterState.Completion:
        value = 'Completion';
        break
      case CharacterState.Composing:
        value = 'Composing';
        break
      case CharacterState.Idle:
        value = 'Idle';
        break
      case CharacterState.Input:
        value = 'Input';
        break
      case CharacterState.Predict:
        value = 'predict';
        break
    }
    console.log("[kikaInput]current state is " + value);
  }

  private prepareToggleState() {
    // 待适配对应修改
    if (globalThis.editorAttribute == undefined) {
      return false;
    }
    let keyType = globalThis.editorAttribute.enterKeyType;
    if (keyType == inputMethodEngine.ENTER_KEY_TYPE_UNSPECIFIED) {
      return false;
    }
    return true;
  }

  private hardKeyDirection(keyValue: string, realAction: boolean): boolean{
    if (keyValue == 'KEYCODE_DPAD_LEFT') {
      if (!realAction) {
        return true;
      }
      inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_LEFT);
      return true;
    }
    else if (keyValue == 'KEYCODE_DPAD_RIGHT') {
      if (!realAction) {
        return true;
      }
      inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_RIGHT);
      return true;
    }
    else if (keyValue == 'KEYCODE_DPAD_DOWN') {
      if (!realAction) {
        return true;
      }
      inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_DOWN);
      return true;
    }
    else if (keyValue == 'KEYCODE_DPAD_UP') {
      if (!realAction) {
        return true;
      }
      inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_UP);
      return true;
    } else if (keyValue == "KEYCODE_SHIFT_LEFT") {
      return true;
    }
  }
}