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
export class CandidateSource implements IDataSource {
  public candidateList: string[] = [];
  private listeners: DataChangeListener[] = [];
  private totalNum: number = 0;

  public totalCount(): number {
    return this.totalNum;
  }

  public getData(index: number) {
    let count = this.totalCount();
    let candidateLen = this.candidateList.length;
    while (index > candidateLen && candidateLen < count) {
      globalThis.chineseEngine.requirePage();
      candidateLen = this.candidateList.length;
    }
    if (this.candidateList.length > index) {
      return { index: index, value: this.candidateList[index] };
    }
    return undefined;
  }

  registerDataChangeListener(listener: DataChangeListener) {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener) {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(candidateList: string[]): void{
    if (candidateList.length == 0 || globalThis.chineseEngine == undefined) {
      return;
    }
    console.debug("[kikaInput trigger update list update");
    this.candidateList = candidateList;
    let targetNum = globalThis.chineseEngine.getCandidateNum();
    this.totalNum = targetNum > 100 ? 100 : targetNum
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }
}