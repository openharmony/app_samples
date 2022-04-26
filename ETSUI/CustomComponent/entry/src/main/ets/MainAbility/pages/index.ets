/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import { ReleaseData, dataInit, addStorage, getDataFromStorage, getStorageList } from '../model/releaseData'
import { TopView } from '../common/topView'
import { NumberList } from '../common/numberList'
import { TabContentView } from '../common/tabContent'
import { menuTitle } from '../util/utils'
import Logger from '../model/Logger'

const TAG = '[Component.Index]'

@Entry
@Component
struct Index {
  @State resMenu: string[] = []
  @State colMenu: string[] = []
  @State broMenu: string[] = []
  @State browseList: Array<ReleaseData> = []
  @State releaseList: Array<ReleaseData> = []
  @State reservationList: Array<ReleaseData> = []
  @State collectionList: Array<ReleaseData> = []

  aboutToAppear() {
    getDataFromStorage(() => {
      this.releaseList = getStorageList('release')
      this.browseList = getStorageList('browse')
      this.broMenu = menuTitle(this.browseList)
      this.checkisEmptyOfRelease()
      Logger.info(TAG, `this.releaseList = +${JSON.stringify(this.releaseList)}\n releaseList=+${this.releaseList.length.toString()}`)
      this.reservationInit()
      this.collectionInit()
    })
  }

  reservationInit() {
    for (let i in this.releaseList) {
      if (this.releaseList[i].isRes === true) {
        this.reservationList.push(this.releaseList[i])
      }
    }
    Logger.info(TAG, `this.reservationList = ${JSON.stringify(this.reservationList)}`)
    this.resMenu = menuTitle(this.reservationList)
    Logger.info(TAG, `this.resmenu = ${JSON.stringify(this.resMenu)}`)
  }

  collectionInit() {
    for (let i in this.releaseList) {
      if (this.releaseList[i].isCollect === true) {
        this.collectionList.push(this.releaseList[i])
      }
    }
    Logger.info(TAG, `this.collectionList = ${JSON.stringify(this.collectionList)}`)
    this.colMenu = menuTitle(this.collectionList)
    Logger.info(TAG, `this.colmenu = ${JSON.stringify(this.colMenu)}`)
  }

  checkisEmptyOfRelease() {
    if (this.releaseList.length == 0) {
      this.releaseList = dataInit()
      for (let i in this.releaseList) {
        addStorage(this.releaseList[i], 'release')
      }
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Text($r('app.string.title'))
        .width('100%')
        .height(50)
        .fontSize(25)
        .padding({ left: 10 })
        .fontColor(Color.White)
        .backgroundColor('#0D9FFB')
        .fontWeight(FontWeight.Bold)

      Column() {
        List({ space: 10, initialIndex: 0 }) {
          ListItem() {
            TopView({
              releaseList: $releaseList,
              reservationList: $reservationList,
              collectionList: $collectionList,
              resMenu: $resMenu,
              colMenu: $colMenu,
              broMenu: $broMenu
            })
          }
          .width('100%')
          .height(180)

          ListItem() {
            NumberList({ resMenu: $resMenu, colMenu: $colMenu, broMenu: $broMenu })
          }
          .width('100%')
          .height(50)

          ListItem() {
            TabContentView({
              releaseList: $releaseList,
              reservationList: $reservationList,
              collectionList: $collectionList,
              resMenu: $resMenu,
              colMenu: $colMenu,
              broMenu: $broMenu
            })
          }
          .width('100%')
          .height('100%')
          .sticky(Sticky.Normal)
        }
        .width('100%')
        .editMode(false)
      }
      .width('90%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}