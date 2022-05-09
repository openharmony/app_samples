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

import { CoreDataModel } from '../../model/homeModel'
import { coreData } from '../../data/homeData'

@Component
export struct Core1 {
  @Prop ratio: number
  @State cols: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  @State rows: number[] = [0, 1]
  @State coreData: Array<CoreDataModel> = coreData

  build() {
    Column() {
      List() {
        ForEach(this.cols, item1 => {
          ListItem() {
            Grid() {
              ForEach(this.rows, item2 => {
                GridItem() {
                  Column() {
                    Image(`${this.coreData[item1 * 2 + item2].uri}`)
                      .width(40 * this.ratio)
                      .aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                    Text(`${this.coreData[item1 * 2 + item2].title}`)
                      .fontSize(15 * this.ratio)
                      .margin({ top: 5 })
                  }
                }
                .width('100%')
              }, item => item.toString())
            }
            .rowsTemplate('1fr 1fr')
            .columnsTemplate('1fr')
          }
          .width('20%')
        }, item => item.toString())
      }
      .listDirection(Axis.Horizontal)
      .height(160 * this.ratio)
    }
  }
}