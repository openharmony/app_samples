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
  @Prop isLand: boolean

  build() {
    Column() {
      Swiper() {
        ForEach(this.swiperData, item => {
          Navigator({ target: '' }) {
            Flex({ justifyContent: FlexAlign.Center }) {
              Image(item.img)
                .objectFit(ImageFit.Fill)
                .border({ radius: 20 * this.ratio })
            }
          }
          .clip(true)
          .params({ ratio: this.ratio })
          .border({ radius: 20 * this.ratio })
          .margin({ right: this.isLand ? '5vp' : 0, left: this.isLand ? '5vp' : 0 })
          .width(this.isLand ? '48%' : '100%')
        }, item => item.toString())
      }
      .margin(2)
      .loop(this.isLand ? false : true)
      .autoPlay(this.isLand ? false : true)
      .indicator(this.isLand ? false : true)
      .disableSwipe(this.isLand ? true : false)
      .borderRadius(10)
      .padding({ left: 1, right: 1 })
      .margin({ right: this.isLand ? '1%' : 16, left: this.isLand ? '2.5%' : 16 })
      .indicatorStyle({ selectedColor: 'red', color: '#FFFFFF' })
      .displayMode(this.isLand ? SwiperDisplayMode.AutoLinear : SwiperDisplayMode.Stretch)
    }
  }
}