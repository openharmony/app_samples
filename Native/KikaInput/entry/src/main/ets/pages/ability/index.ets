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
import router from '@system.router';

@Entry
@Component
struct Index {
  private controller: TabsController = new TabsController
  @State DataArr: any = [
    { "name": "一只小兔兔", "Description": "这书鸭鸭的小兔兔鸭", "img": $r("app.media.icon") },
    { "name": "一只小兔兔", "Description": "这书鸭鸭的小兔兔鸭", "img": $r("app.media.icon") },
    { "name": "一只小兔兔", "Description": "这书鸭鸭的小兔兔鸭", "img": $r("app.media.icon") },
    { "name": "一只小兔兔", "Description": "这书鸭鸭的小兔兔鸭", "img": $r("app.media.icon") },
  ]
  @State currentIndex: number = 0
  @State array: Array<object> = [
    {
      icon: $r("app.media.icon"),
      icon_after: $r("app.media.icon"),
      text: "皮肤",
      num: 0
    },
    {
      icon: $r("app.media.icon"),
      icon_after: $r("app.media.icon"),
      text: "表情",
      num: 1
    },
    {
      icon: $r("app.media.icon"),
      icon_after: $r("app.media.icon"),
      text: "语录",
      num: 2
    },
    {
      icon: $r("app.media.icon"),
      icon_after: $r("app.media.icon"),
      text: "我的",
      num: 3
    },
  ]

  @Builder TabBuilder(item) {
    Column() {
      Image(this.currentIndex === item.num ? item.icon_after : item.icon)
        .width("80px")
        .height("80px")
        .objectFit(ImageFit.Contain)
      Text(item.text)
        .fontSize(10)
        .margin({ top: 2 })
    }
    .width("100%")
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        ForEach(this.array, (item) => {
          TabContent() {
            Flex({ justifyContent: FlexAlign.Center }) {
              if (item.text === '皮肤') {
                SkinTab()
              } else if (item.text === '表情') {
                EmoTab({ DataArr: $DataArr })
              } else if (item.text === '语录') {
                TextTab({ DataArr: $DataArr })
              } else if (item.text === '我的') {
                MyTab()
              }
            }
          }.tabBar(this.TabBuilder(item))
        })
      }
      .barMode(BarMode.Fixed)
      .scrollable(false)
      .vertical(false)
      .animationDuration(0)
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
    .width("100%")
    .height("100%")
    .padding({ left: 15, right: 15 })
  }
}

@Component
struct HeadNav {
  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Text("小艺商店").fontSize(23)
      Row({ space: 20 }) {
        Image($r("app.media.icon")).width(30).height(30)
        Image($r("app.media.icon")).width(30).height(27)
      }
    }.margin({ top: 20 })
  }
}

@Component
struct SkinTab {
  @State SwiperList: [Resource, string][] = [[$r("app.media.icon"), "金色星球宇航员"], [$r("app.media.icon"), "樱花"], [$r("app.media.icon"), "轻检OS"], [$r("app.media.icon"), "新拟态机器人"]]
  private swiperController = new SwiperController

  build() {
    Column() {
      HeadNav()
      Swiper(this.swiperController) {
        ForEach(this.SwiperList, (item) => {
          Image(item[0]).width("100%").height(200).borderRadius(25).objectFit(ImageFit.Cover)
        })
      }
      .index(1)
      .autoPlay(true)
      .interval(4000)
      .indicator(true)
      .loop(true)
      .duration(1000)
      .vertical(false)
      .itemSpace(0)
      .margin({ top: 20 })

      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center,
        wrap: FlexWrap.Wrap
      }) {
        ForEach(this.SwiperList, (item) => {
          Column() {
            Image(item[0]).width("100%").height(110).borderRadius(10).objectFit(ImageFit.Cover)
            Text(item[1]).width("100%").textAlign(TextAlign.Start).fontSize(14).margin({ top: 10 })
          }.width("46%").height(130).margin({ right: 5, top: 20, left: 5 })
        })
      }.width("100%")
    }.width("100%").height("100%")
  }
}

@Component
struct EmoTab {
  private swiperController: SwiperController = new SwiperController()
  @State SwiperList: [Resource][] = [[$r("app.media.icon")], [$r("app.media.icon")], [$r("app.media.icon")]]
  @Link DataArr: any

  build() {
    Column() {
      HeadNav()
      List() {
        ListItem() {
          Column() {
            Swiper(this.swiperController) {
              ForEach(this.SwiperList, (item) => {
                Image(item[0]).width("100%").height(200).borderRadius(25)
              })
            }
            .index(1)
            .autoPlay(true)
            .interval(4000)
            .indicator(true)
            .loop(true)
            .duration(1000)
            .vertical(false)
            .itemSpace(0)
            .margin({ top: 20 })
          }
        }

        ListItem() {
          Column() {
            ForEach(this.DataArr, (item) => {
              Flex({
                direction: FlexDirection.Row,
                alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.SpaceBetween
              }) {

                Row({ space: 20 }) {
                  Image(item.img).width(50).height(50).borderRadius(25)
                  Column() {
                    Text(item.name).fontSize(16).textAlign(TextAlign.Start).width("100%")
                    Text(item.Description).fontSize(14).textAlign(TextAlign.Start).width("100%")
                  }.width(200)
                }

                Text("下载")
                  .width(70)
                  .height(30)
                  .backgroundColor("#f1f2f6")
                  .textAlign(TextAlign.Center)
                  .borderRadius(50)
                  .fontColor(Color.Blue)
              }

              Column() {
              }
              .width("80%")
              .height(1)
              .backgroundColor(Color.Black)
              .margin({ top: 15, bottom: 15, left: "15%" })
            })
          }.margin({ top: 20 })
        }

        ListItem() {
          Column() {
            ForEach(this.DataArr, (item) => {
              Flex({
                direction: FlexDirection.Row,
                alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.SpaceBetween
              }) {

                Row({ space: 20 }) {
                  Image(item.img).width(50).height(50).borderRadius(25)
                  Column() {
                    Text(item.name).fontSize(16).textAlign(TextAlign.Start).width("100%")
                    Text(item.Description).fontSize(14).textAlign(TextAlign.Start).width("100%")
                  }.width(200)
                }

                Text("下载")
                  .width(70)
                  .height(30)
                  .backgroundColor("#f1f2f6")
                  .textAlign(TextAlign.Center)
                  .borderRadius(50)
                  .fontColor(Color.Blue)
              }

              Column() {
              }
              .width("80%")
              .height(1)
              .backgroundColor(Color.Black)
              .margin({ top: 15, bottom: 15, left: "15%" })
            })
          }.margin({ top: 20 })
        }.margin({ bottom: 60 })
      }.width("100%").height("100%")
    }.width("100%").height("100%")
  }
}

@Component
struct TextTab {
  private swiperController: SwiperController = new SwiperController
  @State SwiperList: [Resource][] = [[$r("app.media.icon")], [$r("app.media.icon")], [$r("app.media.icon")]]
  @Link DataArr: any

  build() {
    Column() {
      HeadNav()
      List() {
        ListItem() {
          Column() {
            Swiper(this.swiperController) {
              ForEach(this.SwiperList, (item) => {
                Image(item[0]).width("100%").height(200).borderRadius(25)
              })
            }
            .index(1)
            .autoPlay(true)
            .interval(4000)
            .indicator(true)
            .vertical(false)
            .loop(true)
            .duration(1000)
            .itemSpace(0)
            .margin({ top: 20 })
          }
        }

        ListItem() {
          Column() {
            ForEach(this.DataArr, (item) => {
              Flex({
                direction: FlexDirection.Row,
                alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.SpaceBetween
              }) {
                Row({ space: 20 }) {
                  Image(item.img).width(50).height(50).borderRadius(15)
                  Column() {
                    Text(item.name).fontSize(16).textAlign(TextAlign.Start).width("100%")
                  }.width(200)
                }

              }

              Column() {
              }
              .width("80%")
              .height(1)
              .backgroundColor(Color.Black)
              .margin({ top: 15, bottom: 15, left: "15%" })
            })
          }.margin({ top: 20 })
        }

        ListItem() {
          Column() {
            ForEach(this.DataArr, (item) => {
              Flex({
                direction: FlexDirection.Row,
                alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.SpaceBetween
              }) {
                Row({ space: 20 }) {
                  Image(item.img).width(50).height(50).borderRadius(15)
                  Column() {
                    Text(item.name).fontSize(16).textAlign(TextAlign.Start).width("100%")
                  }.width(200)
                }
              }

              Column() {
              }
              .width("80%")
              .height(1)
              .backgroundColor(Color.Black)
              .margin({ top: 15, bottom: 15, left: "15%" })
            })
          }.margin({ top: 20 })
        }.margin({ bottom: 60 })
      }.width("100%").height("100%")
    }.width("100%").height("100%")
  }
}

@Component
struct MyTab {
  scroller: Scroller = new Scroller()
  @State Change: boolean = false
  @State Changes: boolean = false
  @State Icons: Array<object> = [
    {
      icon: $r("app.media.icon"),
      text: '皮肤'
    },
    {
      icon: $r("app.media.icon"),
      text: '字体'
    },
    {
      icon: $r("app.media.icon"),
      text: '词库'
    },
    {
      icon: $r("app.media.icon"),
      text: '备份设置项'
    },
    {
      icon: $r("app.media.icon"),
      text: '表情'
    },
    {
      icon: $r("app.media.icon"),
      text: '语录'
    },
    {
      icon: $r("app.media.icon"),
      text: '云端同步'
    },
  ]

  build() {
    Scroll(this.scroller) {
      Column() {
        Flex({
          direction: this.Change ? FlexDirection.Row : FlexDirection.Column,
          alignItems: ItemAlign.Center,
          justifyContent: this.Change ? FlexAlign.Start : FlexAlign.Center,
        }) {
          Image($r("app.media.icon"))
            .width(this.Change ? 20 : 80)
            .height(this.Change ? 20 : 80)
            .margin({ top: this.Change ? 0 : 50, bottom: this.Change ? 10 : 0 })
          Column() {
            Text("登录华为账号").fontSize(18).margin({ left: this.Change ? 20 : 0, top: this.Change ? 10 : 0 })
            if (!this.Change) {
              Text("同步您的词库和打字习惯").fontSize(12)
            }
          }.margin({ bottom: 20 })
        }.backgroundColor("#f1f2f6").width("100%")

        Column() {
          Text("我的账号").width("90%").textAlign(TextAlign.Start).fontSize(16).margin({ top: 20 })
          Flex({
            direction: FlexDirection.Row,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Start,
            wrap: FlexWrap.Wrap
          }) {
            ForEach(this.Icons, (item) => {
              Column() {
                Image(item.icon).width(40).height(40)
                Text(item.text).margin({ top: 15, bottom: 15 })
              }.width("23%")
            })
          }.margin({ top: 20 })

          Flex({
            direction: FlexDirection.Row,
            alignItems: ItemAlign.Start,
            justifyContent: FlexAlign.SpaceBetween,
          }) {
            Row({ space: 10 }) {
              Image($r("app.media.icon")).width(30).height(30)
              Text("设置").fontSize(18)
            }

            Image($r("app.media.icon")).width(30).height(30)

          }.width("90%").margin({ top: 20 }).height(this.Change ? "50%" : "45%")
          .onClick(() => {
            router.push({
              uri: 'pages/ability/second'
            })
            console.log("启动")
          })
        }.width("100%")
      }.width("100%")
    }
    .scrollable(ScrollDirection.Vertical).scrollBar(BarState.Off)
    .onScroll((xOffset: number, yOffset: number) => {
      if (yOffset > 20) {
        this.Change = true
      }
    })
    .onScrollEdge((side: Edge) => {
      this.Change = false
    })
  }
}