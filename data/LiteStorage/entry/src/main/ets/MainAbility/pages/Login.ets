/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import { Goods } from '../common/goods'
import { ShoppingCart } from '../common/shopcart'
import { Good, GoodInit, getShopCartFromStorage, getShopCart } from '../model/product'

@Entry
@Component
struct Shopping {
  private goodsList: Array<Good>
  @State cartNum: number = 0
  @State show: boolean = false
  @State editFlag: boolean = false

  aboutToAppear() {
    getShopCartFromStorage()
    this.goodsList = GoodInit()
    console.info('goodsList:' + this.goodsList.length)
    setTimeout(() => {
      this.cartNum = getShopCart().length
    }, 500)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Row() {
          Text('eTSLiteStorage')
            .textAlign(TextAlign.Start)
            .layoutWeight(7)
            .fontSize(30)
            .fontColor(Color.White)
            .padding({ left: 10, top: 10 })

          Badge({
            count: this.cartNum,
            maxCount: 5,
            position: 0,
            style: { color: Color.Black, fontSize: 16, badgeSize: 20, badgeColor: Color.Red }
          }) {
            Button('message') {
              if (this.cartNum >= 5) {
                Image($r('app.media.cartfull')).width(40).height(40)
              } else {
                Image($r('app.media.cartnone')).width(40).height(40)
              }
            }
            .onClick(() => {
              this.show = !this.show
            })
            .backgroundColor('#0D9FFB')
            .width(50)
          }
          .height(50)
          .margin({ top: 10, right: 5 })
          .layoutWeight(2)
        }.width('100%')
        .height(50)
        .backgroundColor('#0D9FFB')

        Grid() {
          ForEach(this.goodsList, item => {
            GridItem() {
              Goods({ good: item, cartNum: $cartNum })
            }
          }, item => item.name)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .padding(10)
        .margin({ bottom: 50 })
      }.height('100%')

      if (this.show) {
        ShoppingCart({ cartNum: $cartNum, show: $show })
      }
    }.width('100%').height('100%').backgroundColor(0xFFFFFF)
  }
}
