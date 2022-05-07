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

import router from '@ohos.router';
import HiLog from '../common/HiLog'
import { TitleBar } from '../common/TitleBar'
import { initialize } from '../model/Initialize'
import { GameOverDialog } from '../common/GameOverDialog';
import { WinningGameDialog } from '../common/WinningGameDialog';

const TAG = '[Index]'
const PRESS = 1
const LEFT = 1
const RIGHT = 2
const MIDDLE = 4
const MINE = 9
const SIZE = 6
const RED = '#fa0202'
const GRAY = '#eeeeee'
const WHITE = '#ffffff'

@Entry
@Component
struct Index {
  private initialize = new initialize()
  private board: Array<Array<number>> = this.initialize.initArray(SIZE, 0)
  private maxCount: number = 5
  @State color: string = ''
  @State hoverIndex: number = -1
  @State hoverSecond: number = -1
  @State signs: Array<Array<string>> = this.initialize.initArray(SIZE, '')
  @State colors: Array<Array<string>> = this.initialize.initArray(SIZE, GRAY)
  failDialogController: CustomDialogController = new CustomDialogController({
    builder: GameOverDialog({ confirm: this.onAccept }),
    autoCancel: false
  })
  successDialogController: CustomDialogController = new CustomDialogController({
    builder: WinningGameDialog({ confirm: this.onAccept }),
    autoCancel: false
  })

  aboutToAppear() {
    this.board = this.initialize.initBoard(this.maxCount, SIZE)
    HiLog.log(TAG, ` board=${JSON.stringify(this.board)}`)
  }

  onAccept() {
    router.replace({
      url: 'pages/index'
    })
  }

  updateColor(row, col, isSign: boolean) {
    if (isSign) {
      if (row === this.hoverIndex && col === this.hoverSecond) {
        const temp = this.colors.slice()
        temp[row][col] = RED
        HiLog.log(TAG, ` temp[${row}][${col}]= ${JSON.stringify(temp[row][col])}`)
        this.color = RED
        this.colors = temp
      }
    } else {
      if (this.colors[row][col] === GRAY) {
        const temp = this.colors.slice()
        temp[row][col] = WHITE
        HiLog.log(TAG, ` temp[${row}][${col}]= ${JSON.stringify(temp[row][col])}`)
        this.color = WHITE
        this.colors = temp
      } else {
        const temp = this.colors.slice()
        temp[row][col] = GRAY
        HiLog.log(TAG, ` temp[${row}][${col}]= ${JSON.stringify(temp[row][col])}`)
        this.color = GRAY
        this.colors = temp
      }
    }
  }

  getMouseLocation(row, col) {
    if (row === this.hoverIndex && col === this.hoverSecond) {
      HiLog.log(TAG, ` getMouseLocation this.hoverIndex= ${this.hoverIndex}  this.hoverSecond= ${this.hoverSecond}`)
      return 0.5
    } else {
      return 1
    }
  }

  updateMap(row, col, item) {
    let temp = this.signs.slice()
    if (row === this.hoverIndex && col === this.hoverSecond) {
      HiLog.log(TAG, ` updateMap item= ${JSON.stringify(item)}`)
      temp[row][col] = item.toString()
    }
    this.signs = temp
  }

  build() {
    Column() {
      TitleBar()
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Row() {
          Text($r('app.string.surplus'))
            .height('10%')
            .fontSize(24)
            .textAlign(TextAlign.End)
          Text(this.maxCount.toString())
            .height('10%')
            .fontSize(24)
            .textAlign(TextAlign.Start)
        }

        ForEach(this.board, (item, row) => {
          Row() {
            ForEach(this.board[row], (item, col) => {
              Text(this.signs[row][col])
                .width(70)
                .height(70)
                .border({ width: 1 })
                .fontSize(24)
                .backgroundColor(this.colors[row][col])
                .opacity(this.getMouseLocation(row, col))
                .textAlign(TextAlign.Center)
                .onHover((isHover: Boolean) => {
                  if (isHover) {
                    this.hoverIndex = row
                    this.hoverSecond = col
                    HiLog.log(TAG, ` onHover this.hoverIndex= ${this.hoverIndex} this.hoverSecond= ${this.hoverSecond}`)
                  }
                })
                .onMouse((event: MouseEvent) => {
                  if (event.action !== PRESS) {
                    return
                  }
                  HiLog.log(TAG, `press ${event.button}`)
                  if (event.button === LEFT) {
                    HiLog.log(TAG, ` this.colors[${row}][${col}]= ${this.colors[row][col]} typeof= ${typeof (this.colors[row][col])}`)
                    if (this.colors[row][col] !== RED) {
                      this.hoverIndex = row
                      this.hoverSecond = col
                      HiLog.log(TAG, ` row= ${row} col= ${col}`)
                      this.updateMap(row, col, item)
                      if (item === MINE) {
                        this.failDialogController.open()
                      }
                    }
                  }
                  if (event.button === RIGHT) {
                    if (this.signs[row][col] === '') {
                      this.hoverIndex = row
                      this.hoverSecond = col
                      HiLog.log(TAG, ` left colors${JSON.stringify(this.colors)}`)
                      if (item === MINE && this.colors[row][col] !== RED) {
                        this.updateColor(row, col, true)
                        this.maxCount -= 1
                        if (this.maxCount === 0) {
                          this.successDialogController.open()
                        }
                      }
                      if (item !== MINE) {
                        this.failDialogController.open()
                      }
                    }
                  }
                  if ((event.button === RIGHT && event.button === LEFT) || event.button === MIDDLE) {
                    if (this.signs[row][col] === '') {
                      HiLog.log(TAG, ` this.signs[${row}][${col}] = ${this.signs[row][col]}`)
                      return
                    }
                    HiLog.log(TAG, ` enter the botton 4`)
                    this.hoverIndex = row
                    this.hoverSecond = col
                    let temp: Array<{
                      x: number,
                      y: number
                    }> = []
                    HiLog.log(TAG, ` temp ${JSON.stringify(temp)}`)
                    HiLog.log(TAG, `this.hoverIndex= ${this.hoverIndex} this.hoverSecond= ${this.hoverSecond}`)
                    for (let i = ((this.hoverIndex - 1) > 0 ? this.hoverIndex - 1 : 0); i < (this.hoverIndex + 2 < SIZE ? this.hoverIndex + 2 : SIZE); i++) {
                      for (let j = ((this.hoverSecond - 1) > 0 ? this.hoverSecond - 1 : 0); j < (this.hoverSecond + 2 < SIZE ? this.hoverSecond + 2 : SIZE); j++) {
                        HiLog.log(TAG, ` this.signs[${i}][${j}]= ${this.signs[i][j]}  this.colors[${i}][${j}]= ${this.colors[row][col]}`)
                        if (this.signs[i][j] === '' && this.colors[i][j] === GRAY) {
                          HiLog.log(TAG, ` i=${i} j=${j}`)
                          this.updateColor(i, j, false)
                          temp.push({ x: i, y: j })
                        }
                      }
                    }
                    setTimeout(() => {
                      HiLog.log(TAG, ` sleep 1s`)
                      for (let i = 0;i < temp.length; i++) {
                        HiLog.log(TAG, ` sleep 1s,point.x` + temp[i].x)
                        this.updateColor(temp[i].x, temp[i].y, false)
                      }
                    }, 1000)
                  }
                })
            });
          }
        });
      }
      .width('100%')
      .height('90%')
    }
    .width('100%')
    .height('100%')
  }
}