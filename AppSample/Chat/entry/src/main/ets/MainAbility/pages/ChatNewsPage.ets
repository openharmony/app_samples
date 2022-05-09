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
// @ts-nocheck
import router from '@system.router';
import { InLine, Swit } from '../components/Header'

@Entry
@Component
struct ChatNewsPage {
  @State message: string = 'Hello World'
  private scroller: Scroller = new Scroller()

  build() {
    Scroll(this.scroller) {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {
          Image($r('app.media.left'))
            .height(30)
            .width(30)
            .onClick(() => {
              router.back()
            })

          Text("聊天信息")
            .fontWeight(FontWeight.Bold)
            .fontSize(18)
          Text("  ")
            .fontWeight(FontWeight.Bold)
            .fontSize(18)
        }
        .width("100%")
        .padding({ top: 20, bottom: 20, left: 10, right: 10 })

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
          Column() {
            Image(`/resources/images/photo${((router.getParams().IMAGEID) % 50)}.jpg`)
              .height(60)
              .width(60)
              .borderRadius(5)
            Text((router.getParams().NAME))
              .fontSize(12)
          }
          .margin({ left: 20 })

          Image($r('app.media.addfriend'))
            .height(40)
            .width(40)
            .margin({ top: -6, left: 10 })
            .opacity(0.8)
        }
        .backgroundColor("#ffffff")
        .padding({ top: 10, bottom: 10 })

        Column() {
          InLine({ name: "查找聊天记录" })
        }
        .margin({ top: 5 })

        Column() {
          Swit({ name: "消息免打扰" })
          Divider().vertical(false).color("#f5f5f5").strokeWidth(1)

          Swit({ name: "置顶聊天" })
          Divider().vertical(false).color("#f5f5f5").strokeWidth(1)

          Swit({ name: "提醒" })
        }
        .margin({ top: 5 })

        Column() {
          InLine({ name: "设置当前聊天背景" })
        }
        .margin({ top: 5 })

        Column() {
          InLine({ name: "清空聊天记录" })
        }
        .margin({ top: 5 })

        Column() {
          InLine({ name: "投诉" })
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