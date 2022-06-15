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
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
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
            this.drawBoard()
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
      let result = data.split(',')
      let succeed = parseInt(result[0], 10)
      let x = parseInt(result[1], 10)
      let y = parseInt(result[2], 10)
      Logger.info(TAG, `succeed:${succeed},x:${x},y:${y}`)
      this.chessboard[x][y] = AI_CHESS
      this.drawChess([x, y], AI_CHESS)
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

  drawBoard() {
    this.context.clearRect(0, 0, this.context.width, this.context.height)
    this.chessboard.forEach((xItem, x) => {
      xItem.forEach((yItem, y) => {
        this.drawChess([x, y], yItem)
      })
    })
  }

  drawChess(position: [x: number, y: number], chess: number) {
    this.context.lineWidth = 2
    if (chess === AI_CHESS) {
      this.context.fillStyle = '#000'
      this.context.strokeStyle = '#000'
    } else if (chess === USER_CHESS) {
      this.context.fillStyle = '#fdfdfd'
      this.context.strokeStyle = '#f0f0f0'
    } else {
      return
    }
    let gridSize = this.context.width / (SIZE + 1)
    let x = gridSize * (position[0] + 1)
    let y = gridSize * (position[1] + 1)
    Logger.info(TAG, `drawChess, x=${x},y=${y}`)
    this.context.save()
    this.context.beginPath()
    this.context.translate(x, y)
    this.context.arc(0, 0, px2vp(18), 0, 2 * Math.PI, false)
    this.context.fill()
    this.context.stroke()
    this.context.restore()
  }

  putChess = (event: ClickEvent) => {
    if (!this.isPlay) {
      prompt.showToast({ message: '请先点击开始游戏' })
      return
    }
    let gridSize = this.context.width / SIZE
    let dx = Math.floor(event.x / gridSize)
    let dy = Math.floor(event.y / gridSize)
    console.info(`putChess dx=${dx},dy=${dy}`)
    if (this.chessboard[dx][dy] > 0 || dy >= SIZE || dx >= SIZE) {
      return
    }
    this.chessboard[dx][dy] = USER_CHESS
    this.drawChess([dx, dy], USER_CHESS)
    this.message = $r('app.string.wait')
    let succeed = chessNapi.put(dx, dy)
    Logger.info(TAG, `put, succeed=${succeed}`)
    if (succeed === USER_WIN) {
      this.message = $r('app.string.you_win')
      this.isPlay = false
    } else {
      this.aiPlay()
    }
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

      Canvas(this.context)
        .width('95%')
        .aspectRatio(1)
        .backgroundImage($r('app.media.ic_bg'))
        .backgroundImageSize({ width: '100%', height: '100%' })
        .onReady(() => {
          this.drawBoard()
        })
        .onClick(this.putChess)

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