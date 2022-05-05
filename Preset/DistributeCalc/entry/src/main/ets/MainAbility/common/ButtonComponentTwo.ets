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
import { obtainImgLevel, obtainImg, obtainImgL } from '../model/ImageList'

@Component
export struct ButtonComponentTwo {
  private isLand: boolean
  private onInputValue: (result) => void

  build() {
    Column() {
      Grid() {
        ForEach(obtainImg(), (item, index) => {
          GridItem() {
            Image(item.Img)
              .margin({ top: 5 })
              .onClick(() => {
                this.onInputValue(item.value)
              })
          }
          .rowStart(index)
          .rowEnd(index === 2 ? index + 1 : index)
          .columnStart(4)
          .columnEnd(4)
        })

        ForEach(obtainImgLevel(), (item) => {
          ForEach(item, (item) => {
            GridItem() {
              Image(item.Img)
                .margin({ top: 5 })
                .onClick(() => {
                  this.onInputValue(item.value)
                })
            }
          })
        })

        ForEach(obtainImgL(), (item, index) => {
          GridItem() {
            Image(item.Img)
              .margin({ top: 5 })
              .onClick(() => {
                this.onInputValue(item.value)
              })
          }
          .rowStart(4)
          .rowEnd(4)
          .columnStart(index)
          .columnEnd(index === 0 ? index + 1 : index)
        })
      }
      .width('80%')
      .columnsGap(10)
      .rowsGap(10)
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr')
    }
    .padding(10)
    .size({ width: '55%', height: '90%' })
  }
}