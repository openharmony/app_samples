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
import router from '@system.router';
import { settingItemView } from './settingPage';

@Entry
@Component
export struct DiscoverPage {
  scroller: Scroller = new Scroller()

  build() {
    Flex() {
      Scroll(this.scroller) {
        Column() {
          Flex()
            .height(20)
          Row() {
            settingItemView({ image: "/resources/icon/find_friends.png", text: "聊天社区" })
          }
          .onClick(() => {
            router.push({
              uri: 'pages/friendsMomentsPage'
            })
          })

          Flex()
            .height(20)
          settingItemView({ image: "/resources/icon/icon_de_scan.png", text: "扫一扫" })
          settingItemView({ image: "/resources/icon/icon_de_shake.png", text: "摇一摇" })
          Flex()
            .height(20)
          Column() {
            settingItemView({ image: "/resources/images/searchOne.png", text: "搜一搜" })
          }

          Flex()
            .height(20)
          Column() {
            settingItemView({ image: "/resources/images/applet.png", text: "小程序" })

          }

          Flex()
            .height(20)
          Column() {
            settingItemView({ image: "/resources/icon/icon_de_nearby.png", text: "附近的人" })
          }

          Flex()
            .height(20)
          settingItemView({ image: "/resources/icon/icon_de_shop.png", text: "购物" })
          settingItemView({ image: "/resources/icon/icon_de_game.png", text: "游戏" })
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