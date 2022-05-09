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

import { BoutiqueModel } from '../../model/homeModel'
import { boutiqueData } from '../../data/homeData'

@Component
export struct Boutique {
  @State boutiqueData: Array<BoutiqueModel> = boutiqueData
  @Prop ratio: number

  build() {
    Column() {
      Flex({ wrap: FlexWrap.Wrap, direction: FlexDirection.Row }) {
        ForEach(this.boutiqueData, item => {
          Column() {
            Text(item.text1)
              .fontSize(15 * this.ratio)
              .fontWeight(item.text2)
            Text(item.text2)
              .fontSize(15 * this.ratio)
              .margin(5)
            Row() {
              Image(item.img1)
                .width('45%')
                .aspectRatio(0.8)
                .objectFit(ImageFit.Contain)
              Image(item.img2)
                .width('45%')
                .aspectRatio(0.8)
                .objectFit(ImageFit.Contain)
            }
            .width('100%')
          }
          .width('50%')
          .alignItems(HorizontalAlign.Start)
        }, item => item.toString())
      }
    }
    .width('92%')
  }
}