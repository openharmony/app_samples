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
import multimedia_mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../model/Logger'
import { ImageModel } from '../model/ImageModel'

const TAG: string = '[ImageGallery]'

@Component
export struct ImageGallery {
  @State imgDatas: Array<multimedia_mediaLibrary.FileAsset> = []
  private imageModel: ImageModel = new ImageModel()

  async aboutToAppear() {
    let context: any = getContext(this)
    this.imgDatas = await this.imageModel.getAllImg(context)
    Logger.info(TAG, `this image number = ${this.imgDatas.length}`)
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.imgDatas, item => {
          GridItem() {
            Image(item.uri)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                router.replace({
                  url: 'pages/Second',
                  params: {
                    uri: item.uri
                  }
                })
              })
          }
          .padding(2)
        }, item => item.toString())
      }
      .margin(4)
      .rowsGap(4)
      .maxCount(2)
      .columnsGap(4)
      .columnsTemplate('1fr 1fr')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff6f6f6')
  }
}