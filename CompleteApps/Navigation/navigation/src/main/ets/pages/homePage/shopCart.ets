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

import { Cart } from '../../components/shopcart/cart'
import { FavorGoodList } from '../../components/shopcart/favorGoodlist'

@Preview
@Component
export struct ShopCart {
  @Prop ratio: number
  @Prop isLand: boolean
  private url: string
  private option: object

  build() {
    Column() {
      List({ space: 10 }) {
        ListItem() {
          Column() {
            Row() {
              Text($r('app.string.shop_cart'))
                .fontSize('32fp')
                .fontColor('#000000')
                .fontFamily('HarmonyHeiTi')

              Blank()

              Text($r('app.string.edit'))
                .fontSize('20fp')
                .fontFamily('HarmonyHeiTi')
                .fontColor('#000000')
                .opacity(0.6)
            }
            .width('100%')
            .margin({ top: '2.5%', bottom: '1.5%' })

            Cart({ ratio: this.ratio })
          }
          .width('100%')
          .padding(8)
          .backgroundColor('#F1F3F5')
        }

        ListItem() {
          Column() {
            Text($r('app.string.guess_you_like'))
              .width('100%')
              .fontSize('20fp')
              .fontColor('#000000')
              .padding({ left: 12 })
              .margin({ top: 10, bottom: 4 })
            FavorGoodList({ isLand: this.isLand, ratio: this.ratio, url: this.url })
          }
          .width('100%')
        }
      }
      .layoutWeight(1)

      Divider()
        .color('#ffa9a9a9')
        .width(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3.3%', right: '3.3%' })
  }
}