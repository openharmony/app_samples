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

import HiLog from '../common/HiLog'

const TAG: string = '[Initialize]'
const MINE = 9

export class initialize {

  initArray(size, value) {
    return Array.from({ length: size }, () => Array.from({ length: size }, () => value))
  }

  initBoard(maxCount: number, size: number) {
    let map = this.initArray(size, 0)
    let count = 0
    while (count < maxCount) {
      let row = Math.floor(Math.random() * 6)
      let col = Math.floor(Math.random() * 6)
      HiLog.log(TAG, ' row=' + row + ', col=' + col)
      if (map[row][col] != MINE) {
        map[row][col] = MINE
        for (let i = row - 1;i < row + 2; i++) {
          for (let j = col - 1;j < col + 2; j++) {
            if (i > -1 && j > -1 && i < 6 && j < 6 && map[i][j] != 9) {
              map[i][j]++
            }
          }
        }
        count++
      }
    }
    return map
  }
}