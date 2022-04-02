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
import featureAbility from '@ohos.ability.featureAbility'
import screenshot from '@ohos.screenshot'
import image from '@ohos.multimedia.image'
import { TitleBar } from '../common/TitleBar'
import { CustomBtn } from '../common/CustomBtn'
import { ScreenshotDialog } from '../common/ScreenshotDialog'

const TAG = '[Screenshot]'

@Entry
@Component
struct Index {
  @State pixelMap: image.PixelMap = undefined

  private screenshotDialogController: CustomDialogController = new CustomDialogController({
    builder: ScreenshotDialog({ pixelMap: this.pixelMap }),
    autoCancel: true
  })

  getScreen = (isFullScreen) => {
    console.info(`${TAG} getScreen,isFullScreen: ${isFullScreen}`)
    let screenshotOptions: screenshot.ScreenshotOptions = {
      screenRect: { left: 0, top: 0, width: 400, height: 400 },
      imageSize: { width: 400, height: 400 },
      rotation: 0,
      displayId: 0
    }
    if (isFullScreen) {
      screenshotOptions = {
        rotation: 0
      }
    }
    screenshot.save(screenshotOptions, (err, data: image.PixelMap) => {
      if (err) {
        console.error(`${TAG}Failed to save the screenshot. Error:${JSON.stringify(err)}`)
      }
      if(this.pixelMap !== undefined) {
        this.pixelMap.release()
      }
      this.pixelMap = data
      this.screenshotDialogController.open()
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

          CustomBtn({ text: $r('app.string.btn_fullscreen'), isFullScreen: true, onClickAction: this.getScreen })
          CustomBtn({ text: $r('app.string.btn_fixedsize'), isFullScreen: false, onClickAction: this.getScreen })
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}