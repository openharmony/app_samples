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

import { ReleaseData, addStorage, modifyStorage,getStorageList } from '../model/releaseData'
import { getTextColor, checkExist, menuTitle } from '../util/utils'
import { nearRelease, hotRelease, classicRelease } from '../util/actionUtils'
import { VideoOperation } from '../common/videoOperation'
import Logger from '../model/Logger'

const TAG = '[Component.TabContentView]'

@Component
export struct TabContentView {
  @Link resMenu: string[]
  @Link colMenu: string[]
  @Link broMenu: string[]
  @Link reservationList: Array<ReleaseData>
  @Link collectionList: Array<ReleaseData>
  @Link @Watch('releaseChange') releaseList: Array<ReleaseData>
  @State topTabIndex: number = 0
  @State nearList: Array<ReleaseData> = []
  @State hotList: Array<ReleaseData> = []
  @State classicList: Array<ReleaseData> = []
  private controller = new TabsController
  private boxList: Array<ReleaseData> = []
  private topTabs: string[] = ['近日发布会', '热门发布会', '经典发布会']

  releaseChange() {
    this.ContentRefresh(this.releaseList)
  }

  ContentRefresh(release: Array<ReleaseData>) {
    switch (this.topTabIndex) {
      case 0:
        this.nearList = nearRelease(release)
        break
      case 1:
        this.hotList = hotRelease(release)
        break
      case 2:
        this.classicList = classicRelease(release)
        break
      default:
        break
    }
  }

  browseOnClick(data: ReleaseData) {
    let exist = checkExist(data.title, this.broMenu)
    if (!exist) {
      addStorage(data, 'browse')
      let browseList = getStorageList('browse')
      this.broMenu = menuTitle(browseList)
      Logger.info(TAG, `browseList= ${JSON.stringify(browseList)} \n browseList.length= ${browseList.length}`)
    }
  }

  reservationOnClick(data: ReleaseData) {
    let i = this.releaseList.indexOf(data)
    data.isRes = !data.isRes
    Logger.info(TAG, `i= ${JSON.stringify(i)}`)
    this.releaseList[i] = data
    data.resImg = data.isRes ? $r('app.media.focus') : $r('app.media.nofocus')
    modifyStorage(data, i, 'release')

    if (!data.isRes) {
      let j = this.reservationList.indexOf(data)
      this.reservationList.splice(j, 1)
    } else {
      this.reservationList.push(data)
    }
    this.resMenu = menuTitle(this.reservationList)
    Logger.info(TAG, `reservationList= ${JSON.stringify(this.reservationList)} \n reservationList.length= ${this.reservationList.length}`)
  }

  collectionOnClick(data: ReleaseData) {
    let i = this.releaseList.indexOf(data)
    data.isCollect = !data.isCollect
    this.releaseList[i] = data
    Logger.info(TAG, `releaseList= ${JSON.stringify(this.releaseList)} \n releaseList.length= ${this.releaseList.length}`)
    data.collectImg = data.isCollect ? $r('app.media.iscolloect') : $r('app.media.nocollect')
    modifyStorage(data, i, 'release')
    if (!data.isCollect) {
      let j = this.collectionList.indexOf(data)
      this.collectionList.splice(j, 1)
    } else {
      this.collectionList.push(data)
    }
    this.colMenu = menuTitle(this.collectionList)
    Logger.info(TAG, `collectionList= ${JSON.stringify(this.collectionList)} \n collectionList.length= ${this.collectionList.length}`)
  }

  @Builder imageTextOfRow(image: Resource, data: string) {
    Row() {
      Image(image).objectFit(ImageFit.Contain).width(25)
      Text(data).fontSize(15).margin({ left: 3 })
    }.layoutWeight(1).height('100%')
  }

  @Builder ContentView(releaseA: Array<ReleaseData>) {
    ForEach(releaseA, (item) => {
      Row() {
        Image($r('app.media.cover'))
          .width('30%').height(90)
          .objectFit(ImageFit.Fill)
          .onClick(() => {
            this.browseOnClick(item)
            this.ContentRefresh(releaseA)
          })
        Column() {
          Text(item.title).width('90%').fontSize(20).fontWeight(FontWeight.Bold)
          Text(item.date).width('90%').fontSize(15).margin({ top: 10 })
          VideoOperation({ info: item, collectClick: () => {
            this.collectionOnClick(item)
            this.ContentRefresh(releaseA)
          }, publishClick: () => {
            this.reservationOnClick(item)
            this.ContentRefresh(releaseA)
          } })
        }
        .width('70%')
      }
      .width('100%').height(90)
      .margin({ top: 15 })
    }, item => JSON.stringify(item))
  }

  build() {
    Column() {
      Row() {
        ForEach(this.topTabs, (item, index) => {
          Text(item)
            .fontSize(17)
            .layoutWeight(1)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .fontColor(getTextColor(index, this.topTabIndex))
            .onClick(() => {
              Logger.info(TAG, `topTabs[index]= ${this.topTabs[index]}`)
              Logger.info(TAG, `index= ${index.toString()}`)
              this.topTabIndex = index
              Logger.info(TAG, `topTabIndex = ${this.topTabIndex}`)
              if (index === this.topTabIndex) {
                this.controller.changeIndex(this.topTabIndex)
              } else {
                Logger.info(TAG, `error`)
              }
            })
        }, item => item)
      }
      .width('100%')
      .padding(10)
      .borderRadius(10)
      .backgroundColor('#0D9FFB')

      Tabs({ barPosition: BarPosition.Start, index: 0, controller: this.controller }) {
        TabContent() {
          Scroll() {
            Column() {
              this.ContentView(this.nearList)
            }
            .margin({ bottom: 100 })
          }
        }

        TabContent() {
          Scroll() {
            Column() {
              this.ContentView(this.hotList)
            }
            .margin({ bottom: 100 })
          }
        }

        TabContent() {
          Scroll() {
            Column() {
              this.ContentView(this.classicList)
            }
            .margin({ bottom: 100 })
          }
        }
      }
      .barHeight(0)
      .vertical(false)
      .scrollable(true)
      .animationDuration(1000)
      .onChange((index: number) => {
        this.topTabIndex = index
        this.releaseChange()
      })
    }
    .width('100%')
  }
}