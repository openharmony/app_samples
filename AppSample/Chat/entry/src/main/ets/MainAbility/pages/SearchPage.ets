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
struct SearchPage {
  @State changeValue: string = ''
  private con = ["社区", "文章", "公众号", "小程序", "音乐", "表情", "服务"]

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
      Row() {
        Stack({ alignContent: Alignment.Center }) {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Image($r('app.media.search'))
              .width(20)
              .height(20)
              .opacity(0.5)
              .margin({ left: 10 })
            Text("搜索")
              .fontSize(20)
              .opacity(0.5)
              .padding({ left: 10 })
          }
        }
        .backgroundColor(Color.White)
        .height(40)
        .width('90%')
        .borderRadius(10)

        Text("取消")
          .fontSize(16)
          .fontColor("#0066cc")
          .margin({ left: 10 })
          .onClick(() => {
            router.back()
          })
      }
      .margin({ top: 30 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }) {
        Text("搜索指定内容")
          .fontSize(16)
      }
      .opacity(0.5)
      .padding(30)
      .height(86)

      Flex({
        direction: FlexDirection.Row,
        wrap: FlexWrap.Wrap,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.SpaceBetween
      }) {
        ForEach(this.con, (item) => {
          Text(item)
            .fontColor("#0066cc")
            .width("33%")
            .fontSize(20)
            .padding(20)
        }, (msg, index) => index.toString())
      }
      .margin({ left: "7%" })
    }.padding(10).backgroundColor("#f5f5f5")
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}