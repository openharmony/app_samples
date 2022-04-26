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

@Component
export struct VideoOperation {
  @State info: any = undefined
  private collectClick: () => void
  private publishClick: () => void

  build() {
    Row() {
      if (this.info.isRelease === true) {
        Row() {
          Image($r('app.media.playnum')).objectFit(ImageFit.Contain).width(25)
          Text(JSON.stringify(this.info.playNum)).fontSize(15).margin({ left: 3 })
        }.layoutWeight(1).height('100%')

        Row() {
          Image($r('app.media.barrage')).objectFit(ImageFit.Contain).width(25)
          Text(JSON.stringify(this.info.BarrageNum)).fontSize(15).margin({ left: 3 })
        }.layoutWeight(1).height('100%')

        Row() {
          Image(this.info.collectImg).objectFit(ImageFit.Contain).width(25)
          Text($r('app.string.collection')).fontSize(15).margin({ left: 3 })
        }.layoutWeight(1).height('100%')
        .onClick(() => {
          this.collectClick()
        })
      } else {
        Row() {
          Image(this.info.resImg).objectFit(ImageFit.Contain).width(25)
          Text($r('app.string.appointment')).fontSize(15).margin({ left: 3 })
        }.layoutWeight(1).height('100%')
        .onClick(() => {
          this.publishClick()
        })
      }
    }
    .width('90%').height(30)
    .margin({ top: 5 })
  }
}