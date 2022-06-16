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

import router from '@ohos.router'
import { ImageInfo } from '../common/ImageInfo'
import { ImageShow } from '../common/ImageShow'

@Entry
@Component
struct Second {
  private uri: string = router.getParams()['uri']
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: ImageInfo({ uri: this.uri }), autoCancel: true, alignment: DialogAlignment.Bottom
  })

  build() {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.left'))
            .objectFit(ImageFit.Contain)
            .width('15%')
          Text($r('app.string.back'))
            .fontSize(18)
            .fontColor(Color.White)
        }
        .layoutWeight(1)
        .onClick(() => {
          router.replace({
            url: 'pages/Index'
          })
        })

        Text($r('app.string.more'))
          .fontSize(18)
          .fontColor(Color.White)
          .width('15%')
          .height('100%')
          .margin({ right: '5%' })
          .onClick(() => {
            this.dialogController.open()
          })
      }
      .height('6%')
      .width('100%')
      .padding({ left: 14 })
      .backgroundColor('#0D9FFB')

      ImageShow({ uri: this.uri })
    }
    .height('100%')
    .width('100%')
  }
}