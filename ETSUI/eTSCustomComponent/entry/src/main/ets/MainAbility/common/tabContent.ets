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

import { ReleaseData, addStorage, modifyStorage,getStorageList } from '../model/releaseData.ets'
import { getTextColor, checkExist, menuTitle } from '../util/utils.ets'
import { nearRelease, hotRelease, classicRelease } from '../util/actionUtils.ets'
import { VideoOperation } from '../common/videoOperation.ets'

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

  aboutToAppear() {
    this.nearList = nearRelease(this.releaseList)
    this.hotList = hotRelease(this.releaseList)
    this.classicList = classicRelease(this.releaseList)
  }

  releaseChange() {
    this.ContentRefresh(this.releaseList)
  }

  ContentRefresh(release: Array<ReleaseData>) {
    switch (this.topTabIndex) {
      case 0:
        this.nearList = nearRelease(this.releaseList)
        break
      case 1:
        this.hotList = hotRelease(this.releaseList)
        break
      case 2:
        this.classicList = classicRelease(this.releaseList)
        break
      default:
        break
    }
  }

  browseOnClick(data:ReleaseData) {
    let browse = getStorageList('browse')
    let exist = checkExist(data, browse)
    if (exist !== true) {
      addStorage(data, 'browse')
      let browseList = getStorageList('browse')
      this.broMenu = menuTitle(browseList)
      console.info(`${TAG} browseList= ${JSON.stringify(browseList)} \n browseList.length= ${browseList.length}`)
    }
  }

  reservationOnClick(data:ReleaseData) {
    data.isRes = !data.isRes
    let i = this.releaseList.indexOf(data)
    console.info(`${TAG} i= ${JSON.stringify(i)}`)
    this.releaseList[i] = data
    modifyStorage(data, i, 'release')
    if (data.isRes === false) {
      let j = this.reservationList.indexOf(data)
      this.reservationList.splice(j, 1)
    } else {
      this.reservationList.push(data)
    }
    data.resImg = data.isRes == false ? $r('app.media.nofocus') : $r('app.media.focus')
    this.resMenu = menuTitle(this.reservationList)
    console.info(`${TAG} reservationList= ${JSON.stringify(this.reservationList)} \n reservationList.length= ${this.reservationList.length}`)
    let list = this.releaseList
    this.releaseList = []
    this.releaseList = list
    this.ContentRefresh(this.releaseList)
  }

  collectionOnClick(data:ReleaseData) {
    data.isCollect = !data.isCollect
    let i = this.releaseList.indexOf(data)
    this.releaseList[i] = data
    modifyStorage(data, i, 'release')
    if (data.isCollect === false) {
      let j = this.collectionList.indexOf(data)
      this.collectionList.splice(j, 1)
    } else {
      this.collectionList.push(data)
    }
    data.collectImg = data.isCollect == false ? $r('app.media.nocollect') : $r('app.media.iscolloect')
    this.colMenu = menuTitle(this.collectionList)
    console.info(`${TAG} collectionList= ${JSON.stringify(this.collectionList)} \n collectionList.length= ${this.collectionList.length}`)
  }

  @Builder imageTextOfRow(image:Resource, data:string) {
    Row() {
      Image(image).objectFit(ImageFit.Contain).width(25)
      Text(data).fontSize(15).margin({ left: 3 })
    }.layoutWeight(1).height('100%')
  }

  @Builder ContentView(releaseA: Array<ReleaseData>) {
    ForEach(releaseA, (item, index) => {
      Row() {
        Image($r('app.media.cover'))
          .width('30%').height(90)
          .objectFit(ImageFit.Fill)
          .onClick(function(){
            this.browseOnClick(item)
            this.ContentRefresh(releaseA)
          }.bind(this))
        Column() {
          Text(item.title).width('90%').fontSize(20).fontWeight(FontWeight.Bold)
          Text(item.date).width('90%').fontSize(15).margin({ top: 10 })
          VideoOperation({ info: item, collectClick: function(){
            this.collectionOnClick(item)
            this.ContentRefresh(releaseA)
          }.bind(this), publishClick: function(){
            this.reservationOnClick(item)
            this.ContentRefresh(releaseA)
          }.bind(this) })
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
            .onClick(function(){
              console.info(`${TAG} topTabs[index]= ${this.topTabs[index]}`)
              console.info(`${TAG} index= ${index.toString()}`)
              this.topTabIndex = index
              console.info(`${TAG} topTabIndex= ${this.topTabIndex}`)
              if (index === this.topTabIndex) {
                this.controller.changeIndex(this.topTabIndex)
              } else {
                console.info(`${TAG} error`)
              }
            }.bind(this))
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
      .scrollable(true)
      .vertical(false)
      .animationDuration(1000)
      .onChange((index: number) => {
        this.topTabIndex = index
      })
    }
    .width('100%')
  }
}