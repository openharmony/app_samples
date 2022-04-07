/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

let TAG = '[eTSRPC.ProcessData]'

export class ProcessData {
  private priceArr: Array<string> = new Array(8).fill('')

  getPrice(selectStuffs: Array<any>) {
    for (var i = 0; i < selectStuffs.length; i++) {
      this.priceArr[i] = selectStuffs[i].subcategory
      if (this.priceArr[i] === '') {
        this.priceArr[i] = '0'
      }
      this.priceArr[i+selectStuffs.length] = selectStuffs[i].count.toString()
      console.log(`${TAG} priceArray[${i+selectStuffs.length}]= ${typeof(this.priceArr[i+selectStuffs.length])}`)
    }
    console.log(`${TAG} priceArray= ${this.priceArr}`)
    return this.priceArr
  }
}