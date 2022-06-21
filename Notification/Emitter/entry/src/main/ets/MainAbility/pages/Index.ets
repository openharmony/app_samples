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

import router from '@ohos.router';
import emitter from '@ohos.events.emitter';
import { CustomText }  from '../common/CustomText'
import { getData } from '../model/Good'
import { Good } from '../model/Good'

const TAG = `[eTSEmitter.Index]`

@Entry
@Component
struct Index {
  @State enabled: boolean = true
  @State color: string = '#EF5B0C'
  @State productArr: Array<Good> = getData()
  @State indexArr: Array<unknown> = []

  onProductAdd(eventData) {
    console.log(`${TAG} eventData= ${JSON.stringify(eventData)}`)
    let index = eventData.data.index
    if (eventData.data.isAdd) {
      this.indexArr.push(this.productArr[index])
    }
    console.log(`${TAG} onProductAdd indexArr= ${JSON.stringify(this.indexArr)}`)
  }

  aboutToAppear() {
    var innerEvent = { eventId: 1001 }
    emitter.on(innerEvent, this.onProductAdd.bind(this))
    console.log(`${TAG} indexArr= ${JSON.stringify(this.indexArr)}`)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Row() {
        Text($r('app.string.event_notification'))
          .width('70%')
          .fontSize(25)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
        Text($r('app.string.enter_mall'))
          .width('30%')
          .textAlign(TextAlign.End)
          .fontSize(25)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.push({
              url: 'pages/Goods',
              params: this.productArr
            })
          })
      }
      .backgroundColor('#0D9FFB')
      .width('100%')
      .height('9%')
      .padding({ left: 15, right: 15 })

      Text($r('app.string.my_order'))
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.indexArr, (item, index) => {
          ListItem() {
            Column() {
              Row() {
                Column() {
                  Image(item.image)
                    .width('90%')
                    .margin({ left: 10 })
                    .objectFit(ImageFit.Contain)
                }
                .width('40%')

                Column() {
                  CustomText({
                    name: 'product_name',
                    nameContent: item.name,
                    color: '#000000'
                  })
                  CustomText({
                    name: 'price',
                    nameContent: item.price,
                    color: '#DA121C' })
                }
                .width('50%')
                .margin({ left: -10 })
              }
            }
            .padding({ bottom: 24 })
            .height('22%')
          }
        }, item => item.name)
      }
      .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 15, endMargin: 15 })
      .layoutWeight(1)
    }
  }
}