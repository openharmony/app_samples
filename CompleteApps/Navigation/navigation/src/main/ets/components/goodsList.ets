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

import router from '@ohos.router'
import { ProductDataModel } from '../model/homeModel'
import { productData } from '../data/homeData'
import Http from '@ohos/http'
import Logger from '../model/Logger'

const TAG: string = 'GoodsList'

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
export struct GoodsList {
  @Prop isLand: boolean
  @State productData: Array<any> = productData
  @State flag: boolean = false
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
  @Prop ratio: number

  async aboutToAppear() {
    Http.setUrl(this.url)
    Http.setOptions(this.option)
    Logger.info(TAG, `this url is ${Http.url}`)
    this.flag = false
    let info = await Http.request()
    if (info.responseCode === 200 && info.result !== undefined) {
      this.flag = true
      this.productsData = JSON.parse(info.result.toString())
      Logger.info(TAG, `productsData = ${JSON.stringify(this.productsData)}`)
    }
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.flag ? this.productsData.data.records : this.productData, item => {
          GridItem() {
            Column() {
              Image(item.uri)
                .width('65%')
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ top: '2.5%', bottom: '2.5%', left: '13.6%', right: '13.6%' })

              Column() {
                Text(item.title)
                  .width('100%')
                  .fontSize(18)
                  .margin({ bottom: '5vp' })

                Text(item.info)
                  .width('100%')
                  .fontSize(18)

                Text(item.price)
                  .fontColor('#E92F4F')
                  .fontSize(20)
                  .margin({ top: 10 })

                Column() {
                  Text(item.labels)
                    .fontSize(14)
                    .fontColor('#FFFFFF')
                }
                .borderRadius(5)
                .padding({ left: 6, right: 6, top: 4, bottom: 4 })
                .margin({ top: 10, bottom: 16 })
                .backgroundColor('#E92F4F')
              }
              .width('88%')
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
          }
          .borderRadius(10)
          .margin({ top: 3, left: 3 })
          .padding({ top: '1.5%', bottom: '1.5%', left: '3.3%', right: '3.3%' })
          .backgroundColor(Color.White)
          .onClick(() => {
            router.push({
              url: 'pages/detail',
              params: { goodId: item.id, goodItem: item }
            })
          })
        }, item => item.toString())
      }
      .rowsGap(16)
      .columnsGap(16)
      .columnsTemplate(this.isLand ? '1fr 1fr 1fr' : '1fr 1fr')
    }
    .width('100%')
    .height('100%')
    .margin({ bottom: 20 })
    .backgroundColor('#F1F3F5')
    .padding({ left: '3.3%', right: '3.3%' })
  }
}