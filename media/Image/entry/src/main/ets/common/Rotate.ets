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
export struct Rotate {
  @State single: number = 0
  private uri: string = ''
  private controller?: CustomDialogController
  private imageModel: ImageModel = new ImageModel()

  build() {
    Column() {
      Row() {
        Text($r('app.string.rotate_single'))
          .fontSize(16)
          .width('22%')
          .margin({ top: 6, bottom: 6, left: 6 })
        Slider({
          value: this.single,
          min: 0,
          max: 360,
          step: 1,
          style: SliderStyle.OutSet
        })
          .width('60%')
          .showSteps(true)
          .blockColor(Color.Blue)
          .trackColor(Color.Gray)
          .selectedColor(Color.Blue)
          .onChange((value: number) => {
            this.single = value
          })
        Text(`${this.single.toFixed(2)}°`)
          .fontSize(16)
          .width('18%')
      }

      Row() {
        Button($r('app.string.save'))
          .margin(10)
          .fontSize(16)
          .width('40%')
          .height('8%')
          .onClick(() => {
            AlertDialog.show(
              {
                message: $r('app.string.storage'),
                primaryButton: {
                  value: $r('app.string.cancel'),
                  action: () => {
                    this.controller.close()
                  }
                },
                secondaryButton: {
                  value: $r('app.string.save'),
                  action: async () => {
                    await this.imageModel.angleImgs(this.uri, this.single)
                  }
                },
                cancel: () => {
                  this.controller.close()
                }
              }
            )
          })

        Button($r('app.string.cancel'))
          .margin(10)
          .fontSize(16)
          .width('40%')
          .height('8%')
          .onClick(() => {
            this.controller.close()
          })
      }
    }
    .margin(10)
  }
}