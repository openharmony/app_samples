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
import MediaUtils from '../model/MediaUtils'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import fileio from '@ohos.fileio'
import Logger from '../model/Logger'
import prompt from '@ohos.prompt'

const TAG = '[Screenshot]'
const PERMISSIONS: Array<string> = [
  'ohos.permission.READ_MEDIA',
  'ohos.permission.WRITE_MEDIA',
  'ohos.permission.CAPTURE_SCREEN']

@Entry
@Component
struct Index {
  private mediaUtil = MediaUtils.getInstance()
  getScreen = (isFullScreen) => {
    Logger.info(`${TAG} getScreen,isFullScreen: ${isFullScreen}`)
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
      this.savePicture(data)
    })
  }

  async savePicture(data) {
    Logger.info(TAG, `savePicture`)
    let packOpts: image.PackingOption = { format: "image/jpeg", quality: 100 }
    let imagePackerApi = image.createImagePacker()
    let arrayBuffer = await imagePackerApi.packing(data, packOpts)
    let fileAsset = await this.mediaUtil.createAndGetUri(mediaLibrary.MediaType.IMAGE)
    let fd = await fileAsset.open('Rw')
    Logger.info(TAG, `fd=${fd}`)
    imagePackerApi.release()
    await fileio.write(fd, arrayBuffer)
    await fileAsset.close(fd)
    Logger.info(TAG, `write done`)
    prompt.showToast({ message: '图片保存成功，请前往图库中查看', duration: 1000 })
  }

  aboutToAppear() {
    featureAbility.getContext().requestPermissionsFromUser(PERMISSIONS, 3)
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