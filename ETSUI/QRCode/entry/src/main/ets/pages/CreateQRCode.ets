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
import display from '@ohos.display'
import image from '@ohos.multimedia.image'
import screenshot from '@ohos.screenshot'
import Logger from '../model/Logger'
import MediaUtils from '../model/MediaUtils'
import TitleBar from '../common/TitleBar'

const TAG: string = '[CreateQRCode]'
const QRCODE_SIZE: number = 400 // 生成二维码的大小
const QRCODE_PADDING: number = 10 // 二维码保存时图片边距
const QRCODE_TOP: number = 170 // 二维码保存时图片顶部距离屏幕顶部边缘距离

@Entry
@Component
struct CreateQRCode {
  private rectLeft: number = 0
  @State codeStr: string = ''
  getScreen = () => {
    console.info(`${TAG} getScreen,isFullScreen`)
    let screenshotOptions: screenshot.ScreenshotOptions = {
      screenRect: {
        left: this.rectLeft,
        top: QRCODE_TOP,
        width: QRCODE_SIZE + 2 * QRCODE_PADDING,
        height: QRCODE_SIZE + 2 * QRCODE_PADDING
      },
      imageSize: { width: QRCODE_SIZE + 2 * QRCODE_PADDING, height: QRCODE_SIZE + 2 * QRCODE_PADDING },
      rotation: 0,
      displayId: 0
    }

    screenshot.save(screenshotOptions, (err, data: image.PixelMap) => {
      if (err) {
        Logger.info(TAG, `Failed to save the screenshot. Error:${JSON.stringify(err)}`)
      }
      Logger.info(TAG, 'save callback')
      MediaUtils.savePicture(data)
    })
  }

  async aboutToAppear() {
    let defaultDisplay = await display.getDefaultDisplay()
    Logger.info(TAG, `defaultDisplay.width = ${defaultDisplay.width}`)
    this.rectLeft = (defaultDisplay.width - QRCODE_SIZE) / 2 - QRCODE_PADDING
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true })
      Scroll() {
        Column() {
          QRCode(this.codeStr)
            .width(QRCODE_SIZE)
            .aspectRatio(1)
            .margin(40)
          TextInput({ placeholder: $r('app.string.input_placeholder'), text: this.codeStr })
            .width('90%')
            .height(60)
            .placeholderColor(Color.Gray)
            .fontSize(30)
            .margin({ left: 15, right: 15, top: 20 })
            .backgroundColor(Color.White)
            .onChange((value: string) => {
              this.codeStr = value
            })

          Button({ type: ButtonType.Capsule }) {
            Text($r('app.string.save'))
              .fontSize(30)
              .fontColor(Color.White)
          }
          .width('90%')
          .height(70)
          .backgroundColor('#0D9FFB')
          .margin(20)
          .onClick(this.getScreen)
        }
      }
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .backgroundColor('#F5F5F5')
  }
}