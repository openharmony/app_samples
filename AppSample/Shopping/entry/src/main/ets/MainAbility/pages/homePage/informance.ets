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

import { InformationModel } from '../../model/homeModel'
import { informationData } from '../../data/homeData'

@Component
export struct Information {
  @State information: Array<InformationModel> = informationData
  @Prop ratio: number

  build() {
    Column() {
      Column() {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text('消息')
            .fontSize(20 * this.ratio)
            .fontWeight(FontWeight.Bolder)
          Row() {
            Image('/resources/icon/smile.png')
              .width(25 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
            Image('/resources/icon/smile.png')
              .width(25 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
              .margin({ left: 20 })
          }
        }
        .padding({ left: 10, right: 10 })
        .margin({ top: 10, bottom: 10 })
      }
      .backgroundColor('#dfe5e3')

      Flex({ justifyContent: FlexAlign.Center }) {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('@')
                .fontSize(15 * this.ratio)
                .fontColor('#40000000')
              Image('/resources/icon/ring.png')
                .width(20 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
              Image('/resources/icon/ring.png')
                .width(20 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
              Image('/resources/icon/ring.png')
                .width(20 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
            }
            .width('40%')

            Image('/resources/icon/more.png')
              .width(20 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }
          .margin({ bottom: 10 })

          Grid() {
            ForEach(this.information, item => {
              GridItem() {
                Flex({ alignItems: ItemAlign.Center }) {
                  Column() {
                    Image(item.uri)
                      .width(55 * this.ratio)
                      .aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                      .border({ radius: 30 })
                  }

                  Column() {
                    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                      Text(item.title)
                        .fontSize(14 * this.ratio)
                      Text(item.time)
                        .fontSize(13 * this.ratio)
                        .fontColor(Color.Gray)
                    }

                    Text(item.notice)
                      .fontSize(13 * this.ratio)
                      .fontColor(Color.Grey)
                      .margin({ top: 5, bottom: 10 })
                    Divider()
                      .strokeWidth(1)
                      .color('#10000000')
                      .margin({ top: 5 })
                  }
                  .padding({ left: 10, top: 10, bottom: 10 })
                  .alignItems(HorizontalAlign.Start)
                }
              }
            }, item => item.toString())
          }
          .columnsTemplate('1fr')
        }
        .padding(10)
        .backgroundColor(Color.White)
      }
      .width('100%')
    }
    .width('100%')
  }
}