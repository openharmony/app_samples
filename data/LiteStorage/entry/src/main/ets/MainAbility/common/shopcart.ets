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

import {Good, deleteGood, clearGoodShop, getShopCart} from '../model/product'

@Component
export struct ShoppingCart {
  @State editFlag: boolean= false
  @Link cartNum: number
  @State shopList: Array<Good> = getShopCart()
  @State priceCount: number = 0
  @Link show: boolean

  aboutToAppear() {
    this.cartNum = this.shopList.length
    this.getPriceCount()
  }

  getPriceCount() {
    console.info('getPriceCount')
    this.priceCount = 0
    for (let i = 0;i < this.shopList.length; i++) {
      this.priceCount += this.shopList[i].price
    }
  }

  build() {
    Column() {
      Image($r('app.media.close'))
        .width(40)
        .objectFit(ImageFit.ScaleDown)
        .alignSelf(ItemAlign.Start)
        .margin({ left: 5, top: 5 })
        .onClick(() => {
          this.show = !this.show
        })

      Row() {
        Text($r("app.string.myCarshopping"))
          .width('100%')
          .fontSize(25)
          .layoutWeight(3)
          .textAlign(TextAlign.Center)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
        Text($r("app.string.deleteGoods"))
          .fontSize(18)
          .layoutWeight(2)
          .textAlign(TextAlign.Center)
          .fontColor('#0D9FFB')
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.editFlag = !this.editFlag
          })
        Text($r("app.string.clearGoods"))
          .fontSize(18)
          .layoutWeight(2)
          .textAlign(TextAlign.Center)
          .fontColor('#0D9FFB')
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.cartNum = 0
            this.priceCount = 0
            this.shopList = []
            this.show = false
            this.show = true
            clearGoodShop()
          })
      }.width('100%').height(35)

      List() {
        ForEach(this.shopList, item => {
          ListItem() {
            Row() {
              Text(item.name)
                .width('50%')
                .fontSize(18)
                .textAlign(TextAlign.Center)
              Text('￥' + item.price)
                .width('50%')
                .fontSize(18)
                .textAlign(TextAlign.Center)
                .fontColor(Color.Red)
            }
          }.editable(true)
        }, item => item.name)
      }
      .padding({ right: 10 })
      .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
      .editMode(this.editFlag)
      .onItemDelete((index: number) => {
        deleteGood(this.shopList[index])
        this.shopList = getShopCart()
        this.cartNum--
        this.getPriceCount()
        this.editFlag = false
        return true
      })
      .width('100%')
      .height(85)

      Row() {
        Text($r("app.string.totalPrice"))
          .width('50%')
          .fontSize(16)
          .textAlign(TextAlign.Center)
        Text('￥' + this.priceCount)
          .width('50%')
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontColor(Color.Red)
      }.height(35)
    }.width('90%').height(200)
    .backgroundColor(Color.White)
    .border({ width: 2, radius: 10, color: Color.Black })
  }
}