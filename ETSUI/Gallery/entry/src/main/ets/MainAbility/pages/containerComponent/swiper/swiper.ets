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
import { NavigationBar } from "../../../common/components/navigationBar"

@Entry
@Component
struct SwiperSample {
  private swiperController: SwiperController = new SwiperController()
  scroller: Scroller = new Scroller()
  @State indicator: boolean = true
  @State autoPlay: boolean = true
  @State loop: boolean = true
  @State vertical: boolean = false
  @State interval: number = 3000
  @State duration: number = 400
  @State itemSpace: number = 0
  @State index: number = 0
  @State cachedCount: number = 1
  @State disableSwipe: boolean = false
  @State arr: Object [] = [
    {
      name: 0,
      color: '#fff000'
    }, {
      name: 1,
      color: '#ff0000'
    }, {
      name: 2,
      color: '#00FF00'
    }, {
      name: 3,
      color: '#A020F0'
    }, {
      name: 4,
      color: '#00FFFF'
    }
  ]

  build() {
    Column() {
      NavigationBar({ title: 'Swiper' })
      Column() {
        Swiper(this.swiperController) {
          ForEach(this.arr, (item) => {
            Text('' + item.name)
              .width('95%')
              .height('100%')
              .backgroundColor(item.color)
              .textAlign(TextAlign.Center)
              .fontSize(24)
          })
        }
        .cachedCount(this.cachedCount)
        .disableSwipe(this.disableSwipe)
        .index(this.index)
        .autoPlay(this.autoPlay)
        .interval(this.interval)
        .indicator(this.indicator)
        .loop(this.loop)
        .duration(this.duration)
        .vertical(this.vertical)
        .itemSpace(this.itemSpace)
        .onChange((index: number) => {
          this.index = index
          console.info(index.toString())
        })
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })

      if (this.loop) {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Button('preview', { type: ButtonType.Capsule, stateEffect: true })
              .alignSelf(ItemAlign.Center)
              .width(80)
              .height(28)
              .fontSize('12fp')
              .fontWeight(FontWeight.Medium)
              .fontColor('#FFFFFF')
              .backgroundColor('#007DFF')
              .borderRadius(14)
              .onClick(() => {
                this.swiperController.showPrevious()
              })
            Button('next', { type: ButtonType.Capsule, stateEffect: true })
              .alignSelf(ItemAlign.Center)
              .width(80)
              .height(28)
              .fontSize('12fp')
              .fontWeight(FontWeight.Medium)
              .fontColor('#FFFFFF')
              .backgroundColor('#007DFF')
              .borderRadius(14)
              .onClick(() => {
                this.swiperController.showNext()
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
        }.zIndex(999)
      }

      Scroll(this.scroller) {
        Column() {
          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('index')
                .fontSize('16fp')
                .opacity(0.5)
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
              Text('' + this.index)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }
          .bindMenu([
            {
              value: '0',
              action: () => {
                this.index = 0
              }
            },
            {
              value: '1',
              action: () => {
                this.index = 1
              }
            },
            {
              value: '2',
              action: () => {
                this.index = 2
              }
            },
            {
              value: '3',
              action: () => {
                this.index = 3
              }
            },
            {
              value: '4',
              action: () => {
                this.index = 4
              }
            },
          ])

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('cachedCount')
                .fontSize('16fp')
                .opacity(0.5)
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
              Text('' + this.cachedCount)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }
          .bindMenu([
            {
              value: '1',
              action: () => {
                this.cachedCount = 1
              }
            },
            {
              value: '2',
              action: () => {
                this.cachedCount = 2
              }
            },
            {
              value: '3',
              action: () => {
                this.cachedCount = 3
              }
            },
            {
              value: '4',
              action: () => {
                this.cachedCount = 4
              }
            },
          ])

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('vertical')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Toggle({ type: ToggleType.Switch, isOn: this.vertical })
              .width(35)
              .height(20)
              .selectedColor(0x317aff)
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                this.vertical = !this.vertical
              })
              .margin(0)
              .padding(0)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('disableSwipe')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Toggle({ type: ToggleType.Switch, isOn: this.disableSwipe })
              .width(35)
              .height(20)
              .selectedColor(0x317aff)
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                this.disableSwipe = !this.disableSwipe
              })
              .margin(0)
              .padding(0)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('indicator')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Toggle({ type: ToggleType.Switch, isOn: this.indicator })
              .width(35)
              .height(20)
              .selectedColor(0x317aff)
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                this.indicator = !this.indicator
              })
              .margin(0)
              .padding(0)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('autoPlay')
              .fontSize('16fp')
              .opacity(0.5)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Toggle({ type: ToggleType.Switch, isOn: this.autoPlay })
              .width(35)
              .height(20)
              .selectedColor(0x317aff)
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                this.autoPlay = !this.autoPlay
              })
              .margin(0)
              .padding(0)
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('loop')
                .fontSize('16fp')
                .opacity(0.5)
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
              Toggle({ type: ToggleType.Switch, isOn: this.loop })
                .width(35)
                .height(20)
                .selectedColor(0x317aff)
                .switchPointColor(0xe5ffffff)
                .onChange((isOn: boolean) => {
                  this.loop = !this.loop
                })
                .margin(0)
                .padding(0)
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }
          .bindMenu([
            {
              value: 'true',
              action: () => {
                this.loop = true
              }
            },
            {
              value: 'false',
              action: () => {
                this.loop = false
              }
            }
          ])

          if (this.loop) {
            Column() {
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Text('animationDuration')
                  .fontSize('16fp')
                  .opacity(0.5)
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                Text('' + this.interval)
                  .fontSize('16fp')
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                  .width('50%')
                  .textAlign(TextAlign.End)
              }.height(35)

              Slider({
                value: this.interval / 100,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
              })
                .width('100%')
                .blockColor('#FFFFFF')
                .trackColor('#182431')
                .selectedColor('#007DFF')
                .showSteps(true)
                .showTips(false)
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.interval = Math.floor(value * 100)
                })
            }
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }

          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('duration')
                .fontSize('16fp')
                .opacity(0.5)
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
              Text('' + this.duration)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }

            Slider({
              value: this.duration / 100,
              min: 0,
              max: 200,
              step: 1,
              style: SliderStyle.OutSet
            })
              .width('100%')
              .blockColor('#FFFFFF')
              .trackColor('#182431')
              .selectedColor('#007DFF')
              .showSteps(true)
              .showTips(false)
              .onChange((value: number, mode: SliderChangeMode) => {
                this.duration = Math.floor(value * 100)
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text('itemSpace')
                .fontSize('16fp')
                .opacity(0.5)
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
              Text('' + this.itemSpace)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }.height(35)

            Slider({
              value: this.itemSpace,
              min: 0,
              max: 500,
              step: 1,
              style: SliderStyle.OutSet
            })
              .width('100%')
              .blockColor('#FFFFFF')
              .trackColor('#182431')
              .selectedColor('#007DFF')
              .showSteps(true)
              .showTips(false)
              .onChange((value: number, mode: SliderChangeMode) => {
                this.itemSpace = Math.floor(value)
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8, bottom: 20 })
        }
      }
      .align(Alignment.Start)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .scrollBarColor(Color.Gray)
      .scrollBarWidth(30)
      .width('100%')
      .height('50%')
    }
    .width('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 10 })
  }

  pageTransition() {
    PageTransitionEnter({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)

    PageTransitionExit({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)
  }
}