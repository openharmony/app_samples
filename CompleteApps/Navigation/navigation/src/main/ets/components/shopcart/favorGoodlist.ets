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
import { shopCartItemData } from '../../data/homedata'
import router from '@ohos.router'
import Logger from '../../model/Logger'
import Http from '@ohos/http'

const TAG: string = 'FavorGoodList'

class GoodResponse {
  code: number
  data: Records
  error: string
}

class Records {
  records: Array<Info>
  totalCount: number
}

class Info {
  id: number
  uri: string
  title: string
  info: string
  labels: string
  price: number
}

@Component
export struct FavorGoodList {
  @Prop ratio: number
  @Prop isLand: boolean
  @State shopCartItem: Array<ShopCartItemDataModel> = shopCartItemData
  @State flag: boolean = false
  @State mColumn: number[] = [1, 2]
  private url: string
  private option: object
  @State productsData: GoodResponse = {
    code: 0,
    data: {
      records: [{
                  id: -1,
                  uri: '',
                  title: '',
                  info: '',
                  labels: '',
                  price: -1
                }],
      totalCount: -1
    },
    error: null
  }

  async aboutToAppear() {
    if (this.isLand) {
      this.mColumn = [1, 2, 3]
    }
    Http.setUrl(this.url)
    Http.setOptions(this.option)
    this.flag = false
    let info = await Http.request()
    if (info.responseCode === 200) {
      this.flag = true
      this.productsData = JSON.parse(info.result.toString())
      Logger.info(TAG, `productsData = ${JSON.stringify(this.productsData)}`)
    }
  }

  @Builder GoodItem(shopItem: ShopCartItemDataModel) {
    Column() {
      Image(shopItem.uri)
        .width('65%')
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)
        .margin({ top: '2.5%', bottom: '2.5%', left: '13.6%', right: '13.6%' })

      Column() {
        Text(shopItem.title)
          .width('100%')
          .fontSize(18)
          .margin({ bottom: '5vp' })
        Text(shopItem.price)
          .fontColor('#E92F4F')
          .fontSize(20)
          .margin({ top: 10 })
        Column() {
          Text(shopItem.labels)
            .fontSize(14)
            .fontColor('#FFFFFF')
        }
        .borderRadius(5)
        .padding({ left: 6, right: 6, top: 4, bottom: 4 })
        .margin({ top: 10, bottom: 16 })
        .backgroundColor('#E92F4F')
      }
      .margin(8)
      .width('88%')
      .alignItems(HorizontalAlign.Start)
    }
    .margin(8)
    .width('100%')
    .borderRadius(10)
    .padding({ top: '1.5%', bottom: '1.5%' })
    .backgroundColor(Color.White)
    .onClick(() => {
      router.push({
        url: 'pages/detail',
        params: { goodId: shopItem.id, goodItem: shopItem }
      })
    })
  }

  build() {
    Row() {
      ForEach(this.mColumn, (item, index) => {
        Column() {
          ForEach(this.flag ? this.productsData.data.records : this.shopCartItem, (shopItem, shopIndex) => {
            if (shopIndex % this.mColumn.length === index) {
              this.GoodItem(shopItem)
            }
          }, item => item.toString())
        }
        .margin(8)
        .layoutWeight(1)
      }, item => item.toString())
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
  }
}