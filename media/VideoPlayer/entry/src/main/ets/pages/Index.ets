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
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import router from '@ohos.router'
import Logger from '../model/Logger'
import MediaUtils from '../model/MediaUtils'
import TitleBar from '../common/TitleBar'
import VideoItem from '../common/VideoItem'

const TAG: string = 'Index'

@Entry
@Component
struct Index {
  private scroller: Scroller = new Scroller()
  @State mediaList: Array<mediaLibrary.FileAsset> = []

  async aboutToAppear() {
    router.clear()
    Logger.info(TAG, 'aboutToAppear')
    await globalThis.abilityContext.requestPermissionsFromUser(['ohos.permission.READ_MEDIA'])
    await this.getData()
  }

  async getData() {
    this.mediaList = []
    let fileAsset = MediaUtils.getFileAssetsFromType(mediaLibrary.MediaType.VIDEO)
    fileAsset.then(fileList => {
      Logger.info(TAG, 'getFileList callback')
      this.mediaList = fileList
    }).catch(err => {
      Logger.error(TAG, `getFileList err,err = ${err}`)
    })
  }

  build() {
    Column() {
      TitleBar()
      Text($r('app.string.local_videos'))
        .width('100%')
        .fontSize(30)
        .textAlign(TextAlign.Start)
        .padding(10)
      Grid(this.scroller) {
        ForEach(this.mediaList, item => {
          GridItem() {
            VideoItem({ media: item })
          }
        }, item => item.title)
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')
      .padding(10)
    }
    .height('100%')
  }
}