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

import { checkExist, menuTitle } from '../util/utils'
import { ReleaseData, addStorage, modifyStorage, getStorageList } from '../model/releaseData'

const TAG = '[Component.TopView]'

@Extend(Text) function webFancy (fontColor: string) {
  .fontSize(17)
  .layoutWeight(1)
  .fontColor(fontColor)
  .fontWeight(FontWeight.Bold)
  .textAlign(TextAlign.Center)
}

@Extend(Text) function textFancy (fontSize: number, fontWeight: FontWeight, paddingTop: number) {
  .width('100%')
  .fontSize(fontSize)
  .fontWeight(fontWeight)
  .padding({ left: 10, top: paddingTop })
}

@Component
struct CustomContainer {
  officalText: Resource
  mediaText: Resource
  @BuilderParam closeContent: () => any

  build() {
    Column() {
      Row() {
        Text(this.officalText).webFancy('#FF0000')
        Text(this.mediaText).webFancy('#0D9FFB')
      }
      .width('80%')
      .height(30)
      .margin({ top: 10 })

      this.closeContent()
    }
  }
}

@Builder

function specificParam(img: Resource, imgText: Resource) {
  Row() {
    Image(img)
      .width(20)
      .height(20)
      .objectFit(ImageFit.Contain)
    Text(imgText)
      .fontSize(17)
      .margin({ left: 5 })
  }
}

@Component
export struct TopView {
  @Link resMenu: string[]
  @Link colMenu: string[]
  @Link broMenu: string[]
  @Link @Watch('releaseChange') releaseList: Array<ReleaseData>
  @Link reservationList: Array<ReleaseData>
  @Link collectionList: Array<ReleaseData>
  @State topViewList: Array<ReleaseData> = []
  private todayDate = '2021.11.29'

  aboutToAppear() {
    this.viewList()
  }

  releaseChange() {
    this.viewList()
  }

  viewList() {
    this.topViewList = []
    let todayList = []
    let noReleaseList = []
    for (let i in this.releaseList) {
      if (this.releaseList[i].isRelease === false) {
        noReleaseList.push(this.releaseList[i])
      } else if (this.releaseList[i].date === this.todayDate) {
        todayList.push(this.releaseList[i])
      }
    }
    this.topViewList = todayList.concat(noReleaseList)
  }

  browseOnClick(data:ReleaseData) {
    let browse = getStorageList('browse')
    let exist = checkExist(data, browse)
    if (exist !== true) {
      addStorage(data, 'browse')
      let browseList = getStorageList('browse')
      this.broMenu = menuTitle(browseList)
      console.info(`${TAG} browseList= ${JSON.stringify(browseList)} \n ${TAG} browseList.length= ${browseList.length.toString()}`)
    }
  }

  reservationOnClick(data:ReleaseData) {
    console.info('[fengzi]data = ' + JSON.stringify(data))
    data.isRes = !data.isRes
    let i = this.releaseList.indexOf(data)
    this.releaseList[i] = data
    modifyStorage(data, i, 'release')
    console.info('[fengzi]releaseList=' + JSON.stringify(this.releaseList))
    if (data.isRes === false) {
      let j = this.reservationList.indexOf(data)
      this.reservationList.splice(j, 1)
    } else {
      this.reservationList.push(data)
    }
    data.resImg = data.isRes == false ? $r('app.media.nofocus') : $r('app.media.focus')
    this.resMenu = menuTitle(this.reservationList)
    console.info(`${TAG} reservationList= ${JSON.stringify(this.reservationList)} \n ${TAG} reservationList.length= ${this.reservationList.length.toString()}`)
    this.viewList()
    let list = this.releaseList
    this.releaseList = []
    this.releaseList = list
  }

  build() {
    Column() {
      Swiper() {
        ForEach(this.topViewList, (item) => {
          Column() {
            Text(item.title).textFancy(25, FontWeight.Bold, 15)
            Text(item.date).textFancy(17, FontWeight.Normal, 2)
            Text(item.place).textFancy(17, FontWeight.Normal, 2)
            CustomContainer({
              officalText: item.isRelease === true ? $r('app.string.newProduct') : $r('app.string.officalPreheating'),
              mediaText: item.isRelease === true ? $r('app.string.mediaMeasurement') : $r('app.string.mediaGuess')
            }) {
              Row() {
                specificParam(item.isRelease === true ? $r('app.media.review') : item.resImg,
                    item.isRelease === true ? $r('app.string.liveBack') : $r('app.string.liveAppointment'))
              }
              .width(100)
              .height(30)
              .margin({ top: 7 })
              .onClick(function(){
                console.info('guojin item.isRelease=' + item.isRelease);
                item.isRelease === true ? this.browseOnClick(item) : this.reservationOnClick(item)
              }.bind(this))
            }
          }
          .width('100%')
          .height('100%')
          .border({ width: 2, radius: 10 })
        }, item => JSON.stringify(item))
      }
      .itemSpace(20)
      .autoPlay(true)
      .interval(20000)
      .indicator(false)
      .displayMode(SwiperDisplayMode.Stretch)
    }
    .width('100%')
    .height(180)
    .margin({ top: 10 })
  }
}