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

enum GameStatus {
  BEFORE = -1,
  RUNNING = 1,
  OVER = 0
}

import display from '@ohos.display'
import Logger from '../model/Logger'
import dataStorage from '@ohos.data.storage'
import  { GameRule }   from '../model/GameRule'
import featureAbility from '@ohos.ability.featureAbility'

const TAG = '[Game2048]'

@Entry
@Component
struct Game2048 {
  @State dataNumbers: number[] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  private gameRule: GameRule = new GameRule(this.dataNumbers)
  @State maxScore: number = 123456
  @State curScore: number = 0
  @State @Watch("onGameOver") gameStatus: number = GameStatus.BEFORE
  @State textColor: string[] = ['#f0fff0', '#eee3da', '#ede0c8', '#f2b179', '#f59563', '#f67c5f', '#f65e3b', '#edcf72', '#edcc61', '#9c0', '#33b5e5', '#09c', '#a6c', '#93c']
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ScorePannel({
      curScore: this.curScore,
      maxScore: this.maxScore,
      gameStart: this.gameStart.bind(this)
    }),
    autoCancel: false
  })
  @State screenSize: {
    x: number,
    y: number
  } = { x: px2vp(1080), y: px2vp(0) }

  //gameStatus listener
  onGameOver() {
    if (this.gameStatus === GameStatus.OVER) {
      this.curScore = this.gameRule.score
      this.dialogController.open()
    }
  }

  //restart game
  gameStart() {
    this.gameRule.init()
    this.dataNumbers = this.gameRule.dataNumbers
    this.gameStatus = GameStatus.RUNNING
    this.handleLocalData('put')
  }

  //dataView
  dataView() {
    this.dataNumbers = this.gameRule.dataNumbers
    this.gameStatus = this.gameRule.status
    this.curScore = this.gameRule.score
  }

  aboutToAppear() {
    display.getDefaultDisplay((err, data) => {
      if (data.height > data.width) {
        this.screenSize = { x: px2vp(data.width), y: px2vp(data.height) }
      } else {
        this.screenSize = { x: px2vp(750), y: px2vp(data.width) }
      }
      Logger.info(TAG, `宽 ${this.screenSize.x}`)
      Logger.info(TAG, `高 ${this.screenSize.y}`)
    })
    this.handleLocalData('has')
  }

  //handle local data
  handleLocalData(method: string) {
    let context = featureAbility.getContext()
    context.getFilesDir((err, path) => {
      let storage = dataStorage.getStorageSync(path + '/mystore')
      if (method === 'put') {
        storage.putSync('gameData', JSON.stringify(this.dataNumbers))
        let score: string = this.gameRule.score.toString()
        storage.putSync('score', score)
        storage.putSync('gameStatus', this.gameRule.status.toString())
        storage.flushSync()
      } else if (method === 'has') {
        if (storage.hasSync('gameData')) {
          this.gameRule.score = this.curScore = Number(storage.getSync('score', 'string'))
          this.gameStatus = this.gameRule.status = Number(storage.getSync('gameStatus', 'string'))
          this.dataNumbers = this.gameRule.dataNumbers = JSON.parse(storage.getSync('gameData', 'string').toString())
        }
      }
    })
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
          Image($r('app.media.logo2048'))
            .width(this.screenSize.x * 0.25)
            .height(this.screenSize.x * 0.25)

          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Text('Score')
              .fontSize('30px')
              .fontColor('#efe1d3')
              .fontWeight(FontWeight.Bolder)

            Text(`${this.gameRule.score}`)
              .fontSize('30px')
              .fontColor('#fcf8f5')
              .fontWeight(FontWeight.Bolder)
          }
          .backgroundColor('#bbada0')
          .width(this.screenSize.x * 0.25)
          .height(this.screenSize.x * 0.25)
          .borderRadius(15)

          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Text('Max')
              .fontSize('50px')
              .fontColor('#efe1d3')
              .fontWeight(FontWeight.Bolder)

            Text(`${this.maxScore}`)
              .fontSize('30px')
              .fontColor('#fcf8f5')
              .fontWeight(FontWeight.Bolder)
          }
          .backgroundColor('#bbada0')
          .width(this.screenSize.x * 0.25)
          .height(this.screenSize.x * 0.25)
          .borderRadius(15)
        }
        .margin({ bottom: 20 })
        .width(this.screenSize.x)

        Grid() {
          ForEach(this.dataNumbers, (item) => {
            GridItem() {
              Text(`${item === 0 ? '' : item}`)
                .fontSize('85px')
                .fontColor(item <= 4 ? '#000' : '#fcf8f5')
                .fontWeight(FontWeight.Bolder)
                .backgroundColor('#f0fff0')
                .width('100%')
                .height('100%')
                .textAlign(TextAlign.Center)
                .borderRadius(10)
                .backgroundColor(this.textColor[(Math.log(item) / Math.log(2))])
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr 1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .width(this.screenSize.x)
        .padding(10)
        .backgroundColor('rgba(80,69,46,0.26)')
        .height(this.screenSize.x)
        .borderRadius(10)
        .gesture(GestureGroup(GestureMode.Exclusive,
        PanGesture({ direction: PanDirection.Left }).onActionEnd(() => {
          this.gameRule.status === 1 && this.gameRule.move('left')
          this.dataView()
          this.handleLocalData('put')
        }),
        PanGesture({ direction: PanDirection.Right }).onActionEnd(() => {
          this.gameRule.status === 1 && this.gameRule.move('right')
          this.dataView()
          this.handleLocalData('put')
        }),
        PanGesture({ direction: PanDirection.Up }).onActionEnd(() => {
          this.gameRule.status === 1 && this.gameRule.move('up')
          this.dataView()
          this.handleLocalData('put')
        }),
        PanGesture({ direction: PanDirection.Down }).onActionEnd(() => {
          this.gameRule.status === 1 && this.gameRule.move('down')
          this.dataView()
          this.handleLocalData('put')
        })
        ))

        Button('Start', { type: ButtonType.Normal })
          .borderRadius(5)
          .margin({ top: 50 })
          .width(200)
          .onClick(() => {
            this.gameStart()
          })
          .visibility(this.gameStatus !== -1 ? Visibility.Hidden : Visibility.Visible)
      }
      .height('100%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.gridBackground'))
    .backgroundImageSize(ImageSize.Cover)
  }
}

@CustomDialog
struct ScorePannel {
  controller: CustomDialogController
  gameStart: () => void
  curScore: number
  maxScore: number

  build() {
    Column() {
      Text('Game Over')
        .fontSize(30)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 10 })

      Text('Score')
        .fontColor('#C8A584')
        .fontSize(20)
        .margin({ top: 10 })

      Text(`${this.curScore}`)
        .fontColor('#5D5D5D')
        .fontSize(40)
        .margin({ top: 10 })

      Text(`maxScore:${this.maxScore}`)
        .fontSize(20)
        .width('90%')
        .borderRadius(20)
        .margin({ top: 10 })
        .height(40)
        .textAlign(TextAlign.Center)

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('Reset', { type: ButtonType.Normal })
          .borderRadius(5)
          .margin({ top: 10 })
          .width(200)
          .onClick(() => {
            this.gameStart()
            this.controller.close()
          })
      }
      .margin({ top: 10, bottom: 10 })
    }
    .backgroundColor('#f0f0f0')
    .borderRadius(25)
  }
}