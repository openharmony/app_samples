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

import mediaQuery from '@ohos.mediaquery';
import router from '@system.router';
import { ExampleDataModel, SearchDataModel } from '../../model/searchModel';
import { exampleData, searchData } from '../../data/searchData'

let portraitSearch = null

@Entry
@Component
struct SearchPage {
  @State placeholder: string = (router.getParams().message).toString()
  @State width: number = parseInt(router.getParams().num as string, 10)
  @State ratio: number = parseInt(router.getParams().ratio as string, 10)
  @State value: string = ''
  @State flag: boolean = true
  @State isShow: boolean = true
  @State showText: string = "开启全网热搜榜"
  @State exampleText: Array<ExampleDataModel> = exampleData
  @State active: boolean = false
  @State searchData: Array<SearchDataModel> = searchData
  @State searched: string[] = []
  @State isFlag: boolean = false
  @State swiperWidth: number = 30
  @State opacity: number = 1
  listener = mediaQuery.matchMediaSync('(orientation:landscape)');

  aboutToAppear() {
    portraitSearch = this.onPortrait.bind(this);
    this.listener.on('change', portraitSearch)
  }

  async onPortrait(mediaQueryResult) {
    let result = mediaQueryResult.matches
    if (result) {
      this.width = 45
      this.swiperWidth = 30
    } else {
      this.width = 100
      this.swiperWidth = 60
    }
  }

  build() {
    Column() {
      Column() {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Navigator() {
            Image('/resources/icon/back.png')
              .width(25 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }
          .active(this.active)
          .onClick(() => {
            this.active = true
          })

          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Column() {
              TextInput({ placeholder: this.placeholder, text: this.value })
                .placeholderFont({ size: 10 * this.ratio })
                .enterKeyType(EnterKeyType.Search)
                .height(30 * this.ratio)
                .backgroundColor(Color.White)
                .width(170 * this.ratio)
                .enabled(false)
            }

            Image('/resources/icon/camera.png')
              .width(20 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }
          .width('65%')
          .padding({ left: 10, right: 10 })
          .border({ width: 1, color: Color.Orange, radius: 20 * this.ratio })
          .backgroundColor(Color.White)

          Column() {
            Text('搜索')
              .fontSize(13 * this.ratio)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
          }
          .width('20%')
          .backgroundColor('#ec4b04')
          .border({ radius: 50 * this.ratio })
          .padding({ left: 5, right: 5, top: 10, bottom: 10 })
        }
        .padding({ left: 10, right: 10 })
        .margin({ top: 10, bottom: 10 })
        .height(35 * this.ratio)

        Stack({ alignContent: Alignment.Top }) {
          if (!this.isFlag) {
            Column() {
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text('搜索发现')
                  .fontSize(15 * this.ratio)
                  .fontWeight(FontWeight.Bold)
                Image(this.flag ? '/resources/icon/show.png' : 'resources/icon/hide.png')
                  .width(25 * this.ratio)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    this.flag = !this.flag
                  })
              }
              .margin(10)

              if (this.flag) {
                Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
                  ForEach(this.exampleText, item => {
                    Button() {
                      Text(item.exampleText)
                        .fontSize(12 * this.ratio)
                        .fontColor(Color.Black)
                        .margin({ left: 10, right: 10 })
                    }
                    .margin(3)
                    .height(30 * this.ratio)
                    .backgroundColor('#f8f8f8')
                  }, item => item.toString())
                }
                .margin({ left: 10, right: 10 })
              } else {
                Column() {
                  Text('当前搜索发现隐藏')
                    .fontSize(15 * this.ratio)
                    .fontColor(Color.Gray)
                }
                .width('100%')
                .margin({ top: 20, bottom: 15, left: 10, right: 10 })
              }
              Column() {
                Column() {
                  Row() {
                    Image(this.isShow ? '/resources/icon/show.png' : '/resources/icon/hide.png')
                      .width(25 * this.ratio)
                      .aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                      .margin({ right: 5 })
                    Text(this.showText)
                      .fontSize(10 * this.ratio)
                  }
                  .padding({ left: 10, right: 10 })
                  .margin({ left: 10 })
                  .border({ width: 1, radius: 15, color: Color.Gray })
                  .onClick(() => {
                    this.isShow = !this.isShow
                    if (this.isShow == true) {
                      this.showText = '隐藏全网热搜'
                    } else {
                      this.showText = '开启全网热搜'
                    }
                  })
                }
                .width('100%')
                .margin({ bottom: 10 })
                .alignItems(HorizontalAlign.Start)

                List() {
                  ForEach([1, 2, 3, 4, 5, 6], item => {
                    ListItem() {
                      Column() {
                        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                          Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                            Image('/resources/common/activity.png')
                              .width(30 * this.ratio)
                              .aspectRatio(1)
                              .objectFit(ImageFit.Contain)
                            Text('XX热搜')
                              .fontSize(15 * this.ratio)
                              .fontColor('#995528')
                              .fontWeight(FontWeight.Bold)
                              .margin({ left: 10, right: 10 })
                            Text('今日最新消息全知道')
                              .fontSize(10 * this.ratio)
                              .fontColor('#8b5b2f')
                          }
                          .width('100%')
                        }
                        .padding({ left: 5, right: 5 })

                        ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], item => {
                          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                            Flex({ alignItems: ItemAlign.Center }) {
                              Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                                Text(`${item}`)
                                  .fontSize(10 * this.ratio)
                                  .fontColor(Color.White)
                                  .fontWeight(FontWeight.Bold)
                              }
                              .width(15 * this.ratio)
                              .aspectRatio(1)
                              .border({ radius: 3 * this.ratio })
                              .margin({ right: 5 })
                              .backgroundColor('#ceb198')

                              Text('XX公司5G手机发布会议于xx日开始')
                                .fontSize(12 * this.ratio)
                            }

                            Image(`${Math.round(Math.random()) ? '/resources/icon/up.png' : '/resources/icon/down.png'}`)
                              .width(10 * this.ratio)
                              .height(15 * this.ratio)
                              .objectFit(ImageFit.Contain)
                          }
                          .padding({ left: 5, right: 5 })
                          .width('100%')
                          .height(40 * this.ratio)
                        }, item => item.toString())
                      }
                      .width('100%')
                    }
                    .border({ radius: 15 * this.ratio })
                    .margin({ left: 5, right: 5 })
                    .padding({ top: 5 })
                    .backgroundColor(Color.White)
                    .width(`${this.swiperWidth}%`)
                  }, item => item.toString())
                }
                .listDirection(Axis.Horizontal)
                .height('70%')
                .width('95%')
                .margin({ left: 5, right: 5 })
                .visibility(this.isShow ? Visibility.Visible : Visibility.Hidden)
              }
              .padding({ top: 10, bottom: 0 })
              .alignItems(HorizontalAlign.Start)
              .width('100%')
            }
            .alignItems(HorizontalAlign.Start)
            .width('100%')
          }
          if (this.isFlag) {
            Column() {
              ForEach(this.searched, item => {
                Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                  Row() {
                    Image('/resources/icon/search.png')
                      .width(25 * this.ratio)
                      .aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                    Text(item)
                      .fontSize(18 * this.ratio)
                      .margin({ left: 15 })
                  }

                  Image('/resources/icon/leftTop.png')
                    .width(25 * this.ratio)
                    .aspectRatio(1)
                    .objectFit(ImageFit.Contain)
                }
                .width('100%')
                .height(50 * this.ratio)
                .padding({ left: 10, right: 10 })
                .onClick(() => {
                  this.isFlag = false
                  this.value = item
                })
              }, item => item.toString())
            }
          }
        }
      }
      .width(`${this.width}%`)
    }
    .width('100%')
    .backgroundColor('#F9F9F9')
    .backgroundImage('/resources/common/bgImg.png', ImageRepeat.NoRepeat)
    .backgroundImageSize({ width: '100%', height: '100%' })
  }

  pageTransition() {
    PageTransitionExit({ duration: 0, curve: Curve.Linear })
      .onExit((type: RouteType, progress: number) => {
        this.opacity = 1
      })
    PageTransitionEnter({ duration: 0, curve: Curve.Linear })
      .onEnter((type: RouteType, progress: number) => {
        this.opacity = 1
      })
  }
}