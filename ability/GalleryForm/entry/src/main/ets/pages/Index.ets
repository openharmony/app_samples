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

import ImageData from '../data/ImageData'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../data/Logger'
import TitleBar from '../component/TitleBar'
import GalleryFormConst from '../data/GalleryFormConst'

const TAG: string = 'Index'

@Entry
@Component
struct Index {
  @State imageDatas: Array<mediaLibrary.FileAsset> = []

  async aboutToAppear() {
    await globalThis.abilityContext.requestPermissionsFromUser(GalleryFormConst.PERMISSIONS, GalleryFormConst.permissionState)
    this.imageDatas = await ImageData.getAllImage()
    Logger.info(TAG, `this image number = ${this.imageDatas.length} uri = ${this.imageDatas[0].uri}`)

  }

  build() {
    Row() {
      Column() {
        TitleBar()

        Grid() {
          if (this.imageDatas.length > 0) {
            ForEach(this.imageDatas, item => {
              GridItem() {
                Image(item.uri)
                  .width('100%')
                  .aspectRatio(1)
                  .objectFit(ImageFit.Cover)
              }
            }, item => item.uri)
          }
        }
        .width('95%')
        .height('95%')
        .maxCount(2)
        .rowsGap('2%')
        .columnsGap('2%')
        .columnsTemplate('1fr 1fr')
        .margin({ top: 10, bottom: 6, left: 6, right: 6 })
      }
      .width('100%')
    }
    .height('100%')
  }
}