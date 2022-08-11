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

import router from '@ohos.router'
import contact from '@ohos.contact'
import { Pinyin } from '../data/Pinyin'

@Component
export struct ItemContainer {
  @State selected: number = 0
  @State routerItem: number = 0
  @State letter: string = ''
  private pinyin: Pinyin = new Pinyin()
  private contacts: contact.Contact[] = []
  private scroller: Scroller = new Scroller()
  private alphabetical: string[] =
    [
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
      'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    ]

  build() {
    Stack({ alignContent: Alignment.End }) {
      Column() {
        List({ space: 4, initialIndex: this.routerItem }) {
          ForEach(this.contacts, (item, index) => {
            ListItem() {
              Column() {
                if (index === 0) {
                  this.container(item.name.fullName.substr(0, 1).toUpperCase())
                }
                else {
                  if (item.name.fullName.substr(0, 1) !== this.contacts[index - 1].name.fullName.substr(0, 1)) {
                    this.container(item.name.fullName.substr(0, 1).toUpperCase())
                  }
                }
                Row() {
                  Image($r('app.media.head'))
                    .width(52)
                    .height(52)
                    .borderRadius(90)
                    .margin({ left: 32 })

                  Text(item.name.fullName)
                    .fontSize(20)
                    .margin({ left: 22 })
                }
                .width('100%')
                .borderRadius(15)
                .onClick(() => {
                  router.push({
                    url: 'pages/NameCard',
                    params: { data: item }
                  })
                })
              }
              .width('100%')
            }
          }, item => item.toString())
        }
        .width('100%')
        .height('50%')
        .onScrollIndex((startIndex: number, lastIndex: number) => {
          // 更新选中的字母索引
          this.letter = this.contacts[startIndex].name.fullName.substr(0, 1)
            .toUpperCase()
          this.selected = this.alphabetical.indexOf(this.letter)
        })
      }
      .width('100%')
      .height('100%')

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
        AlphabetIndexer({ arrayValue: this.alphabetical, selected: this.selected })
          .itemSize(18)
          .font({ size: 14 })
          .borderRadius(25)
          .usingPopup(false)
          .selectedColor('#007DFF')
          .margin({ left: 2, right: 4, top: 4 })
          .alignStyle(IndexerAlign.Right)
          .selectedFont({ size: 14, weight: FontWeight.Bolder })
          .onSelect((selected: number) => {
            // 跳转到指定索引位置
            this.scroller.scrollToIndex(selected)
          })
      }
      .margin({ right: 16 })
    }
    .width('100%')
    .height('100%')
  }

  @Builder container(text: string) {
    Row() {
      Text(text)
        .fontSize(24)
        .margin({ left: 32 })
    }
    .width('100%')
    .margin({ top: 32, bottom: 22 })
  }
}