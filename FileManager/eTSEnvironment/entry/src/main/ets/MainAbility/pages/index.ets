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

import { DataModel } from '../model/dataModel'
import { TitleBar } from '../common/titleBar'
import featureAbility from '@ohos.ability.featureAbility'

const TAG: string = '[Environment.Index]'

@Entry
@Component
struct Index {
  @State userFreeBytes: number = 0
  @State userTotalBytes: number = 0
  @State storageFreeBytes: number = 0
  @State storageTotalBytes: number = 0
  @State userDataDir: string = 'user'
  @State storageDataDir: string = 'storage'
  private dataModel: DataModel = new DataModel()
  private controller: TabsController = new TabsController()

  aboutToAppear() {
    this.getStorageData()
    this.getUserData()
  }

  getStorageData() {
    this.dataModel.getStorageDataDir().then((path) => {
      this.storageDataDir = path
      console.info(`${TAG} [data] getStorageDataDir storageDataDir= ${this.storageDataDir}`)
    })

    featureAbility.getContext().getFilesDir((err, path) => {
      console.info(`${TAG} [data] getFilesDir,path= ${path}`)

      this.dataModel.getFreeBytes(path).then((bytes) => {
        this.storageFreeBytes = bytes
        console.info(`${TAG} [data] storageFreeBytes= ${this.storageFreeBytes}`)
      })

      this.dataModel.getTotalBytes(path).then((bytes) => {
        this.storageTotalBytes = bytes
        console.info(`${TAG} [data] storageTotalBytes= ${this.storageTotalBytes}`)
      })
    })
  }

  getUserData() {
    this.dataModel.getUserDataDir().then((path) => {
      this.userDataDir = path
      console.info(`${TAG} getUserDataDir userDataDir= ${this.userDataDir}`)
    })

    this.dataModel.getFreeBytes('/storage/media/').then((bytes) => {
      this.userFreeBytes = bytes
      console.info(`${TAG} userFreeBytes= ${this.userFreeBytes}`)
    })

    this.dataModel.getTotalBytes('/storage/media/').then((bytes) => {
      this.userTotalBytes = bytes
      console.info(`${TAG} userTotalBytes= ${this.userTotalBytes}`)
    })
  }

  getPercentage(num:number, total:number) {
    if (num == 0 || total == 0) {
      return 0
    }
    return Number((num / total).toFixed(4)) * 100
  }

  @Builder dataView(dataDir:string, freeBytes:number, totalBytes:number, color:string) {
    Scroll() {
      Column() {
        Text(dataDir)
          .fontSize(20)
          .margin({ top: 20, bottom: 20 })

        Stack({ alignContent: Alignment.Center }) {
          DataPanel({
            max: 100,
            type: DataPanelType.Circle,
            values: [totalBytes - freeBytes, freeBytes]
          })
            .width(200)
            .height(320)
          Text(`${this.getPercentage((totalBytes - freeBytes), totalBytes)}%`)
            .fontSize(25)
            .margin({ bottom: 20 })
          Text($r('app.string.used'))
            .fontSize(15)
            .margin({ top: 20 })
        }

        Row() {
          Text($r('app.string.free'))
            .fontSize(20)
          Text(` ${freeBytes} B`)
            .fontSize(22)
        }
        .margin({ top: 20 })

        Row() {
          Text($r('app.string.total'))
            .fontSize(20)
          Text(` ${totalBytes} B`)
            .fontSize(22)
        }
        .margin({ top: 20, bottom: 60 })

      }
      .width('100%')
      .backgroundColor(color)
      .border({ width: 2, radius: 15, color: Color.White })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar()
      Column() {
        Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
          TabContent() {
            this.dataView(this.storageDataDir, this.storageFreeBytes, this.storageTotalBytes, '#6bc1bdbf')
          }.tabBar($r('app.string.storage_data'))

          TabContent() {
            this.dataView(this.userDataDir, this.userFreeBytes, this.userTotalBytes, '#6bc1bdb0')
          }.tabBar($r('app.string.user_data'))
        }
        .width('90%')
        .height('90%')
        .vertical(false)
        .scrollable(true)
        .barWidth(330)
        .barHeight(80)
        .barMode(BarMode.Fixed)
        .animationDuration(200)
      }
    }
  }
}