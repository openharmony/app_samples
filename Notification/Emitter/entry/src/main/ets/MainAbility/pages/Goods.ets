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
import emitter from '@ohos.events.emitter'
import { CustomText }  from '../common/CustomText'
import { getData } from '../model/Good'
import { Good } from '../model/Good'

const TAG = `[eTSEmitter.Goods]`

@Entry
@Component
struct Goods {
  @State arrInfo: Array<Good> = getData()

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Text($r('app.string.event_notification'))
        .width('100%')
        .height('9%')
        .fontSize(25)
        .fontColor('#FFFFFF')
        .backgroundColor('#0D9FFB')
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)
      Stack({ alignContent: Alignment.TopStart }) {
        Column() {
          List({ space: 20, initialIndex: 0 }) {
            ForEach(this.arrInfo, (item, index) => {
              ListItem() {
                Row() {
                  Column() {
                    Image(item.image)
                      .width('90%')
                      .margin({ left: 10 })
                      .objectFit(ImageFit.Contain)
                  }
                  .width('30%')

                  Column() {
                    CustomText({ name: 'product_name', nameContent: item.name, color: '#000000' })
                    CustomText({ name: 'price', nameContent: item.price, color: '#DA121C' })
                  }
                  .width('50%')
                  .margin({ left: -10 })

                  Column() {
                    Toggle({ type: ToggleType.Checkbox, isOn: item.isCheck })
                      .size({ width: 28, height: 28 })
                      .selectedColor(0xed6f21)
                      .onChange((isOn: boolean) => {
                        item.isCheck = isOn
                        this.arrInfo[index].isCheck = isOn
                        var innerEvent = { eventId: 1001 }
                        var eventData = {
                          data: {
                            'isAdd': isOn,
                            'index': index
                          }
                        }
                        console.log(`${TAG} emit eventData.data= ${JSON.stringify(eventData.data)}`)
                        emitter.emit(innerEvent, eventData)
                      })
                  }
                  .width('10%')
                }
              }
              .height('15%')
              .editable(true)
            })
          }
          .width('100%')
          .layoutWeight(1)
          .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 })

          Row() {
            Button() {
              Text($r('app.string.submit'))
                .textAlign(TextAlign.Center)
                .width('60%')
                .fontSize(25)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
            }
            .width('30%')
            .type(ButtonType.Capsule)
            .backgroundColor('#E65608')
            .onClick(() => {
              router.back()
            })
          }
        }
      }
      .width('100%')
      .height('91%')
      .padding({ top: 5 })
      .backgroundColor(0xDCDCDC)
    }
  }
}