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

import { ImageModel } from '../model/ImageModel'

@CustomDialog
export struct ImageInfo {
  @State showDatas: Array<{
    name: Resource,
    value: string
  }> = []
  private uri: string = ''
  private flag: number = 0
  private controller?: CustomDialogController
  private imageModel: ImageModel = new ImageModel()

  async aboutToAppear() {
    let fileAsset = await this.imageModel.queryFile(this.uri)
    let name = fileAsset.displayName
    let result = await this.imageModel.getImageInfo(this.uri)
    let imageHeight = result[0]
    let imageWidth = result[1]
    let path = fileAsset.relativePath + name
    let size = `${(fileAsset.size / (1024 * 1024)).toFixed(2)}MB`
    this.showDatas = [
      { name: $r('app.string.name'), value: name },
      { name: $r('app.string.size'), value: size },
      { name: $r('app.string.path'), value: path },
      { name: $r('app.string.resolution'), value: `${imageWidth}x${imageHeight}` }
    ]
  }

  build() {
    Column() {
      ForEach(this.showDatas, item => {
        Row() {
          Text(item.name)
            .margin(10)
            .fontSize(18)
            .width('20%')
            .textAlign(TextAlign.End)
          Text(`${item.value}`)
            .margin(10)
            .fontSize(18)
            .width('60%')
        }
      }, item => item.value.toString())

      Button($r('app.string.close'))
        .margin(10)
        .fontSize(18)
        .onClick(() => {
          this.controller.close()
        })
    }
    .margin(10)
  }
}