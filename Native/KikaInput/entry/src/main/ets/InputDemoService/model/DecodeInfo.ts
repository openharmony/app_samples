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
import pinyinime from 'libpinyinime.so'

export enum CharacterState {
  ByPass,
  Idle,
  Input,
  Composing,
  Predict,
  Completion
}

export class DecodeInfo {
  mSurface: string = "";
  mSurfaceDecodeLen: number = 0;
  mComposingStr: string = "";
  private mActiveCmpsLen: number = 0;
  private mActiveCmpsDisplayLen: number = 0;
  private mFullSent: string = ""; // 全量文字
  mFixLen: number = 0;
  mFinishSelection: boolean; // 是否选择完成候选框;
  pageSize: number = 30;
  private mSplStart: number[]; // 拼音候选
  cursorPos: number = 0;
  private mPosDelSpl: number = -1; // 拼音字符串位置
  mCandidateList: string[] = [];
  mTotalChoicesNum: number = 0;
  mComposingStrDisplay: string = "";
  mIsPosInSpl: boolean = false;

  constructor() {
    this.mSurfaceDecodeLen = 0;
  }

  reset() {
    this.mSurface = "",
    this.mSurfaceDecodeLen = 0;
    this.cursorPos = 0;
    this.mFullSent = '';
    this.mFinishSelection = false;
    this.mActiveCmpsDisplayLen = 0;
    this.mComposingStr = '';
    this.mComposingStrDisplay = "";
    this.mCandidateList = [];
    this.mTotalChoicesNum = 0;
    this.resetCandidate();
  }

  openDecodeFd(resmgr, fileName: string) {
    if (pinyinime.openDecoderFd(resmgr, fileName)) {
      console.log("==== open decoder success ======");
    } else {
      console.log("===== open decoder failed =====")
    }
  }

  closeDecoder(): void
  {
    pinyinime.closeDecoder();
  }

  resetSearch(): void
  {
    pinyinime.resetSearch();
  }

  isCandidateEmpty() {
    return this.mCandidateList.length == 0;
  }

  isSplStrFull() {
    const maxLen = 28;
    return this.mSurface.length >= maxLen - 1;
  }

  addSplChar(keyValue: string, reset: boolean) {
    if (reset) {
      this.mSurface = ''
      this.mSurfaceDecodeLen = 0;
      this.cursorPos = 0;
      pinyinime.resetSearch();
    }
    this.insert(keyValue);
  }

  // 删除操作之前对位置的校正
  prepareDeleteBeforeCursor() {
    let pos = 0;
    for (pos = 0; pos < this.mFixLen; pos++) {
      if (this.mSplStart[pos+2] >= this.cursorPos && this.mSplStart[pos+1] < this.cursorPos) {
        this.mPosDelSpl = pos;
        this.cursorPos = this.mSplStart[pos+1];
        this.mIsPosInSpl = true;
        break;
      }
    }
    if (this.mPosDelSpl < 0) {
      this.mPosDelSpl = this.cursorPos - 1;
      this.cursorPos--;
      this.mIsPosInSpl = false;
    }
  }

  getOriginalStr() {
    return this.mSurface;
  }

  getComposingStrActivePart() {
    return this.mFullSent.substring(0, this.mActiveCmpsLen);
  }

  getCurrentFullSent(activeCandPos: number) {
    try {
      var retStr = this.mFullSent.substring(0, this.mFixLen);
      retStr += this.mCandidateList[activeCandPos];
      return retStr;
    } catch (error) {
      console.error("===== get current full sent error =====" + error + activeCandPos);
    }
    return ''
  }

  candidateFromApp(state: CharacterState) {
    return CharacterState.Completion == state;
  }

  canDoPrediction() {
    return this.mComposingStr.length == this.mFixLen;
  }

  resetCandidate() {
    this.mCandidateList = [];
    this.mTotalChoicesNum = 0
  }

  chooseDecodingCandidate(candidateId: number, state: CharacterState) {
    if (state == CharacterState.Predict) {
      return;
    }
    this.resetCandidate();
    let totalChoicesNum = 0;
    do {
      if (candidateId >= 0) {
        totalChoicesNum = pinyinime.choose(candidateId); // 1
        break;
      }
      if (this.mSurface.length == 0) {
        totalChoicesNum = 0;
        break;
      }
      if (this.mPosDelSpl < 0) {
        totalChoicesNum = pinyinime.search(this.mSurface, this.mSurface.length);
        break;
      }
      let clearFixStep = true;
      if (state == CharacterState.Composing) {
        clearFixStep = false;
      }
      totalChoicesNum = pinyinime.delSearch(this.mPosDelSpl, this.mIsPosInSpl, clearFixStep);
      this.mPosDelSpl = -1;
    } while (0);
    this.updateDecInfoForSearch(totalChoicesNum, state);
  }

  getFullSent(activeNo: number) {
    try {
      let retStr = this.mFullSent.substring(0, this.mFixLen);
      retStr += this.mCandidateList[activeNo];
      return retStr;
    } catch (error) {
      return ''
    }
  }

  private updateDecInfoForSearch(totalChoicesNum: number, state: CharacterState) {
    this.mTotalChoicesNum = totalChoicesNum; // 1
    console.log("[kikaInput] candidate num is" + totalChoicesNum);
    if (this.mTotalChoicesNum < 0) {
      this.mTotalChoicesNum = 0;
      return;
    }
    try {
      let pyStr: string;

      this.mSplStart = pinyinime.getSplStart();
      pyStr = pinyinime.getPyStr(false);
      this.mSurfaceDecodeLen = pinyinime.getPyStrLen(true);
      if (this.mSurfaceDecodeLen > pyStr.length) {
        return;
      }

      this.mFullSent = pinyinime.getChoice(0);
      this.mFixLen = pinyinime.getFixedLen();
      this.mSurface = pyStr;
      if (this.cursorPos > this.mSurface.length) {
        this.cursorPos = this.mSurface.length;
      }
      this.mComposingStr = this.mFullSent.substring(0, this.mFixLen) + this.mSurface.substring(this.mSplStart[this.mFixLen + 1]);
      this.mActiveCmpsLen = this.mComposingStr.length;
      if (this.mSurfaceDecodeLen > 0) {
        this.mActiveCmpsLen = this.mActiveCmpsLen - (this.mSurface.length - this.mSurfaceDecodeLen);
      }
      // prepare the display string
      if (this.mSurfaceDecodeLen == 0) {
        this.mComposingStrDisplay = this.mComposingStr;
        this.mActiveCmpsDisplayLen = this.mComposingStr.length;
      } else {
        this.mComposingStrDisplay = this.mFullSent.substring(0, this.mFixLen);
        for (let pos = this.mFixLen + 1;pos < this.mSplStart.length - 1; pos++) {
          this.mComposingStrDisplay += this.mSurface.substring(this.mSplStart[pos], this.mSplStart[pos+1]);
          if (this.mSplStart[pos+1] < this.mSurfaceDecodeLen) {
            this.mComposingStrDisplay += '';
          }
        }
        this.mActiveCmpsDisplayLen = this.mComposingStrDisplay.length;
        if (this.mSurfaceDecodeLen < this.mSurface.length) {
          this.mComposingStrDisplay += this.mSurface.substring(this.mSurfaceDecodeLen);
        }

        if (this.mSplStart.length == this.mFixLen + 2) {
          this.mFinishSelection = true;
        } else {
          this.mFinishSelection = false;
        }
      }
    } catch (error) {
      console.log("===== UpdateDecodeInfo for search error =====" + error);
      this.mTotalChoicesNum = 0;
      this.mComposingStr = "";
    }
    if (!this.mFinishSelection) {
      // 刷新候选词
      this.requirePageData(state);
    }
  }

  getCandidate(candId: number) {
    if (candId < 0 || candId > this.mCandidateList.length) {
      return null;
    }
    return this.mCandidateList[candId];
  }

  preparePredicts(history: string, state: CharacterState) {
    if (history == '') {
      return;
    }
    this.resetCandidate();
    let historyCode = [];
    for (let i = 0;i < history.length; i++) {
      historyCode.push(history.charCodeAt(i));
    }
    this.mTotalChoicesNum = pinyinime.getPredictsNum(historyCode);
    // update prediction list
    this.requirePageData(state);
    this.mFinishSelection = false;
  }

  charBeforeCursorIsSeperator() {
    let len = this.mSurface.length;
    if (this.cursorPos > len) {
      return false;
    }
    if (this.cursorPos > 0 && this.mSurface[this.cursorPos-1] == "\'") {
      return true;
    }
    return false;
  }

  getCursorPosInCmps() {
    let curPos = this.cursorPos;
    for (let hzPos = 0;hzPos < this.mFixLen; hzPos++) {
      if (this.cursorPos > this.mSplStart[hzPos+2]) {
        curPos -= this.mSplStart[hzPos + 2] - this.mSplStart[hzPos +1];
        curPos += 1;
      }
    }
    return curPos;
  }

  getCursorPosInCmpsDisplay() {
    let curPos = this.getCursorPosInCmps();

    for (let pos = this.mFixLen + 2;pos < this.mSplStart.length; pos++) {
      if (this.cursorPos <= this.mSplStart[pos]) {
        break;
      }
      curPos++;
    }
    return curPos;
  }

  moveCursorToEdge(left: boolean) {
    if (left) {
      this.cursorPos = 0;
    } else {
      this.cursorPos = this.mSurface.length;
    }
  }

  moveCursor(offset: number) {
    if (offset > 1 || offset < -1) {
      return;
    }
    if (offset != 0) {
      let hzPos = 0;
      for (hzPos = 0; hzPos <= this.mFixLen; hzPos++) {
        if (this.cursorPos == this.mSplStart[hzPos+1]) {
          if (offset < 0) {
            if (hzPos > 0) {
              offset = this.mSplStart[hzPos] - this.mSplStart[hzPos+1];
            } else {
              if (hzPos < this.mFixLen) {
                offset = this.mSplStart[hzPos+2] - this.mSplStart[hzPos+1];
              }
            }
            break;
          }
        }
      }
    }
    this.cursorPos += offset;
    if (this.cursorPos < 0) {
      this.cursorPos = 0;
    } else if (this.cursorPos > this.mSurface.length) {
      this.cursorPos = this.mSurface.length;
    }
  }

  getSplNum() {
    return this.mSplStart[0];
  }

  private prepareAppCompletions() {
  }

  requirePageData(state: CharacterState) {
    let fetchStart = this.mCandidateList.length;
    if (fetchStart >= this.mTotalChoicesNum || fetchStart < 0) {
      return [];
    }
    let fetchSize = this.mTotalChoicesNum - fetchStart;
    if (fetchSize > this.pageSize) {
      fetchSize = this.pageSize;
    }
    if (state == CharacterState.Input || (state == CharacterState.Idle) || (state == CharacterState.Composing)) {
      this.getChoiceList(fetchStart, fetchSize, this.mFixLen);
    } else if (state == CharacterState.Predict) {
      this.getPredictList(fetchStart, fetchSize);
    } else if (state == CharacterState.Completion) {
    }
  }

  private getChoiceList(choiceStart: number, choiceNum: number, sendFixLen: number) {
    for (let i = choiceStart;i < choiceStart + choiceNum; i++) {
      let retStr = pinyinime.getChoice(i);
      if (i == 0) {
        retStr = retStr.substring(sendFixLen);
      }
      this.mCandidateList.push(retStr);
    }
  }

  private getPredictList(predictStart: number, predictsNum: number) {
    for (let i = predictStart;i < predictStart + predictsNum; i++) {
      let targetValue = pinyinime.getPredictItem(i);
      if (targetValue != undefined) {
        this.mCandidateList.push(targetValue);
      }
    }
  }

  private updateCandidates(state: CharacterState) {
    let fetchSize = this.mTotalChoicesNum;
    let fetchStart = 0;
    if (state == CharacterState.Input || state == CharacterState.Idle || state == CharacterState.Composing) {
      this.getChoiceList(fetchStart, fetchSize, this.mFixLen);
    } else if (state == CharacterState.Predict) {
      this.getPredictList(fetchStart, fetchSize);
    } else if (state == CharacterState.Completion) {
      // TODO
    }
  }

  choosePredictChoice(choiceId: number, state: CharacterState) {
    if (state != CharacterState.Predict || (choiceId < 0) || (choiceId > this.mTotalChoicesNum)) {
      return;
    }

    let tmp = this.mCandidateList[choiceId];
    this.resetCandidate();
    this.mCandidateList.push(tmp);
    this.mSurface = "";
    this.mTotalChoicesNum = 1;
    this.cursorPos = 0;
    this.mFullSent = tmp;
    this.mComposingStr = this.mFullSent;
    this.mFixLen = tmp.length;
    this.mComposingStr = this.mFullSent;
    this.mActiveCmpsLen = this.mFixLen;
    this.mFinishSelection = true;
  }

  private insert(keyValue) {
    this.mSurface = this.mSurface.slice(0, this.cursorPos) + keyValue + this.mSurface.slice(this.cursorPos);
    this.cursorPos++;
  }

  private addLog(log: string) {
    console.log("===== decode pinyin info =====" + log);
  }
}