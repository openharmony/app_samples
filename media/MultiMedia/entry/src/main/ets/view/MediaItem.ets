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
import { getDurationString } from '../model/TimeUtils'

@Component
export struct MediaItem {
  private media: mediaLibrary.FileAsset = undefined
  private index: number = 0
  private btnAction: (operate: string, index: number) => void

  tempNum(number) {
    if (number < 10) {
      return "0" + number
    }
    return number.toString()
  }

  getTimeString() {
    let date = new Date()
    date.setMilliseconds(this.media.dateAdded)
    return `${date.getFullYear()}/${this.tempNum(date.getMonth() + 1)}/${this.tempNum(date.getDate())}`
  }

  getImgSrc() {
    switch (this.media.mediaType) {
      case mediaLibrary.MediaType.VIDEO:
        return $r('app.media.video_poster')
      case mediaLibrary.MediaType.AUDIO:
        return $r('app.media.ic_play')
      case mediaLibrary.MediaType.FILE:
        return $r('app.media.ic_document')
        break
      default:
        return this.media.uri
        break
    }
  }

  build() {
    Row() {
      Image(this.getImgSrc())
        .size({ width: 100, height: 100 })
        .aspectRatio(1)
        .borderRadius(10)
        .objectFit(ImageFit.Fill)
      Column() {
        Text(this.media.title)
          .width('100%')
          .fontSize(22)
        Text(this.getTimeString())
          .width('100%')
          .fontSize(22)
          .margin({ top: 10 })
        if(this.media.mediaType ===  mediaLibrary.MediaType.VIDEO) {
          Text(getDurationString(this.media.duration))
            .width('100%')
            .fontSize(22)
            .margin({ top: 10 })
        }
      }
      .margin({ left: 10 })
      .layoutWeight(1)

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Column() {
          Image($r('app.media.ic_rename'))
            .objectFit(ImageFit.Contain)
            .size({ width: 40, height: 40 })
        }
      }
      .size({ width: 50, height: 50 })
      .backgroundColor('#F5F5F5')
      .onClick(() => {
        this.btnAction('rename', this.index)
      })

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Column() {
          Image($r('app.media.ic_delete'))
            .objectFit(ImageFit.Contain)
            .size({ width: 40, height: 40 })
        }
      }
      .size({ width: 50, height: 50 })
      .margin({ left: 15, right: 10 })
      .backgroundColor('#F5F5F5')
      .onClick(() => {
        this.btnAction('delete', this.index)
      })
    }
    .padding({ top: 10, bottom: 10, left: 10, right: 10 })
    .margin({ left: 15, right: 15, top: 10 })
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
  }
}