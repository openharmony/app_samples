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

import { ShopCartItemDataModel } from '../../model/homeModel'
import { shopCartItemData } from '../../data/homeData'

@Component
export struct Other {
  @State shopCartItem: Array<ShopCartItemDataModel> = shopCartItemData
  @Prop item: number
  @Prop ratio: number

  build() {
    Column() {
      Image(this.shopCartItem[this.item].img)
        .width('95%')
        .aspectRatio(0.8)
        .objectFit(ImageFit.Contain)
      Text(this.shopCartItem[this.item].title)
        .fontSize(14 * this.ratio)
        .lineHeight(25 * this.ratio)
        .maxLines(2)
        .padding({ left: 10, right: 10 })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
        Row() {
          Text() {
            Span('￥')
              .fontSize(10 * this.ratio)
              .fontColor(Color.Red)
            Span(`${Math.floor(Math.random() * 10000)}`)
              .fontSize(17 * this.ratio)
              .fontColor(Color.Red)
          }

          Text(`${Math.floor(Math.random() * 1000)}人付款`)
            .fontSize(10 * this.ratio)
            .fontColor(Color.Grey)
            .margin({ left: 5 })
        }

        Image('/resources/icon/more.png')
          .width('10%')
          .aspectRatio(1)
          .margin({ left: 5 })
      }
      .margin({ top: 5, bottom: 10 })
    }
    .width('50%')
    .margin({ bottom: 10 })
    .alignItems(HorizontalAlign.Start)
    .border({ radius: 10 })
    .backgroundColor(Color.White)
  }
}