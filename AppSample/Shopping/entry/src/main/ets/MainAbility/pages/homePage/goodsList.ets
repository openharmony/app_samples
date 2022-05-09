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

import { ProductDataModel } from '../../model/homeModel'
import { productData } from '../../data/homeData'

@Component
export struct GoodsList {
  @State data: any = ''
  @State productData: Array<ProductDataModel> = productData
  @Link ListIndex: number
  @Link ratio: number
  @State GridIndex: number = 0
  @State save: number = 0
  @State move: number = 0

  aboutToAppear() {
    class MyDataSource implements IDataSource {
      totalCount(): number {
        return this.num
      }

      getData(index: number): any {
        return index
      }

      registerDataChangeListener(listener: DataChangeListener) {
        if (this.listeners.indexOf(listener) < 0) {
          this.listeners.push(listener)
        }
      }

      unregisterDataChangeListener(listener: DataChangeListener) {
        const pos = this.listeners.indexOf(listener)
        if (pos >= 0) {
          this.listeners.splice(pos, 1)
        }
      }

      num: number = 5040
      listeners: DataChangeListener[] = []
    }

    this.data = new MyDataSource()
  }

  build() {
    Column() {
      Grid() {
        LazyForEach(this.data, item => {
          GridItem() {
            Column() {
              Image(this.productData[item % 14].uri)
                .width('100%')
                .height('40%')
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 40 })
              Text(this.productData[item % 14].title)
                .fontSize(16 * this.ratio)
                .fontWeight(600)
                .margin({ bottom: 10, left: 10 })
              Row() {
                Text(this.productData[item % 14].labels)
                  .fontSize(10 * this.ratio)
                  .border({ width: 1, color: '#FA808080' })
                  .margin({ bottom: 2, left: 10 })
                  .padding(2)
              }
              .margin({ bottom: 2 })

              Text(`￥${item + 1}`)
                .fontSize(16 * this.ratio)
                .fontColor(Color.Red)
                .margin({ left: 10 })
            }
            .alignItems(HorizontalAlign.Start)
          }
          .width('95%')
          .height(300)
          .border({ width: 1, color: '#70808080', radius: 10 })
          .margin({ top: 3, bottom: 3 })
          .backgroundColor(Color.White)
        }, item => item.toString())
      }
      .columnsTemplate('1fr 1fr')
      .padding({ bottom: 60 })
      .onScrollIndex((e) => {
        this.GridIndex = Number(e)
      })
    }
    .width('100%')
    .backgroundColor('#10000000')
  }
}