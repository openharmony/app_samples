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
struct RatingSample {
  @State rating: number = 1
  @State indicator: boolean = false
  @State stars: number = 5
  @State stepSize: number = 0.5
  @State starStyle: string = '心'
  @State backgroundSrc: string = '/common/ic_public_favor.png'
  @State TbackgroundSrc: string = '/common/rating-favor.png'
  @State foregroundSrc: string = '/common/ic_public_favor_filled.png'
  @State TforegroundSrc: string = '/common/favor-filled.png'

  build() {
    Column() {
      NavigationBar({ title: 'Rating' })
      Column() {
        Scroll() {
          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
            Text('Rating')
              .fontSize('24fp')
              .margin({ bottom: 80 })
            Rating({ rating: this.rating, indicator: this.indicator })
              .stars(this.stars)
              .stepSize(this.stepSize)
              .width(this.stars * 25)
              .height(24)
              .starStyle({
                backgroundUri: this.indicator ? this.TbackgroundSrc : this.backgroundSrc,
                foregroundUri: this.indicator ? this.TforegroundSrc : this.foregroundSrc,
                secondaryUri: this.indicator ? this.TbackgroundSrc : this.backgroundSrc
              })
              .onChange((value: number) => {
                this.rating = value
              })
            Text('current score is ' + this.rating).fontSize('20fp').fontColor('blue').margin({ top: 10 })
          }
          .width('100%')
        }
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .width('100%')
      .padding(18)
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('rating')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              Counter() {
                Text(this.rating.toString())
                  .fontWeight(FontWeight.Regular)
                  .fontColor('#000000')
                  .fontSize('10fp')
              }
              .height(24)
              .onInc(() => {
                  this.rating < this.stars ? this.rating += this.stepSize : this.rating
                  this.rating >= this.stars ? this.rating = this.stars : this.rating
              })
              .onDec(() => {
                  this.rating > 0 ? this.rating -= this.stepSize : this.rating
                  this.rating <= 0 ? this.rating = 0 : this.rating
              })
            }

          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('indicator')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Toggle({ type: ToggleType.Switch, isOn: this.indicator })
              .width(35)
              .height(20)
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange(() => {
                  this.indicator ? this.indicator = false : this.indicator = true
              })
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('stars')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')

            Column() {
              Counter() {
                Text(this.stars.toString())
                  .fontWeight(FontWeight.Regular)
                  .fontColor('#000000')
                  .fontSize('10fp')
              }
              .height(24)
              .onInc(() => {
                  this.stars < 10 ? this.stars++ : this.stars
              })
              .onDec(() => {
                  this.stars > 1 ? this.stars-- : this.stars
              })
            }
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('stepSize')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              Text(`${this.stepSize}`)
                .fontSize('10fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: '0.5',
                action: () => {
                  this.stepSize = 0.5
                }
              },
              {
                value: '1',
                action: () => {
                  this.stepSize = 1
                }
              },
              {
                value: '2',
                action: () => {
                  this.stepSize = 2
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('starStyle')
              .fontWeight(FontWeight.Medium)
              .fontColor('#182431')
              .opacity(0.5)
              .fontSize('16fp')
            Column() {
              Text(`${this.starStyle}`)
                .fontSize('10fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .bindMenu([
              {
                value: '心',
                action: () => {
                  this.starStyle = '心'
                  this.backgroundSrc = '/common/ic_public_favor.png'
                  this.TbackgroundSrc = '/common/rating-favor.png'
                  this.foregroundSrc = '/common/ic_public_favor_filled.png'
                  this.TforegroundSrc = '/common/favor-filled.png'
                }
              },
              {
                value: '赞',
                action: () => {
                  this.starStyle = '赞'
                  this.backgroundSrc = '/common/ic_public_thumbsup.png'
                  this.TbackgroundSrc = '/common/support.png'
                  this.foregroundSrc = '/common/ic_public_thumbsup_filled.png'
                  this.TforegroundSrc = '/common/support-filled.png'
                }
              },
              {
                value: '星星',
                action: () => {
                  this.starStyle = '星星'
                  this.backgroundSrc = '/common/star.png'
                  this.TbackgroundSrc = '/common/collect.png'
                  this.foregroundSrc = '/common/star-filled.png'
                  this.TforegroundSrc = '/common/collected.png'
                }
              },
            ])
          }
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
      }
      .margin({ top: 24 })
    }
    .height('100%')
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
