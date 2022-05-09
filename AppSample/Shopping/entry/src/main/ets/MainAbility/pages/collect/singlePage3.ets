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

let obj3 = {
  src: '/resources/detailImg/swiper/swiper1.png',
  name: '【首降600+12期免息】XX/XXMate 40 Pro 5G 全网通 （亮黑色） 超大内存 极快网速 全球n多人的选择，你值得拥有',
  collect: '300+人收藏',
  price: '￥4500',
  collected: true
}

@Component
export struct SinglePage3 {
  @Prop ratio: number
  @State collectData: any = {}

  async aboutToAppear() {
    this.collectData = obj3
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Flex({ alignItems: ItemAlign.Center }) {
            Text('宝贝状态')
              .fontSize(12 * this.ratio)
            Image('/resources/icon/sort-down.png')
              .width(10)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }

          Flex({ alignItems: ItemAlign.Center }) {
            Text('收藏时间')
              .fontSize(12 * this.ratio)
            Image('/resources/icon/sort-down.png')
              .width(10)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }

          Flex({ alignItems: ItemAlign.Center }) {
            Text('运动出行')
              .fontSize(12 * this.ratio)
            Image('/resources/icon/sort-down.png')
              .width(10)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }
        }
        .width('75%')
      }
      .backgroundColor(Color.White)
      .border({ radius: 5 })
      .padding(10)

      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Image(this.collectData.src)
          .width('32%')
          .height('16%')
          .objectFit(ImageFit.Contain)
          .border({ radius: 10 })
      }
      .margin({ top: 10 })
    }
  }
}