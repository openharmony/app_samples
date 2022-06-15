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
import screenshot from '@ohos.screenshot'
import image from '@ohos.multimedia.image'
import { TitleBar } from '../common/TitleBar'
import MediaUtils from '../model/MediaUtils'
import Logger from '../model/Logger'

const TAG = '[Screenshot]'
const PERMISSIONS: Array<string> = [
  'ohos.permission.READ_MEDIA',
  'ohos.permission.WRITE_MEDIA',
  'ohos.permission.CAPTURE_SCREEN']

@Entry
@Component
struct Index {
  getScreen = (isFullScreen: boolean) => {
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
        Logger.info(TAG, `Failed to save the screenshot. Error:${JSON.stringify(err)}`)
      }
      Logger.info(TAG, 'save callback')
      MediaUtils.savePicture(data)
    })
  }

  aboutToAppear() {
    globalThis.abilityContext.requestPermissionsFromUser(PERMISSIONS)
  }

  @Builder
  CustomBtn(text: Resource, isFullScreen: boolean) {
    Button() {
      Text(text)
        .fontColor(Color.White)
        .fontSize(20)
    }
    .type(ButtonType.Capsule)
    .backgroundColor('#0D9FFB')
    .size({ width: '90%', height: 50 })
    .margin(10)
    .backgroundColor('#0D9FFB')
    .onClick(() => {
      console.info('[Screenshot] onClick,screenshot')
      this.getScreen(isFullScreen)
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

          this.CustomBtn($r('app.string.btn_fullscreen'), true)
          this.CustomBtn($r('app.string.btn_fixedsize'), false)
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}