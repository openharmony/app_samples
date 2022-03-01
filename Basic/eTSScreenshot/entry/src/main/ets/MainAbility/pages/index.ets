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

import screenshot from '@ohos.screenshot'
import image from '@ohos.multimedia.image'
import { TitleBar } from '../common/titleBar'
import { CustomBtn } from '../common/customBtn'
import { ScreenshotDialog } from '../common/screenshotDialog'

const TAG = '[Screenshot]'

@Entry
@Component
struct Index {
  @State pixelMap: PixelMap = undefined
  private screenshotDialogController: CustomDialogController = new CustomDialogController({
    builder: ScreenshotDialog({ pixelMap: this.pixelMap }),
    autoCancel: true
  })

  getFullScreen() {
    this.getScreenShot(null)
  }

  getFixedSize() {
    let screenshotOptions = {
      screenRect: { left: 0, top: 0, width: 400, height: 400 },
      imageSize: { width: 400, height: 400 },
      rotation: 0,
      displayId: 0
    }
    this.getScreenShot(screenshotOptions)
  }

  getScreenShot(option) {
    let promise = null
    if (option == null) {
      promise = screenshot.save()
    } else {
      promise = screenshot.save(option)
    }
    promise.then(function(pixelMap){
      console.info(`${TAG} screenshot callback`)
      if (this.pixelMap != undefined) {
        this.pixelMap.release()
      }
      this.pixelMap = pixelMap
      this.screenshotDialogController.open()
    }.bind(this))
      .catch(err => {
        console.info(`${TAG} err = ${JSON.stringify(err)}`)
      })
  }

  build() {
    Column() {
      TitleBar()
      Scroll() {
        Column() {
          Image($r('app.media.image'))
            .width('95%')
            .height('35%')
            .margin({ top: 10 })
            .backgroundColor('#E5E5E5')
            .objectFit(ImageFit.Contain)

          CustomBtn({ text: $r('app.string.btn_fullscreen'), onClickAction: this.getFullScreen.bind(this) })
          CustomBtn({ text: $r('app.string.btn_fixedsize'), onClickAction: this.getFixedSize.bind(this) })
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}