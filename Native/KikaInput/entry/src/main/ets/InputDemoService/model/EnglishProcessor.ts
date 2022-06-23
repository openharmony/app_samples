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
import inputMethodEngine from '@ohos.inputMethodEngine';

export class EnglishProcessor {
  private mLastKeyCode: string = "";

  processKey(keyValue: string, realAction: boolean) {
    console.log("english value is " + keyValue);
    if (!realAction) {
      return true;
    }
    if (keyValue == "") {
      return false;
    }
    try {
      if (keyValue >= 'a' && keyValue <= 'z') {
        if (AppStorage.Get<boolean>('isUpper')) {
          keyValue = keyValue.toUpperCase();
        }
      }
      if (keyValue == 'KEYCODE_DEL') {
        if (realAction) {
          globalThis.textInputClient.deleteForward(1);
        }
      }
      else if (keyValue == 'KEYCODE_ENTER') {
        globalThis.textInputClient.insertText('\n');
        globalThis.textInputClient.sendKeyFunction(globalThis.editorAttribute.enterKeyType);
        return true;
      } else if (keyValue == 'KEYCODE_SPACE') {
        keyValue = " ";
      }
      else if (keyValue == 'KEYCODE_DPAD_UP') {
        inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_UP);
      }
      else if (keyValue == 'KEYCODE_DPAD_DOWN') {
        inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_DOWN);
      }
      else if (keyValue == 'KEYCODE_DPAD_LEFT') {
        inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_LEFT);
      }
      else if (keyValue == 'KEYCODE_DPAD_RIGHT') {
        inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_RIGHT);
      }
      else if (keyValue == 'KEYCODE_SHIFT_LEFT' || keyValue == 'KEYCODE_SHIFT_RIGHT') {
        return true;
      }
      else if (keyValue == "") {
        return false;
      } else {
        globalThis.textInputClient.insertText(keyValue);
      }
    } catch (error) {
      console.log("[kikaInput] process english error: " + error)
    }
  }

  private addLog(val: string) {
    console.log("[EnglishProcessor]:" + val);
  }
}