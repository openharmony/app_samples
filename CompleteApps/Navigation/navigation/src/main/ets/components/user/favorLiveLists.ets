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

import router from '@ohos.router'
import { FavorLiveListsModel } from '../../model/homeModel'
import { FavorLiveListsData } from '../../data/homedata'

@Component
export struct FavorLiveListComponent {
  @State FavorLiveListsData: Array<FavorLiveListsModel> = FavorLiveListsData
  @Prop ratio: number

  build() {
    Column() {
      Grid() {
        ForEach(this.FavorLiveListsData, item => {
          GridItem() {
            Stack({ alignContent: Alignment.TopStart }) {
              Image(item.imgSrc)
                .objectFit(ImageFit.Cover)
              Row() {
                Text(item.title)
                  .fontSize(14)
                  .fontColor('#FFFFFF')
                  .backgroundColor('#EA314D')
                  .padding({ left: '12vp', top: '2vp', bottom: '2vp' })
                  .width('40%')
                  .borderRadius(10)
                Text(item.viewsInfo)
                  .fontSize(14)
                  .fontColor(Color.White)
                  .padding({ left: '5vp', top: '2vp', bottom: '2vp' })
                  .opacity(1)
              }
              .width('75%')
              .borderRadius(10)
              .margin({ left: 8, top: 6, right: 8, bottom: 6 })
              .backgroundColor('#41000000')
            }
          }
          .width('100%')
          .aspectRatio(1.1)
          .margin({ top: 3 })
          .onClick(() => {
            router.push({
              url: '',
              params: { goodId: item.id, goodItem: item }
            })
          })
        }, item => item.toString())
      }
      .columnsGap('20vp')
      .rowsGap('10vp')
      .columnsTemplate('1fr 1fr')
    }
    .backgroundColor('#F1F3F5')
  }
}