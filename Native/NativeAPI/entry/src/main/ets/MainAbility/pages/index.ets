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
import chessNapi from "libchess.so"
import prompt from '@ohos.prompt';
import Logger from '../model/Logger'

const AI_CHESS: number = 2 // 2为AI落子
const USER_CHESS: number = 1 // 1为用户落子
const AI_WIN: number = 2 // 2代表AI胜利
const USER_WIN: number = 1 // 1代表用户胜利
const SIZE: number = 15
const TAG: string = 'Index'

function initArray(size, value) {
  return Array.from({ length: size }, () => Array.from({ length: size }, () => value))
}

@Entry
@Component
struct Index {
  @State chessboard: Array<Array<number>> = initArray(SIZE, 0)
  @State message: Resource = $r('app.string.game_not_start')
  @State @Watch('isPlayChange') isPlay: boolean = false

  getChessImg(item) {
    if (item === USER_CHESS) {
      return $r('app.media.ic_white')
    }
    if (item === AI_CHESS) {
      return $r('app.media.ic_black')
    }
    return undefined
  }

  isPlayChange() {
    Logger.info(TAG, `isPlayChange,isPlay:${this.isPlay}, message:${this.message}`)
    if (!this.isPlay) {
      AlertDialog.show({
        message: this.message,
        primaryButton: {
          value: $r('app.string.sure'),
          action: () => {
            this.chessboard = initArray(SIZE, 0)
          }
        }
      })
    }
  }

  aiPlay() {
    Logger.info(TAG, 'aiPlay')
    if (this.message === $r('app.string.wait')) {
      return
    }
    chessNapi.deal((data: string) => {
      Logger.info(TAG, `aiPlay callback${data}`)
      let result = data.split(',')
      let succeed = parseInt(result[0], 10)
      let x = parseInt(result[1], 10)
      let y = parseInt(result[2], 10)
      Logger.info(TAG, `succeed:${succeed},x:${x},y:${y}`)
      this.chessboard[x][y] = AI_CHESS
      if (succeed === AI_WIN) {
        this.message = $r('app.string.ai_win')
        this.isPlay = false
        return
      }
      if (x > SIZE && y > SIZE) {
        this.message = $r('app.string.game_over')
        this.isPlay = false
        return
      }
      this.message = $r('app.string.ai_landed')
    })
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.MainAbility_label'))
          .fontColor(Color.White)
          .fontSize(28)
      }
      .width('100%')
      .height('8%')
      .constraintSize({ minHeight: 70 })
      .padding({ left: 10, right: 10 })
      .backgroundColor('#0D9FFB')

      Column() {
        if (this.isPlay) {
          Grid() {
            ForEach(this.chessboard, (xItem, x) => {
              ForEach(xItem, (yItem, y) => {
                GridItem() {
                  Image(this.getChessImg(yItem))
                    .width('80%').height('80%')
                    .onClick(() => {
                      if (!this.isPlay) {
                        prompt.showToast({ message: '请先点击开始游戏' })
                        return
                      }
                      if (this.chessboard[x][y] > 0) {
                        return
                      }
                      this.message = $r('app.string.wait')
                      this.chessboard[x][y] = USER_CHESS
                      Logger.info(TAG, `put: x=${x}, y=${y}`)
                      let succeed = chessNapi.put(x, y)
                      Logger.info(TAG, `put, succeed=${succeed}`)
                      if (succeed === USER_WIN) {
                        this.message = $r('app.string.you_win')
                        this.isPlay = false
                      } else {
                        this.aiPlay()
                      }
                    })
                }
              }, yItem => JSON.stringify(yItem))
            }, xItem => JSON.stringify(xItem))
          }
          .width('93%')
          .height('93%')
          .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
          .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
        }
      }
      .width('95%')
      .aspectRatio(1.0)
      .backgroundImage($r('app.media.ic_bg'))
      .backgroundImageSize({ width: '100%', height: '100%' })
      .constraintSize({ maxWidth: 670 })

      if (!this.isPlay) {
        Button({ type: ButtonType.Capsule }) {
          Text($r('app.string.game_start'))
            .fontSize(25)
            .fontColor(Color.White)
        }
        .width('80%')
        .height(50)
        .margin(10)
        .onClick(() => {
          if (this.isPlay) {
            prompt.showToast({ message: '游戏已开始' })
            return
          }
          this.isPlay = true
          this.aiPlay()
        })
      }

      Text(this.message)
        .fontSize(25)
        .fontColor(Color.Black)
        .margin(10)
    }
    .width('100%')
    .height('100%')
  }
}