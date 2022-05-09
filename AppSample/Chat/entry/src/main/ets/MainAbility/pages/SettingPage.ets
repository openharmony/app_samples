// @ts-nocheck
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
export struct SettingPage {
  private scroller: Scroller = new Scroller()

  build() {
    Flex() {
      Scroll(this.scroller) {
        Column() {
          Flex() {
            Row() {
              Image($r('app.media.personality3'))
                .width(80)
                .height(80)
              Column({ space: 10 }) {
                Row() {
                  Text("自己")
                    .fontSize(15)
                    .fontColor(Color.Black)
                }

                Text("聊天号：*******")
                  .fontSize(15)
                  .fontColor(Color.Black)
              }
              .alignItems(HorizontalAlign.Start)
              .padding({ left: 20 })
            }
            .padding(10)
            .backgroundColor(Color.White)
            .width('100%')
          }
          .backgroundColor(Color.White)
          .height(100)
          .onClick(() => {
            router.push({ uri: 'pages/UserInfo' })
          })
          .margin({ bottom: 10 })

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_photo'), text: '相册' })
          }

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_collect'), text: '收藏' })
          }

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_money'), text: '钱包' })
          }

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_card'), text: '卡包' })
          }
          .margin({ bottom: 10 })

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_smail'), text: '表情' })
          }
          .margin({ bottom: 10 })

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_setting'), text: '设置' })
          }
          .margin({ bottom: 10 })
          .onClick(() => {
            router.push({ uri: 'pages/Setting' })
          })

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_setting'), text: '加载聊天记录' })
          }
          .onClick(() => {
            router.push({ uri: 'pages/index' })
          })
        }
      }
    }
    .backgroundColor("#cccccc")
    .width("100%")
    .height("100%")
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}

@Component
export struct SettingItemView {
  private image: string
  private text: string
  private callBack: Function
  private height: number = 40

  build() {
    Stack({ alignContent: Alignment.End }) {
      Row() {
        Image(this.image)
          .width(30)
          .height(30)
        Text(this.text)
          .fontSize(15)
          .fontColor('#000000')
          .margin({ left: 10 })
      }
      .width('100%')
      .height(this.height)
      .padding({ left: 10, right: 10 })
      .backgroundColor(Color.White)

      Image($r('app.media.right'))
        .height(20)
        .width(15)
        .align(Alignment.End)
        .margin({ right: 15 })
    }
    .width('100%')
    .height(this.height)
  }
}