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

import multimedia_mediaLibrary from '@ohos.multimedia.mediaLibrary'
import { Rotate } from '../common/Rotate'
import { ImageModel } from '../model/ImageModel'

@Component
export struct ImageShow {
  @State pixel: multimedia_mediaLibrary.FileAsset = undefined
  private uri: string = ''
  private imageModel: ImageModel = new ImageModel()
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: Rotate({ uri: this.uri }), autoCancel: true, alignment: DialogAlignment.Bottom
  })

  async aboutToAppear() {
    this.pixel = await this.imageModel.queryFile(this.uri)
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Image(this.pixel.uri)
          .objectFit(ImageFit.Contain)
          .margin(16)
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