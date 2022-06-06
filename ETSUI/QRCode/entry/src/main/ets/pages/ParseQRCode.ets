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
import image from '@ohos.multimedia.image'
import prompt from '@ohos.prompt'
import jsQR from 'jsqr'
import Logger from '../model/Logger'
import MediaUtils from '../model/MediaUtils'
import TitleBar from '../common/TitleBar'

const TAG: string = '[ParasQRCode]'
const QRCODE_SIZE: number = 250 // 二维码的大小

@Entry
@Component
struct ParseQRCode {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private defaultQrcodeImage: ImageBitmap = new ImageBitmap("common/media/qrcode.png")
  @State result: string = ''
  @State uploadQrcodeImage: image.PixelMap | undefined = undefined
  getDecode = async () => {
    let data = this.context.getImageData(0, 0, QRCODE_SIZE, QRCODE_SIZE)
    let time = Date.now()
    let result = jsQR(data.data, data.width, data.height, { inversionAttempts: "dontInvert" })
    if (result === null) {
      this.result = '解析失败！'
    } else {
      this.result = `解析为:${result.data} , 耗时:${Date.now() - time}ms`
    }
  }

  @Builder
  OperationBtn(text: Resource, handleClick: () => void) {
    Button({ type: ButtonType.Capsule }) {
      Text(text)
        .fontSize(30)
        .fontColor(Color.White)
    }
    .width('90%')
    .height(70)
    .backgroundColor('#0D9FFB')
    .margin(20)
    .onClick(handleClick)
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true })
      Scroll() {
        Column() {
          Canvas(this.context)
            .width(QRCODE_SIZE)
            .aspectRatio(1)
            .backgroundColor('#F0F0F0')
            .margin({ top: 40 })
            .onReady(() => {
              this.context.imageSmoothingEnabled = false
              this.context.clearRect(0, 0, QRCODE_SIZE, QRCODE_SIZE)
              if (this.uploadQrcodeImage) {
                this.context.drawImage(this.uploadQrcodeImage, 0, 0, QRCODE_SIZE, QRCODE_SIZE)
              } else {
                this.context.drawImage(this.defaultQrcodeImage, 0, 0, QRCODE_SIZE, QRCODE_SIZE)
              }
            })
          Text(this.result)
            .fontSize(25)
            .width('90%')
            .margin({ top: 40, bottom: 40 })
          this.OperationBtn($r('app.string.check_qrcode_file'), () => {
            globalThis.abilityContext.startAbilityForResult({
              bundleName: "com.ohos.filepicker",
              abilityName: "com.ohos.filepicker.MainAbility",
              parameters: {
                startMode: 'choose'
              }
            }
            ).then(async (data) => {
              this.result = ''
              let result = data.want.parameters.result
              let images = result.split(';')
              Logger.info(TAG, `this.images = ${JSON.stringify(images)}`)
              this.uploadQrcodeImage = await MediaUtils.getPixelMap(images[0])
              if (this.uploadQrcodeImage === null) {
                prompt.showToast({ message: '所选文件不是图片', duration: 1000 })
                return
              }
              this.context.clearRect(0, 0, QRCODE_SIZE, QRCODE_SIZE)
              this.context.drawImage(this.uploadQrcodeImage, 0, 0, QRCODE_SIZE, QRCODE_SIZE)
            })
          })
          this.OperationBtn($r('app.string.parse_qrcode'), () => {
            Logger.info(TAG, `paras`)
            this.result = '解析中，请等待'
            setTimeout(() => {
              this.getDecode()
            }, 10)
          })
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}