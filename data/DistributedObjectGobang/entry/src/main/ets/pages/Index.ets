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

import prompt from '@ohos.prompt'
import deviceManager from '@ohos.distributedHardware.deviceManager'
import Logger from '../data/Logger'
import RemoteDeviceModel from '../data/RemoteDeviceModel'
import { objectModel } from '../data/DistributedDataModel'
import { distributedConst } from '../data/DistributedConst'
import { DeviceDialog } from '../component/DeviceDialog'

const TAG: string = 'Index'

function initArray(size, value) {
  return Array.from({ length: size }, () => Array.from({ length: size }, () => value))
}

@Entry
@Component
struct Index {
  private devices: Array<deviceManager.DeviceInfo> = []
  private customDialogController: CustomDialogController | null = null
  private timerId: number = -1
  @State island: boolean = true
  @State chessBoard: Array<Array<number>> = initArray(distributedConst.SIZE, 0)
  @State @Watch('isPlayChange') isPlay: boolean = false
  @State message: Resource = $r('app.string.game_not_start')
  @State whichChess: number = 0 // false时为用户落子(白方)，true时为自己落子(黑方)
  @State  seconds: number = distributedConst.COUNT_SECOND
  @State isOnline: boolean = false
  @State startGameText: string = ''
  @State gameStatusText: string = ''

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(50)
          .height(30)
          .margin({ left: 10 })
          .onClick(() => {
            objectModel.distributedObject.setSessionId()
            globalThis.abilityContext.terminateSelf()
          })
        Text($r('app.string.distribute_object'))
          .fontColor(Color.White)
          .fontSize(28)
          .margin({ left: 20 })
        Blank()
        Image($r('app.media.ic_hop_normal'))
          .width(50).height('100%')
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.getDevices()
            this.customDialogController = new CustomDialogController({
              builder: DeviceDialog({
                devices: this.devices,
              }),
              autoCancel: true
            })
            this.customDialogController.open()
          })
      }
      .width('100%')
      .height('8%')
      .constraintSize({ minHeight: 70 })
      .padding({ left: 10, right: 10 })
      .backgroundColor('#0D9FFB')

      Row() {
        Text($r('app.string.status'))
          .fontSize(30)
        Image(this.isOnline ? $r('app.media.green') : $r('app.media.red'))
          .margin({ left: 10 })
          .size({ width: 30, height: 30 })
          .objectFit(ImageFit.Contain)
      }
      .width('100%')
      .padding(10)

      Text($r('app.string.welcome'))
        .fontSize(25)
        .fontColor('#F10606')
        .margin({ top: 5 })
      Column() {
        Column() {
          if (this.isPlay) {
            Grid() {
              ForEach(this.chessBoard, (xItem, x) => {
                ForEach(xItem, (yItem, y) => {
                  GridItem() {
                    Image(this.getChessImg(yItem))
                      .width('80%').height('80%')
                      .onClick(() => {
                        if (!this.isPlay) {
                          prompt.showToast({ message: this.startGameText })
                          return
                        }
                        if (this.chessBoard[x][y] > 0) {
                          return
                        }
                        if (x > distributedConst.SIZE && y > distributedConst.SIZE) {
                          this.message = $r('app.string.game_over')
                          objectModel.message = this.message
                          objectModel.distributedObject.message = this.message
                          this.isPlay = false
                          objectModel.isPlay = this.isPlay
                          objectModel.distributedObject.isPlay = this.isPlay
                          return
                        }
                        if (!this.island) {
                          return
                        }
                        this.chessBoard[x][y] = this.whichChess
                        objectModel.chessBoard = this.chessBoard
                        objectModel.distributedObject.chessBoard = this.chessBoard
                        this.island = false
                        objectModel.island = false
                        Logger.info(TAG, `black put: x=${x}, y=${y}`)
                        let succeed = this.judgeWhetherWin(x, y, this.whichChess)
                        if (succeed === this.whichChess) {
                          if (this.whichChess === distributedConst.USER_CHESS) {
                            this.message = $r('app.string.white_win')
                          }
                          if (this.whichChess === distributedConst.OWN_CHESS) {
                            this.message = $r('app.string.black_win')
                          }
                          objectModel.message = this.message
                          objectModel.distributedObject.message = this.message
                          this.isPlay = false
                          objectModel.isPlay = false
                          objectModel.distributedObject.isPlay = false
                          Logger.info(TAG, `win distributedDataModel = ${JSON.stringify(objectModel)}`)
                        } else {
                          if (this.whichChess === distributedConst.USER_CHESS) {
                            this.message = $r('app.string.white_landed')
                          }
                          if (this.whichChess === distributedConst.OWN_CHESS) {
                            this.message = $r('app.string.black_landed')
                          }
                          objectModel.whichChess = this.whichChess
                          objectModel.message = this.message
                          objectModel.distributedObject.message = this.message
                          objectModel.distributedObject.whichChess = this.whichChess
                          Logger.info(TAG, `distributedDataModel = ${JSON.stringify(objectModel)}`)
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
        .width('100%')
        .aspectRatio(1.0)
        .backgroundImage($r('app.media.ic_bg'))
        .backgroundImageSize({ width: '100%', height: '100%' })
        .constraintSize({ maxWidth: 670 })
      }
      .width('100%')
      .height('53%')
      .borderWidth(1)
      .borderStyle(BorderStyle.Solid)
      .backgroundColor('#F4B387')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 10 })

      if (!this.isPlay) {
        Button({ type: ButtonType.Capsule }) {
          Text($r('app.string.game_start'))
            .fontSize(25)
            .fontColor(Color.White)
        }
        .width('80%')
        .height(50)
        .margin(10)
        .onClick(async () => {
          if (this.isPlay) {
            prompt.showToast({ message: this.gameStatusText })
            return
          }
          this.isPlay = true
          this.message = $r('app.string.game_start_status')
          this.whichChess = distributedConst.OWN_CHESS
          objectModel.whichChess = this.whichChess
          objectModel.isPlay = this.isPlay
          objectModel.message = this.message
          objectModel.distributedObject.whichChess = this.whichChess
          objectModel.distributedObject.message = this.message
          objectModel.distributedObject.isPlay = this.isPlay
          Logger.info(TAG, `start distributedDataModel = ${JSON.stringify(objectModel)}`)
          if (this.whichChess === distributedConst.OWN_CHESS) {
            this.countTime()
          }
        })
      }

      Text(this.message)
        .fontSize(25)
        .fontColor(Color.Black)
        .margin({ top: 10 })

      Text(this.seconds.toString())
        .fontSize(25)
        .fontColor('#21B816')
        .margin({ top: 10 })

      Text($r('app.string.notice'))
        .fontSize(25)
        .fontColor(Color.Red)
        .margin(20)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize({ width: '100%', height: '100%' })
  }

  /**
   * isPlay发生改变时触发
   */
  async isPlayChange() {
    Logger.info(TAG, `isPlayChange,isPlay:${this.isPlay}, message:${JSON.stringify(this.message)}`)
    if (!this.isPlay) {
      this.seconds = distributedConst.COUNT_SECOND
      clearInterval(this.timerId)
      AlertDialog.show({
        message: this.message,
        primaryButton: {
          value: $r('app.string.sure'),
          action: async () => {
            this.chessBoard = initArray(distributedConst.SIZE, 0)
            objectModel.distributedObject.chessBoard = this.chessBoard
            objectModel.chessBoard = this.chessBoard
            objectModel.whichChess = 0
            this.whichChess = 0
          }
        }
      })
    }
  }

  /**
   * 显示的棋子
   *
   * @param item
   */
  getChessImg(item: number) {
    if (item === distributedConst.USER_CHESS) {
      return $r('app.media.ic_white')
    }
    if (item === distributedConst.OWN_CHESS) {
      return $r('app.media.ic_black')
    }
    return undefined
  }

  /**
   * 分布式对象数据发生改变时的回调
   */
  changeCallback = async () => {
    Logger.info(TAG, `enter changeCallback = ${JSON.stringify(objectModel.distributedObject)}`)
    this.island = true
    objectModel.island = true
    this.message = objectModel.distributedObject.message
    objectModel.isPlay = objectModel.distributedObject.isPlay
    this.isPlay = objectModel.distributedObject.isPlay
    objectModel.whichChess = this.whichChess
    this.chessBoard = objectModel.distributedObject.chessBoard
    objectModel.whichChess = objectModel.distributedObject.whichChess
    objectModel.message = objectModel.distributedObject.message
    this.whichChess = objectModel.whichChess === distributedConst.OWN_CHESS ? distributedConst.USER_CHESS : distributedConst.OWN_CHESS
    objectModel.chessBoard = this.chessBoard
    Logger.info(TAG, `call back distributedDataModel = ${JSON.stringify(objectModel)}`)
    let tmp = this.chessBoard
    this.chessBoard = initArray(distributedConst.SIZE, 0)
    this.chessBoard = tmp
    this.countTime()
  }

  /**
   * 倒计时
   */
  countTime() {
    clearInterval(this.timerId)
    if (!this.isPlay) {
      return
    }
    this.seconds = distributedConst.COUNT_SECOND
    this.timerId = setInterval(async () => {
      Logger.info(TAG, `countdown seconds: ${this.seconds}`)
      if (this.seconds >= 0 && this.island === false) {
        clearInterval(this.timerId)
        this.seconds = distributedConst.COUNT_SECOND
      }
      if (this.seconds > 0 && this.island === true) {
        this.seconds = this.seconds - distributedConst.SECOND
        Logger.info(TAG, `seconds: ${this.seconds}`)
      }
      if (this.seconds === 0 && this.island === true) {
        this.seconds = distributedConst.COUNT_SECOND
        if (this.whichChess === distributedConst.USER_CHESS) {
          this.message = $r('app.string.black_win')

        }
        if (this.whichChess === distributedConst.OWN_CHESS) {
          this.message = $r('app.string.white_win')
        }

        objectModel.message = this.message
        objectModel.distributedObject.message = this.message
        this.isPlay = false
        objectModel.isPlay = this.isPlay
        objectModel.distributedObject.isPlay = this.isPlay
        clearInterval(this.timerId)
        Logger.info(TAG, `timeOut distributedDataModel = ${JSON.stringify(objectModel)}`)
      }
    }, 1000)
  }

  aboutToDisappear() {
    objectModel.distributedObject.setSessionId()
  }

  async convertResourceToString(resource: Resource) {
    Logger.info(TAG, `result = ${JSON.stringify(await globalThis.abilityContext.resourceManager.getString(resource))}`)
    return await globalThis.abilityContext.resourceManager.getString(resource)
  }

  async aboutToAppear() {
    Logger.info(TAG, `enter aboutToAppear`)
    this.startGameText = await this.convertResourceToString($r('app.string.please_start_game'))
    this.gameStatusText = await this.convertResourceToString($r('app.string.game_already_start'))
    objectModel.onChangeCallback(this.changeCallback)
    objectModel.onStatusCallback(async (sessionId, networkId, status) => {
      if (status === 'online') {
        this.isOnline = true
      } else {
        this.isOnline = false
      }
    })
  }

  /**
   * 获取水平方向连子数
   *
   * @param xValue x轴值
   * @param yValue y轴值
   * @param chessType 黑子/白子
   */
  getNumHorizontal(xValue: number, yValue: number, chessType: number) {
    let total = 0
    for (let a = 1; a < distributedConst.WIN_NUM; a++) {
      if (yValue - a < 0) {
        break
      }
      if (this.chessBoard[xValue][yValue - a] !== chessType) {
        break
      }
      total++
    }
    if (total >= distributedConst.WIN_NUM) {
      return total
    }
    for (let a = 1; a < distributedConst.WIN_NUM; a++) {
      if (yValue + a >= distributedConst.SIZE) {
        break
      }
      if (this.chessBoard[xValue][yValue + a] !== chessType) {
        break
      }
      total++
    }
    return total
  }

  /**
   * 获取垂直方向连子数
   *
   * @param xValue x轴值
   * @param yValue y轴值
   * @param chessType 黑子/白子
   */
  getNumVertical(xValue: number, yValue: number, chessType: number) {
    let total = 0
    for (let a = 1; a < distributedConst.WIN_NUM; a++) {
      if (xValue - a < 0) {
        break
      }
      if (this.chessBoard[xValue - a][yValue] !== chessType) {
        break
      }
      total++
    }
    if (total >= distributedConst.WIN_NUM) {
      return total
    }
    for (let a = 1; a < distributedConst.WIN_NUM; a++) {
      if (xValue + a >= distributedConst.SIZE) {
        break
      }
      if (this.chessBoard[xValue + a][yValue] !== chessType) {
        break
      }
      total++
    }
    return total
  }

  /**
   * 获取左斜线方向连子数
   *
   * @param xValue x轴值
   * @param yValue y轴值
   * @param chessType 黑子/白子
   */
  getNumLeftSlash(xValue: number, yValue: number, chessType: number) {
    let total = 0;
    for (let a = 1; a < distributedConst.WIN_NUM; a++) {
      if (xValue - a < 0 || yValue - a < 0) {
        break
      }
      if (this.chessBoard[xValue - a][yValue - a] !== chessType) {
        break
      }
      total++
    }
    if (total >= distributedConst.WIN_NUM) {
      return total
    }
    for (let a = 1; a < distributedConst.WIN_NUM; a++) {
      if (xValue + a >= distributedConst.SIZE || yValue + a >= distributedConst.SIZE) {
        break
      }
      if (this.chessBoard[xValue + a][yValue + a] !== chessType) {
        break
      }
      total++
    }
    return total
  }


  /**
   * 获取右斜线方向连子数
   *
   * @param xValue x轴值
   * @param yValue y轴值
   * @param chessType 黑子/白子
   */
  getNumRightSlash(xValue: number, yValue: number, chessType: number) {
    let total = 0;
    for (let a = 1; a < distributedConst.WIN_NUM; a++) {
      if (xValue - a < 0 || yValue + a >= distributedConst.SIZE) {
        break
      }
      if (this.chessBoard[xValue - a][yValue + a] !== chessType) {
        break
      }
      total++
    }
    if (total >= distributedConst.WIN_NUM) {
      return total
    }
    for (let a = 1; a < distributedConst.WIN_NUM; a++) {
      if (xValue + a >= distributedConst.SIZE || yValue - a < 0) {
        break
      }
      if (this.chessBoard[xValue + a][yValue - a] !== chessType) {
        break
      }
      total++
    }
    return total
  }

  /**
   * 判断是否获胜
   *
   * @param xValue x轴值
   * @param yValue y轴值
   * @param chessType 黑子/白子
   */
  judgeWhetherWin(xValue: number, yValue: number, chessType: number) {
    let numHorizontal = this.getNumHorizontal(xValue, yValue, chessType)
    if (numHorizontal >= distributedConst.WIN_NUM - 1) {
      return chessType
    }
    let numVertical = this.getNumVertical(xValue, yValue, chessType)
    if (numVertical >= distributedConst.WIN_NUM - 1) {
      return chessType
    }
    let numLeftSlash = this.getNumLeftSlash(xValue, yValue, chessType)
    if (numLeftSlash >= distributedConst.WIN_NUM - 1) {
      return chessType
    }
    let numRightSlash = this.getNumRightSlash(xValue, yValue, chessType)
    if (numRightSlash >= distributedConst.WIN_NUM - 1) {
      return chessType
    }
  }

  /**
   * 获取组网设备
   */
  getDevices() {
    RemoteDeviceModel.registerDeviceListCallback(() => {
      this.devices = []
      this.devices.push({
        deviceId: '0',
        deviceName: 'Local device',
        deviceType: 0,
        networkId: '0'
      })
      let deviceTemps = RemoteDeviceModel.discoverList.length > 0 ? RemoteDeviceModel.discoverList : RemoteDeviceModel.deviceList
      for (let i = 0; i < deviceTemps.length; i++) {
        Logger.info(TAG, `device[${i}]=${JSON.stringify(deviceTemps[i])}`)
        this.devices.push(deviceTemps[i])
      }
    })
  }
}