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
import multimediaImage from '@ohos.multimedia.image'
import router from '@ohos.router'
import Logger from '../model/Logger'
import { getTimeString } from '../model/TimeUtils'

const TAG: string = 'VideoItem'

@Component
export default struct VideoItem {
  private media: mediaLibrary.FileAsset
  @State pixelMap: multimediaImage.PixelMap = undefined

  aboutToAppear() {
    let size: multimediaImage.Size = { width: 50, height: 50 }
    this.media.getThumbnail(size, (err, pixelMap) => {
      Logger.info(TAG, 'getThumbnail callback')
      if (err) {
        Logger.info(TAG, `getThumbnail callback,err=${JSON.stringify(err)}`)
        return
      }
      this.pixelMap = pixelMap
      Logger.info(TAG, `getThumbnail callback,err=${typeof this.pixelMap}`)
    })
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Image(this.pixelMap ? this.pixelMap : $r('app.media.video_poster'))
          .width('100%')
          .height(220)
          .objectFit(ImageFit.Cover)
        Text(getTimeString(this.media.duration))
          .fontColor(Color.White)
          .backgroundColor('#99000000')
          .padding(5)
          .borderRadius(10)
      }
      .width('100%')
      .height(220)

      Text(this.media.displayName)
        .width('100%')
        .fontSize(22)
        .padding(10)
    }
    .backgroundColor('#FFFFFF')
    .onClick(() => {
      Logger.info(TAG, `onClick, id=${this.media.id},displayName=${this.media.displayName}`)
      router.push({
        url: 'pages/Player',
        params: { fileId: this.media.id, displayName: this.media.displayName }
      })
    })

  }
}