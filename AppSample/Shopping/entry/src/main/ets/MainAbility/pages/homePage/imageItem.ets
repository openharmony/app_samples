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

import router from '@system.router';
import { FindImgSrcModel, FindImgIntroModel, FindImgNameModel, FindIconSrcModel } from '../../model/homeModel'
import { findImgSrcData, findImgIntroData, findImgNameData, findIconSrcData } from '../../data/homeData'

@Component
export struct ImageItem {
  @Prop ratio: number
  @State flag: boolean = false
  @State num: number = Math.round(Math.random() * 10000)
  @State itemNum: number = Math.floor(Math.random() * 3)
  @State imgSrc: Array<FindImgSrcModel> = findImgSrcData
  @State imgIntro: Array<FindImgIntroModel> = findImgIntroData
  @State imgName: Array<FindImgNameModel> = findImgNameData
  @State iconSrc: Array<FindIconSrcModel> = findIconSrcData

  build() {
    Column() {
      Image(this.imgSrc[this.itemNum].imgSrc)
        .width('100%')
        .height('70%')
        .objectFit(ImageFit.Cover)
        .border({ radius: 10 * this.ratio })
      Text(this.imgIntro[this.itemNum].imgIntro)
        .fontSize(15 * this.ratio)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .height('15%')
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Image(this.iconSrc[this.itemNum].iconSrc)
            .width(20 * this.ratio)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
            .border({ radius: 10 * this.ratio })
            .margin({ right: 5 })
          Text(this.imgName[this.itemNum].imgName)
            .fontSize(12 * this.ratio)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('70%')
        }
        .width('66%')
        .height('100%')

        Row() {
          Row() {
            Image(`${this.flag ? '/resources/icon/hearted.png' : '/resources/icon/heart.png'}`)
              .width(20 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Cover)
              .onClick(() => {
                this.flag = !this.flag
              })
            Text(`${this.flag ? this.num + 1 : this.num}`)
              .fontSize(12 * this.ratio)
              .margin({ left: 5 })
          }
        }
        .width('34%')
        .height('100%')
      }
      .height('15%')
    }
    .width('50%')
  }
}