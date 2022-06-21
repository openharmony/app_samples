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
import featureAbility from '@ohos.ability.featureAbility'
import multimedia_mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../model/Logger'
import { ImageModel } from '../model/ImageModel'

const TAG: string = '[ImageGallery]'
const PERMISSIONS: Array<string> =
  [
    'ohos.permission.MEDIA_LOCATION',
    'ohos.permission.READ_MEDIA',
    'ohos.permission.WRITE_MEDIA'
  ]

@Component
export struct ImageGallery {
  @State imgDatas: Array<multimedia_mediaLibrary.FileAsset> = []
  private imageModel: ImageModel = new ImageModel()

  async aboutToAppear() {
    let permissionState = 666 //  传递给返回结果的请求代码
    let result = await globalThis.abilityContext.requestPermissionsFromUser(PERMISSIONS, permissionState)
    Logger.info(TAG, `grantPermission requestPermissionsFromUser result.requestCode = ${JSON.stringify(result)}`)
    this.imgDatas = await this.imageModel.getAllImg()
    Logger.info(TAG, `this image number = ${this.imgDatas.length} uri = ${this.imgDatas[0].uri}`)
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.imgDatas, item => {
          GridItem() {
            Image(item.uri)
              .width('100%')
              .aspectRatio(1)
              .objectFit(ImageFit.Cover)
              .onClick(() => {
                Logger.info(TAG, `111111111`)
                router.replace({
                  url: 'pages/Second',
                  params: {
                    uri: item.uri
                  }
                })
              })
          }
        }, item => item.toString())
      }
      .margin({ top: 10, bottom: 6, left: 6, right: 6 })
      .maxCount(2)
      .width('95%')
      .height('95%')
      .rowsGap('2%')
      .columnsGap('2%')
      .columnsTemplate('1fr 1fr')
    }
  }
}