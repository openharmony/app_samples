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

export class DistributedDataModel {
  public isOver: boolean = false
  public step: number = 0
  public chessMapArr: Array<Array<string>> = []
  public chessX: number = -1
  public chessY: number = -1
  public fallGather: Array<Array<number>> = []
  public clickCount: number = 0
  public fallLocation: Array<number> = []

  constructor(isOver: boolean) {
    this.isOver = isOver
  }

  init() {
    this.isOver = false
    for (let i = 0; i < 15; i++) {
      this.chessMapArr[i] = []
      for (let j = 0; j < 15; j++) {
        this.chessMapArr[i][j] = ''
      }
    }
    this.chessX = -1
    this.chessY = -1
  }

  fallChess(x: number, y: number, color: string) {
    this.fallGather.unshift([x, y])
    this.chessMapArr[x][y] = color
    this.chessX = x
    this.chessY = y
  }
}
