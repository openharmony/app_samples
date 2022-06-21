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

import multimedia_image from '@ohos.multimedia.image'
import multimedia_mediaLibrary from '@ohos.multimedia.mediaLibrary'
import { Rotate } from '../common/Rotate'
import { ImageModel } from '../model/ImageModel'

@Component
export struct ImageShow {
  @State pixel: multimedia_image.PixelMap = undefined
  @State fileAsset: multimedia_mediaLibrary.FileAsset = undefined
  private uri: string = ''
  private height: number = 0
  private width: number = 0
  private imageModel: ImageModel = new ImageModel()
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: Rotate({ uri: this.uri }), autoCancel: true, alignment: DialogAlignment.Bottom
  })

  async aboutToAppear() {
    this.fileAsset = await this.imageModel.queryFile(this.uri)
  }

  async getImage() {
    this.pixel = await this.imageModel.getPixel(this.uri)
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Canvas(this.canvasContext)
          .margin({ top: 16 })
          .width(900)
          .height(600)
          .onReady(async () => {
            await this.getImage()
            this.canvasContext.drawImage(this.pixel, 0, 0, 900, 600)
          })
      }
      .width('100%')
      .height('80%')

      Button($r('app.string.rotate'))
        .fontSize(18)
        .height('8%')
        .width('60%')
        .margin({ top: 18, bottom: 6, right: 6, left: 6 })
        .onClick(() => {
          this.dialogController.open()
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ff000000')
  }
}