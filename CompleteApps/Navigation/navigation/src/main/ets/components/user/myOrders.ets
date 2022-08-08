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

import { OrderModel } from '../../model/homeModel'
import { orderData } from '../../data/homeData'

@Component
export struct MyOrderComponent {
  @State orderData: Array<OrderModel> = orderData
  @Prop ratio: number

  build() {
    Flex({ wrap: FlexWrap.Wrap }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text($r('app.string.orders'))
          .fontSize(20)
        Row() {
          Text($r('app.string.all_order'))
            .fontSize(18)
            .opacity(0.4)
          Image($r('app.media.arrows_right'))
            .width(14 * this.ratio)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
        }
      }
      .padding({ left: '10vp', right: '10vp' })

      Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        ForEach(this.orderData, item => {
          Column() {
            Image(item.img)
              .aspectRatio(1)
              .width(30 * this.ratio)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: '12vp' })
            Text(item.title)
              .fontSize(18)
          }
        }, item => item.toString())
      }
    }
    .margin({ bottom: 2 })
    .padding({ top: '20vp', bottom: '20vp' })
  }
}