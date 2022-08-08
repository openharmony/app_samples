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

import { SwiperModel } from '../../model/homeModel'
import { indexData } from '../../data/homeData'

@Component
export struct SwiperComponent {
  @State swiperData: Array<SwiperModel> = indexData
  @Prop ratio: number

  build() {
    Column() {
      Swiper() {
        ForEach(this.swiperData, item => {
          Navigator({ target: '' }) {
            Flex({ justifyContent: FlexAlign.Center }) {
              Image(item.img)
                .objectFit(ImageFit.Fill)
                .border({ radius: 10 * this.ratio })
            }
          }
          .clip(true)
          .params({ ratio: this.ratio })
          .border({ radius: 10 * this.ratio })
        }, item => item.toString())
      }
      .margin(2)
      .loop(true)
      .autoPlay(true)
      .indicator(true)
      .borderRadius(10)
      .margin({ right: 16, left: 16 })
      .indicatorStyle({ selectedColor: 'red', color: '#FFFFFF' })
    }
  }
}