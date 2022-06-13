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
import { Good, deleteGood, clearGoodShop, GoodInit, getShopCartFromStorage, getShopCart } from '../model/product'

@CustomDialog
struct CartDialog {
  @State priceCount: number = 0
  @State editFlag: boolean = false
  @State shopList: Array<Good> = getShopCart()
  private controller: CustomDialogController
  @State cartNum: number = getShopCart().length
  private action: (cartNum: number) => void
  onCancel = () => {
    this.controller.close()
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
        .height(40)
        .objectFit(ImageFit.ScaleDown)
        .alignSelf(ItemAlign.Start)
        .margin({ left: 5, top: 5 })
        .onClick(() => {
          this.onCancel()
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
            clearGoodShop()
            this.action(this.cartNum)
          })
      }.width('100%').height(35)

      List() {
        ForEach(this.shopList, (item, index) => {
          ListItem() {
            Row() {
              if (this.editFlag) {
                Image($r('app.media.delete'))
                  .width(20)
                  .height(20)
                  .margin({ left: 20 })
                  .objectFit(ImageFit.Fill)
                  .onClick(() => {
                    deleteGood(this.shopList[index])
                    this.shopList = getShopCart()
                    this.cartNum--
                    this.getPriceCount()
                    this.editFlag = false
                    this.action(this.cartNum)
                  })
              }
              Text(item.name)
                .width('50%')
                .fontSize(18)
                .textAlign(TextAlign.Center)
              Text('￥' + item.price)
                .width('40%')
                .fontSize(18)
                .fontColor(Color.Red)
                .textAlign(TextAlign.Center)
            }.margin({ top: 30 })
          }.editable(true)
        }, item => JSON.stringify(item))
      }
      .height(285)
      .width('100%')
      .editMode(false)
      .padding({ right: 10 })
      .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果

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
    }
    .width('90%')
    .height(400)
  }
}


@Entry
@Component
struct Shopping {
  private goodsList: Array<Good>
  @State cartNum: number = 0
  @State editFlag: boolean = false
  private dialogController: CustomDialogController = undefined

  existApp() {
    console.info('Click the callback in the blank area')
  }

  aboutToAppear() {
    getShopCartFromStorage()
    this.goodsList = GoodInit()
    console.info('goodsList:' + this.goodsList.length)
    setTimeout(() => {
      this.cartNum = getShopCart().length
    }, 500)
  }

  cartDialog(cartNum: number) {
    this.cartNum = cartNum
  }

  build() {
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
            Image(this.cartNum >= 5 ? $r('app.media.cartfull') : $r('app.media.cartnone')).width(40).height(40)
          }
          .onClick(() => {
            this.dialogController = new CustomDialogController({
              builder: CartDialog({ action: this.cartDialog.bind(this) }),
              cancel: this.existApp,
              autoCancel: true
            })
            this.dialogController.open()
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
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xFFFFFF)

  }
}
