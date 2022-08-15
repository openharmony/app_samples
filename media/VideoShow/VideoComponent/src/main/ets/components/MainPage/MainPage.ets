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
import mediaQuery from '@ohos.mediaquery';
import { VideoPage } from "./Videopage"
import { smallVideo } from "./SmallVideo"

@Entry
@Component
export struct MainPage {
  private arrScroll: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  private arrSwiper: number[] = [0, 1, 2, 3]
  @State isHidden: boolean = false
  @State @Watch("onScrollUpdated") scrollSum: number = 0
  @State isState: boolean = true
  @State isCancel: boolean = true
  @State activeVideo: number = 0
  @State openFirst: boolean = false
  @Provide('playTime') playNum: number = 20
  @State isPhone: boolean = false
  portraitFunc = null
  listenerIsPhone = mediaQuery.matchMediaSync('(orientation:landscape)');

  onPortrait(mediaQueryResult) {
    this.isPhone = !mediaQueryResult.matches
  }

  async aboutToAppear() {
    this.portraitFunc = this.onPortrait.bind(this) // bind current js instance
    this.listenerIsPhone.on('change', this.portraitFunc)
  }

  onScrollUpdated(): void { // 监听Scroll下滑距离
    if (this.isCancel) { // 判断视频右上角的X，如果点过，不再出现小窗口
      this.isDistance(this.scrollSum)
    }
  }

  isDistance(scrollUpdated) {
    if (this.activeVideo === 0) { // 判断是否是swiper第一页
      if (this.openFirst) { // 判断主视频是否开始播放，如果没开始播放，则不出现小窗口
        if (scrollUpdated > 500) { // 判断下滑距离
          if (this.isState) { // 控制小窗口不再重复刷新
            this.isHidden = true
            this.isState = false
          }
        } else { // 符合开启情况下，回到500以内可以再次触发
          this.isHidden = false
          this.isState = true
        }
      }
    }
  }

  build() {
    Column() {
      Stack() {
        Scroll() {
          Column() {
            Swiper() {
              VideoPage({ isStart: $openFirst })
              // 模拟Swiper数据
              ForEach(this.arrSwiper, (item) => {
                Text(item.toString())
                  .width('100%')
                  .aspectRatio(1.12)
                  .backgroundColor(0xAFEEEE)
                  .textAlign(TextAlign.Center)
                  .fontSize(20)
              }, item => item)
            }
            .width('100%')
            .aspectRatio(this.isPhone ? 1.12 : 3.5)
            .backgroundColor('#ffffff')
            .height(250)
            .indicator(false)
            .onChange((index: number) => {
              this.activeVideo = index
            })
            // 模拟scroll数据
            ForEach(this.arrScroll, (item) => {
              Text(item.toString())
                .width('90%')
                .height(150)
                .backgroundColor(0xFFFFFF)
                .borderRadius(15)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .margin({ top: 10 })
            }, item => item)
          }
          .width('100%')
          .backgroundColor('#F1F3F5')
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Vertical)
        .scrollBarColor(Color.Gray)
        .scrollBarWidth(30)
        .onScroll((xOffset: number, yOffset: number) => {
          this.scrollSum += yOffset
        })

        // 视频小窗口
        Column() {
          smallVideo({ isHidden: $isHidden, isCancel: $isCancel })
        }
        .position({ x: '64%', y: '42%' })

        // 直播按键
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Image($r('app.media.broadcast'))
            .objectFit(ImageFit.Contain)
            .width('24')
            .height('24')
            .margin({ top: 10 })
          Text($r("app.string.in_live"))
            .fontSize(10)
            .fontColor('#000000')
            .margin({ top: 5 })
        }
        .width(58)
        .height(58)
        .backgroundColor('#FFFFFF')
        .border({ color: 'rgba(0,0,0,0.2)' })
        .borderRadius(16)
        .borderWidth(1.3)
        .onClick(() => {
          router.push({ url: 'pages/LivePage' })
        })
        .position({ x: '86%', y: '20%' })
      }.width('100%').height('100%').backgroundColor(0xDCDCDC)

    }
  }
}
