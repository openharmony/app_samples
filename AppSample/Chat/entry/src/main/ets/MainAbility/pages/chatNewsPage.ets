/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
// @ts-nocheck
import router from '@system.router';

@Entry
@Component
struct ChatNewsPage {
  @State message: string = 'Hello World'
  scroller: Scroller = new Scroller()

  build() {
    Scroll(this.scroller) {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {
          Row() {
            Image("/resources/images/left.png")
              .height(30)
              .width(30)
          }
          .width("10%")
          .onClick(() => {
            router.back()
          })

          Text("聊天信息")
            .fontWeight(FontWeight.Bold)
            .fontSize(18)
          Row() {
            Text("  ")
              .fontWeight(FontWeight.Bold)
              .fontSize(18)
          }
          .width("10%")
        }
        .width("100%")
        .padding({ top: 20, bottom: 20, left: 10, right: 10 })

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
          Column() {
            Image("/resources/images/photo" + ((router.getParams().IMAGEID) % 50) + ".jpg")
              .height(60)
              .width(60)
              .borderRadius(5)
            Text((router.getParams().NAME))
              .fontSize(12)
          }
          .margin({ left: 20 })

          Image("/resources/images/addfriend.png")
            .height(40)
            .width(40)
            .margin({ top: -6, left: 10 })
            .opacity(0.8)
        }
        .backgroundColor("#ffffff")
        .padding({ top: 10, bottom: 10 })

        Column() {
          inline({ name: "查找聊天记录" })
        }
        .margin({ top: 5 })

        Column() {
          swit({ name: "消息免打扰" })
          Row() {
          }
          .height(1)
          .backgroundColor("#f5f5f5")

          swit({ name: "置顶聊天" })
          Row() {
          }
          .height(1)
          .backgroundColor("#f5f5f5")

          swit({ name: "提醒" })
        }
        .margin({ top: 5 })

        Column() {
          inline({ name: "设置当前聊天背景" })
        }
        .margin({ top: 5 })

        Column() {
          inline({ name: "清空聊天记录" })
        }
        .margin({ top: 5 })

        Column() {
          inline({ name: "投诉" })
        }
        .margin({ top: 5 })
      }
      .backgroundColor("#f5f5f5")
      .width("100%")
    }
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}

@Component
export struct inline {
  @State name: string = ''

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {
      Text(this.name)
        .fontSize(16)
      Image("/resources/images/right.png")
        .height(15)
        .width(15)
    }
    .padding({ left: 20, right: 10, top: 15, bottom: 15 })
    .backgroundColor("#ffffff")
  }
}

@Component
struct swit {
  @State name: string = ""
  @State btn: boolean = true
  @State num: number = 1
  @State color: string = "#f0f0f0"

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {
      Text(this.name)
        .fontSize(16)
      Row() {
        Button()
          .width(28)
          .height(28)
          .backgroundColor("#ffffff")
          .borderRadius(14)
          .margin({ left: this.num })
      }
      .width(60)
      .height(30)
      .backgroundColor(this.color)
      .borderRadius(15)
      .onClick(() => {
        if (this.btn) {
          this.num = 31
          this.color = "#00cc33"
          this.btn = false
        } else {
          this.num = 1;
          this.color = "#f0f0f0"
          this.btn = true
        }
      })
    }
    .padding({ left: 20, right: 10, top: 15, bottom: 15 })
    .backgroundColor("#ffffff")
  }
}