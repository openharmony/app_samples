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

import { obtainImgVertical, obtainImgV } from '../model/ImageList'

@Component
export struct ButtonComponent {
  private isLand: boolean = false
  private onInputValue: (result) => void

  build() {
    Row() {
      Grid() {
        ForEach(obtainImgV(), (item, index) => {
          GridItem() {
            Image(item.image)
              .objectFit(ImageFit.Fill)
              .margin({ top: 5 })
              .onClick(() => {
                this.onInputValue(item.value)
              })
          }
          .rowStart(index)
          .rowEnd(index === 3 ? index + 1 : index)
          .columnStart(3)
          .columnEnd(3)
        })

        ForEach(obtainImgVertical(), (item) => {
          ForEach(item, (item) => {
            GridItem() {
              Image(item.image)
                .objectFit(ImageFit.Fill)
                .margin({ top: 5 })
                .onClick(() => {
                  this.onInputValue(item.value)
                })
            }
          })
        })
      }
      .columnsGap(10)
      .rowsGap(10)
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
    }
    .padding(10)
    .size({ width: '100%', height: '60%' })
  }
}