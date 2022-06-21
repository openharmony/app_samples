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
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import GameRules from "../model/GameRules"
import ImageModel from "../model/ImageModel"
import ImagePicker from '../common/ImagePicker'
import Logger from '../model/Logger'
import PictureItem from '../model/PictureItem'

enum gameStatus {
  running = 1,
  over = 0
}

const PERMISSIONS: Array<string> = ['ohos.permission.READ_MEDIA']
const IMAGE_SIZE: number = px2vp(640)
const GAME_TIME: number = 300 // 游戏时长
const TAG: string = 'Index'

@Entry
@Component
struct Index {
  private ImageModel: ImageModel = new ImageModel()
  private game: GameRules = new GameRules()
  private timer: number = -1
  private isRefresh: boolean = false
  @State numArray: PictureItem[] = []
  @State imgDatas: Array<mediaLibrary.FileAsset> = []
  @State @Watch("onTimeOver") gameTime: number = GAME_TIME
  @State @Watch("onImageChange") index: number = 0

  async aboutToAppear() {
    await globalThis.abilityContext.requestPermissionsFromUser(PERMISSIONS)
    this.imgDatas = await this.ImageModel.getAllImg()
    Logger.info(TAG, `images = ${this.imgDatas.length}`)
    this.numArray = await this.ImageModel.splitPic(this.index)
  }

  onTimeOver() {
    if (this.gameTime == 0) {
      this.game.gameStatus = 0
      AlertDialog.show({ message: 'TimeOver' })
      clearInterval(this.timer)
    }
  }

  async onImageChange() {
    this.dialogController.close()
    this.numArray = await this.ImageModel.splitPic(this.index)
    this.init()
  }

  init() {
    this.gameTime = GAME_TIME
    this.game.gameStatus = 0
    clearInterval(this.timer)
  }

  gameOver() {
    let count = 0
    for (let i = 0;i < 7; i++) {
      if (this.numArray[i].index == i) {
        count++
      } else {
        count = 0
        break
      }
      if (count == 7) {
        AlertDialog.show({ message: $r('app.string.congratulations') })
        this.game.gameStatus = gameStatus.over
        clearInterval(this.timer)
        this.gameTime = GAME_TIME
      }
    }
  }

  start() {
    this.init()
    this.timer = setInterval(() => {
      this.gameTime--
    }, 1000)
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: ImagePicker({
      imageDatas: this.imgDatas,
      index: $index
    }),
    autoCancel: true,
    gridCount: 12
  })

  build() {
    Column() {
      if (this.imgDatas.length > 0) {
        Image(this.imgDatas[this.index].uri)
          .width(IMAGE_SIZE)
          .height(vp2px(210))
          .margin({ top: 5 })
          .objectFit(ImageFit.Cover)
          .onClick(async () => {
            this.imgDatas = await this.ImageModel.getAllImg()
            this.dialogController.open()
          })
      }

      Row() {
        Text(`Time:0${Math.floor(this.gameTime / 60)}:${this.gameTime % 60 < 10 ? '0' + this.gameTime % 60 : this.gameTime % 60}`)
          .margin({ top: 5, bottom: 5 })
      }

      Grid() {
        ForEach(this.numArray, (item, index) => {
          GridItem() {
            Image(item.pixelMap)
              .width('99%')
              .height(vp2px(65))
          }
          .backgroundColor(item.pixelMap === undefined ? "#f5f5f5" : "#ffdead")
          .onClick(() => {
            if (this.isRefresh) {
              return
            }
            if (this.game.gameStatus === gameStatus.running) {
              this.isRefresh = true
              this.numArray = this.game.gameInit(index, this.numArray)
              this.gameOver()
              this.isRefresh = false
            }
          })
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(2)
      .rowsGap(2)
      .width(IMAGE_SIZE)
      .height(vp2px(200))

      Button($r('app.string.start'), { type: ButtonType.Capsule, stateEffect: true })
        .height(50)
        .width('100%')
        .fontSize(18)
        .margin({ top: 5 })
        .backgroundColor(this.game.gameStatus === gameStatus.over ? '#0D9FFB' : '#E5E5E5')
        .enabled(this.game.gameStatus === gameStatus.over)
        .onClick(() => {
          this.start()
          this.numArray = this.game.gameBegin(this.numArray)
        })

      Button($r('app.string.restart'), { type: ButtonType.Capsule, stateEffect: true })
        .height(50)
        .width('100%')
        .fontSize(18)
        .margin({ top: 5 })
        .backgroundColor(this.game.gameStatus === gameStatus.running ? '#0D9FFB' : '#E5E5E5')
        .enabled(this.game.gameStatus === gameStatus.running)
        .onClick(() => {
          this.start()
          this.numArray = this.game.gameBegin(this.numArray)
        })
    }
    .width('100%')
    .height('100%')
    .padding({ left: '1%', right: '1%' })
  }
}