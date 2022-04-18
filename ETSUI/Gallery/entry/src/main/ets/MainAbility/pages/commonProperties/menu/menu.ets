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
struct Index {
  @Builder MenuBuilder(){
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('close')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          ContextMenu.close();
        })
    }.height(200)
    .backgroundColor(Color.Pink)
  }

  build() {
    Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center,direction:FlexDirection.Column }) {

      NavigationBar({ title: 'CheckboxGroup' })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('ContextMenu.close')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431 ')
          .opacity(0.5)
        Column() {
          Text('LongPress')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#182431 ')
            .margin({ right: 20 })
        }
        .bindContextMenu(this.MenuBuilder, ResponseType.LongPress)
      }
      .width('100%')
      .height(35)
      .padding({ left: 12, right: 12 })
      .borderRadius(14)
      .backgroundColor('#F1F3F5')
      .margin({ top: 0, bottom: 8, left: 12, right: 12 })
    }
  }
}