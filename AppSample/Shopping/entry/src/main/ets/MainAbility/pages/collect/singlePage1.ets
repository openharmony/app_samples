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

let obj1 = {
  src: '/resources/detailImg/swiper/swiper1.png',
  name: '【首降600+12期免息】XX/XXMate 40 Pro 5G 全网通 （亮黑色） 超大内存 极快网速 全球n多人的选择，你值得拥有',
  collect: '300+人收藏',
  price: '￥4500',
  collected: true
}

@Component
export struct SinglePage1 {
  @Prop ratio: number
  @State collectData: any = {}
  @State collected: boolean = false

  async aboutToAppear() {
    this.collectData = obj1
    this.collected = obj1.collected
  }

  build() {
    Column() {
      if (this.collected) {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Flex({ alignItems: ItemAlign.Center }) {
              Text('宝贝状态')
                .fontSize(13 * this.ratio)
              Image('/resources/icon/sort-down.png')
                .width(10)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
            }

            Flex({ alignItems: ItemAlign.Center }) {
              Text('收藏时间')
                .fontSize(13 * this.ratio)
              Image('/resources/icon/sort-down.png')
                .width(10)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
            }

            Flex({ alignItems: ItemAlign.Center }) {
              Text('运动出行')
                .fontSize(13 * this.ratio)
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

        Column() {
          Row() {
            Image(this.collectData.src)
              .width('40%')
              .height('100%')
              .objectFit(ImageFit.Contain)
              .border({ radius: 10 * this.ratio })
            Row() {
              Column() {
                Text(this.collectData.name)
                  .fontSize(15 * this.ratio)
                  .fontWeight(FontWeight.Bolder)
                  .lineHeight(25 * this.ratio)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('55%')
                Text(this.collectData.collect)
                  .fontSize(13 * this.ratio)
                  .margin({ top: 10 })
                Text(this.collectData.price)
                  .fontSize(15 * this.ratio)
                  .fontWeight(FontWeight.Bolder)
                  .fontColor(Color.Red)
                  .margin({ top: 5 })
              }
              .margin({ left: 10 })
              .padding({ right: 2 })
              .alignItems(HorizontalAlign.Start)
            }
            .alignItems(VerticalAlign.Top)
            .height('100%')
          }
          .padding({ left: 10, right: 10 })
          .backgroundColor(Color.White)
          .border({ radius: 10 * this.ratio })
        }
        .margin({ top: 10 })
        .height('20%')
        .width('100%')
      }
    }
  }
}