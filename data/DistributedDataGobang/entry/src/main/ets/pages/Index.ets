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
import logger from '../Model/Logger'
import { TitleBar } from '../Common/TitleBar'
import { KvStoreModel } from '../Model/KvStoreModel'
import { RemoteDeviceModel } from '../Model/RemoteDeviceModel'
import { DistributedDataModel } from '../Model/DistributedDataModel'

let kvStoreModel: KvStoreModel = new KvStoreModel()
const DEVICE_A: string = 'deviceA'
const DEVICE_B: string = 'deviceB'
const EXIT: string = 'exit'
const TAG: string = 'Index'
const CHESS_COLOR: Array<string> = ['black', 'white']
const WITH: number = 720
const HEIGHT: number = 1280
const SIZE: number = 16
const CHECK_MODE: [number, number][] = [
  [1, 0],
  [0, 1],
  [1, 1],
  [1, -1]
]

@Entry
@Component
struct Index {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State width: number = WITH
  @State height: number = HEIGHT
  @State dpiBi: number = vp2px(this.width) / this.width
  @State chessSize: number = this.width / this.dpiBi / SIZE
  private chessMapArr: Array<Array<string>> = []
  @State isDistributed: boolean = false
  @State dialogShow: boolean = false
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()
  @State @Watch('dataChange') distributedData: DistributedDataModel = new DistributedDataModel(false)
  @State deviceFlag: string = 'A'
  @State isFall: boolean = false

  dataChange() {
    if (this.deviceFlag !== 'A') {
      return
    }

    let gameDataA = {
      isOver: this.distributedData.isOver,
      step: this.distributedData.step,
      chessMapArr: this.distributedData.chessMapArr,
      chessX: this.distributedData.chessX,
      chessY: this.distributedData.chessY,
      clickCount: this.distributedData.clickCount,
      fallLocation: this.distributedData.fallLocation
    }
    logger.info(TAG, `dataChange,${JSON.stringify(gameDataA)}`)
    kvStoreModel.put(DEVICE_A, JSON.stringify(gameDataA))
    logger.info(TAG, `[AAA] put ${this.deviceFlag}`)
  }

  async aboutToAppear() {
    logger.info(TAG, `enter aboutToAppear`)
    await globalThis.abilityContext.requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'])
    this.distributedData.init()
    if (globalThis.deviceFlag) {
      this.isDistributed = true
    }
    logger.info(TAG, `[GameGobang] globalThis.deviceFlag = ${JSON.stringify(globalThis.deviceFlag)}, isDistributed = ${this.isDistributed}`)
    if (globalThis.deviceFlag === 'B') {
      this.deviceFlag = 'B'
    }
    if (this.deviceFlag === 'B') {
      logger.info(TAG, `enter this.deviceFlag === 'B'`)
      kvStoreModel.setOnMessageReceivedListener(DEVICE_A, (value) => {
        let gameDataA = JSON.parse(value)
        this.distributedData.isOver = gameDataA.isOver
        this.distributedData.step = gameDataA.step
        this.distributedData.clickCount = gameDataA.clickCount
        this.distributedData.chessMapArr = gameDataA.chessMapArr
        this.distributedData.fallGather = gameDataA.fallGather
        this.distributedData.chessX = gameDataA.chessX
        this.distributedData.chessY = gameDataA.chessY
        this.distributedData.fallLocation = gameDataA.fallLocation
      })
    } else if (this.deviceFlag === 'A') {
      logger.info(TAG, `enter this.deviceFlag === 'A'`)
      kvStoreModel.setOnMessageReceivedListener(DEVICE_B, (value) => {
        let gameDataB = JSON.parse(value)
        this.fallChressInner(gameDataB.x, gameDataB.y)
      })
    }
  }

  startAbilityCallBack = (key: string) => {
    if (DEVICE_A === key) {
      kvStoreModel.put(DEVICE_A, this.distributedData)
    }
    if (EXIT === key) {
      kvStoreModel.put(DEVICE_A, EXIT)
    }
  }

  private cleanChessBoard() {
    this.context.fillStyle = 'RGB(222,184,135)'
    this.context.fillRect(0, 0, this.width / this.dpiBi, this.width / this.dpiBi)
  }

  private drawChess(x, y, color) {
    this.context.beginPath()
    this.context.arc(x, y, this.chessSize / 2 * 0.8, 0, Math.PI * 2, false)
    this.context.closePath()
    this.context.fillStyle = color
    this.context.fill()
  }

  private drawChessBoard() {
    for (let i = 0; i < 15; i++) {
      this.context.beginPath()
      this.context.strokeStyle = '#f2eada'
      this.context.lineWidth = 3
      this.context.beginPath()
      this.context.moveTo((i + 1) * (this.chessSize), (this.chessSize))
      this.context.lineTo((i + 1) * (this.chessSize), (this.chessSize * 15))
      this.context.closePath()
      this.context.stroke()
      this.context.beginPath()
      this.context.moveTo(this.chessSize, (i + 1) * this.chessSize)
      this.context.lineTo((this.chessSize * 15), (i + 1) * this.chessSize)
      this.context.closePath()
      this.context.stroke()
      this.context.shadowBlur = 3
      this.context.shadowColor = '#afb4db'
      this.context.beginPath()
      this.context.arc(this.width / this.dpiBi / 2, this.width / this.dpiBi / 2, 3, 0, Math.PI * 2, false)
      this.context.arc(this.width / this.dpiBi / 4, this.width / this.dpiBi / 4, 3, 0, Math.PI * 2, false)
      this.context.arc(this.width / this.dpiBi / 4 * 3, this.width / this.dpiBi / 4 * 3, 3, 0, Math.PI * 2, false)
      this.context.closePath()
      this.context.fillStyle = 'black'
      this.context.fill()
      this.context.beginPath()
      this.context.arc(this.width / this.dpiBi / 4, this.width / this.dpiBi / 4 * 3, 3, 0, Math.PI * 2, false)
      this.context.arc(this.width / this.dpiBi / 4 * 3, this.width / this.dpiBi / 4, 3, 0, Math.PI * 2, false)
      this.context.closePath()
      this.context.fillStyle = 'black'
      this.context.fill()
      this.context.closePath()
    }
  }

  private fallChressInner(x: number, y: number) {
    logger.info(TAG, `enter fallChressInner`)
    logger.info(TAG, `this.deviceFlag = ${this.deviceFlag}`)
    if (x < 0 || x > 14 || y < 0 || y > 14) {
      return
    }
    if (this.distributedData.chessMapArr[x][y] === '') {
      if (this.deviceFlag === 'B') {
        let gameDateB = {
          x: x,
          y: y,
        }
        kvStoreModel.put(DEVICE_B, JSON.stringify(gameDateB))
        logger.info(TAG, `kvStoreModel.put, deviceB = ${JSON.stringify(gameDateB)}`)
      } else {
        this.distributedData.fallChess(x, y, CHESS_COLOR[this.distributedData.step % 2])
        this.distributedData.step++
        logger.info(TAG, `[AAA] fall chess success`)
      }
    }
  }

  private fallChress(event) {
    if (this.distributedData.isOver) {
      message:`共计${Math.ceil(this.distributedData.step / 2)}回合,${CHESS_COLOR[this.distributedData.step % 2] === 'black' ? '白子' : '黑子'}胜！`
      return
    }
    let clickX = event.x
    let clickY = event.y
    let dx = Math.floor((clickX + this.chessSize / 2) / this.chessSize) * this.chessSize
    let dy = Math.floor((clickY + this.chessSize / 2) / this.chessSize) * this.chessSize
    if (this.distributedData.fallLocation.toString() === [dx, dy].toString()) {
      this.isFall = true
    }
    this.distributedData.fallLocation[0] = dx
    this.distributedData.fallLocation[1] = dy
    logger.info(TAG, `fallChress,${this.distributedData.fallLocation}`)
    if (!this.isFall) {
      return
    }
    logger.info(TAG, `[AAA] fall ${clickX},${clickY}`)
    let x = dx / this.chessSize - 1
    let y = dy / this.chessSize - 1
    this.fallChressInner(x, y)
    this.isFall = false
  }

  private drawAll() {
    if (this.distributedData.clickCount > 0) {
      if (this.deviceFlag === 'A' && this.distributedData.step % 2 === 0) {
        this.confirmFall()
      } else if (this.deviceFlag === 'B' && this.distributedData.step % 2 !== 0) {
        this.confirmFall()
      }
    }
    for (let i = 0; i < 15; i++) {
      for (let j = 0; j < 15; j++) {
        if (this.distributedData.chessMapArr[i][j] !== '') {
          let dx = (i + 1) * this.chessSize
          let dy = (j + 1) * this.chessSize
          let color = this.distributedData.chessMapArr[i][j]
          this.drawChess(dx, dy, color)
        }
      }
    }
  }

  private checkWin(x, y, color, mode) {
    var count = 1
    for (let i = 1; i < 5; i++) {
      if (this.distributedData.chessMapArr[x + i * mode[0]]) {
        if (this.distributedData.chessMapArr[x + i * mode[0]][y + i * mode[1]] === color && color !== '') {
          count++
        } else {
          break
        }
      }
    }
    for (let j = 1; j < 5; j++) {
      if (this.distributedData.chessMapArr[x - j * mode[0]]) {
        if (this.distributedData.chessMapArr[x - j * mode[0]][y - j * mode[1]] === color && color !== '') {
          count++
        } else {
          break
        }
      }
    }
    if (count >= 5) {
      setTimeout(() => {
        AlertDialog.show({
          message: `共计${Math.ceil(this.distributedData.step / 2)}回合,${CHESS_COLOR[this.distributedData.step % 2] === 'black' ? '白子' : '黑子'}胜！`
        })
      }, 100)
      this.distributedData.isOver = true
    }
  }

  private fallFlag() {
    if (this.distributedData.step !== 0) {
      this.context.beginPath()
      this.context.arc((this.distributedData.chessX + 1) * this.chessSize, (this.distributedData.chessY + 1) * this.chessSize, this.chessSize / 2 * 0.8, 0, Math.PI * 2, false)
      this.context.shadowColor = '#FFFF00'
      this.context.shadowBlur = 20
      this.context.closePath()
      this.context.fillStyle = CHESS_COLOR[(this.distributedData.step + 1) % 2]
      this.context.fill()
    }
  }

  private confirmFall() {
    logger.info(TAG, `[BBB],${this.distributedData.fallLocation}`)
    this.context.beginPath()
    this.context.arc(this.distributedData.fallLocation[0], this.distributedData.fallLocation[1], this.chessSize / 2 * 0.8, 0, Math.PI * 2, false)
    this.context.stroke()
    this.context.closePath()
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      TitleBar({
        startAbilityCallBack: this.startAbilityCallBack,
        remoteDeviceModel: this.remoteDeviceModel,
        isDistributed: $isDistributed,
        dialogShow: $dialogShow,
        deviceFlag: this.deviceFlag
      })

      Text(`${this.deviceFlag}-${this.distributedData.step}-${this.distributedData.clickCount}`)

      Column() {
        Canvas(this.context)
          .width(this.width / this.dpiBi)
          .height(this.width / this.dpiBi)
          .backgroundColor('RGB(222,184,135)')
          .onReady(() => {
            this.cleanChessBoard()
            this.drawChessBoard()
            this.drawAll()
            if (this.distributedData.isOver === false) {
              for (var i = 0; i < 4; i++) {
                logger.info(TAG, `[111] check ${this.distributedData.chessX},${this.distributedData.chessY}`)
                let x = this.distributedData.chessX
                let y = this.distributedData.chessY
                if (x < 0 || x > 14 || y < 0 || y > 14) {
                  continue
                }
                let color = this.distributedData.chessMapArr[x][y]
                logger.info(TAG, `[111] check ${x},${y},${color}`)
                this.checkWin(x, y, color, CHECK_MODE[i])
              }
            }
            this.fallFlag()
          })
          .border({ width: 1, color: 'red' })
      }
      .margin({ bottom: 10 })
      .onClick((event) => {
        if (this.deviceFlag === 'A' && this.distributedData.step % 2 === 0) {
          this.fallChress(event)
        } else if (this.deviceFlag === 'B' && this.distributedData.step % 2 !== 0) {
          this.fallChress(event)
        }
        this.distributedData.clickCount++
      })

      Row() {
        if (this.deviceFlag === 'A') {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Button($r('app.string.restart'), { stateEffect: true })
              .backgroundColor('RGB(210,105,30)')
              .width(this.chessSize * 3)
              .fontSize(20 / this.dpiBi)
              .margin({ right: 20 })
              .onClick(() => {
                this.distributedData.init()
                this.distributedData.isOver = false
                this.distributedData.step = 0
                this.distributedData.clickCount = 0
                this.distributedData.fallLocation = []
              })
            Button($r('app.string.repentance_chess'), { stateEffect: true })
              .backgroundColor('RGB(210,105,30)')
              .width(this.chessSize * 3)
              .fontSize(20 / this.dpiBi)
              .onClick(() => {
                this.distributedData.chessMapArr[this.distributedData.fallGather[0][0]][this.distributedData.fallGather[0][1]] = ''
                this.distributedData.fallGather.shift()
                this.distributedData.step--
              })
          }
        }
      }.width('50%')
    }
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize({ width: '100%', height: '100%' })
    .width('100%')
    .height('100%')
  }
}