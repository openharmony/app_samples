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

import ChatData from '../model/ChatData'

@Component
export default struct ChatsPage {
  @Link chats: Array<ChatData>

  @Builder
  ChatsMessage(name: Resource, message: string, direction: Direction) {
    Row() {
      Text(name)
        .width(40)
        .height(40)
        .padding(5)
        .fontSize(25)
        .borderRadius(10)
        .margin({ right: 10 })
        .backgroundColor('#e5e5e5')
        .textAlign(TextAlign.Center)
      Text(message)
        .padding(10)
        .maxLines(5)
        .fontSize(20)
        .borderRadius(10)
        .margin({ top: 20 })
        .alignSelf(ItemAlign.Start)
        .backgroundColor('#ff78dd4d')
    }
    .width('100%')
    .direction(direction)
    .margin({ top: 5, bottom: 10 })
  }

  build() {
    Column() {
      List() {
        ForEach(this.chats, (item) => {
          ListItem() {
            if (item.isServer) {
              this.ChatsMessage($r('app.string.server'), item.message, Direction.Ltr)
            } else {
              this.ChatsMessage($r('app.string.me'), item.message, Direction.Rtl)
            }
          }
          .padding(10)
          .width('100%')
        }, item => item.message)
      }
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor(Color.White)
  }
}