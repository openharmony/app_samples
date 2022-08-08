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
import { SearchTextModel } from '../../model/homeModel'
import { findSearchTextData } from '../../data/homeData'

@Component
export struct TitleBarComponent {
  @State searchData: Array<SearchTextModel> = findSearchTextData
  @Prop ratio: number

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Image($r('app.media.logo'))
            .width('7%')
            .objectFit(ImageFit.Contain)
          Image($r('app.media.scan'))
            .width('7%')
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.push({
                url: 'pages/scanPage',
              })
            })
        }
        .height('5%')
        .width('100%')
        .margin({ bottom: 16, top: 10 })

        Flex({ alignItems: ItemAlign.Center }) {
          Image($r('app.media.search'))
            .objectFit(ImageFit.Contain)
            .width(20 * (this.ratio + 0.2))
            .margin({ left: '12vp', right: '8vp' })
          Swiper() {
            ForEach(this.searchData, item => {
              Column() {
                Text(item.searchText)
                  .opacity(0.6)
                  .fontColor('#000000')
                  .fontSize(18 * this.ratio)
                  .fontFamily('HarmonyHeiTi')
                  .lineHeight(23 * (this.ratio + 0.2))
              }
              .width('100%')
              .height(25 * (this.ratio + 0.2))
              .alignItems(HorizontalAlign.Start)
              .onClick(() => {
                router.push({
                  url: '',
                  params: {
                    message: item.searchText,
                    ratio: this.ratio
                  }
                })
              })
            }, item => item.toString())
          }
          .loop(true)
          .width('65%')
          .autoPlay(true)
          .vertical(true)
          .indicator(false)
          .interval(2000)
        }
        .zIndex(2)
        .height('7.2%')
        .margin({ bottom: '12vp' })
        .backgroundColor('#ffffffff')
        .border({ width: 2, color: Color.White, radius: '40vp' })
      }
      .margin({ top: '10vp' })
      .padding({ left: '3.3%', right: '3.3%' })
    }
    .width('100%')
  }
}