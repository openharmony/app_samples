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

import { Contact } from '../component/Contact'

@Component
export struct Home {
  @State currentIndex: number = 1
  private controller: TabsController = new TabsController()

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: 1, controller: this.controller }) {
        TabContent() {
        }
        .tabBar(this.TabBuilder(0))

        TabContent() {
          Contact()
        }
        .tabBar(this.TabBuilder(1))

        TabContent() {
        }
        .tabBar(this.TabBuilder(2))
      }
      .height('100%')
      .barWidth('100%')
      .barHeight('10%')
      .scrollable(false)
      .barMode(BarMode.Fixed)
      .backgroundColor('#f1f3f5')
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder TabBuilder(index: number) {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Image(this.TabItem(index).image)
        .objectFit(ImageFit.Contain)
        .width(32)
        .height(32)

      Text(this.TabItem(index).text)
        .fontSize(16)
        .margin({ left: 10, right: 10 })
        .fontColor(this.currentIndex === index ? '#007DFF' : '#66000000')
    }
    .width('100%')
  }

  TabItem(index: number) {
    if (index === 0) {
      return { image: $r('app.media.call'), text: $r('app.string.phone') }
    } else if (index === 1) {
      return {
        image: this.currentIndex === index ? $r('app.media.contact1') : $r('app.media.contact'),
        text: $r('app.string.contact')
      }
    } else {
      return { image: $r('app.media.collection'), text: $r('app.string.collection') }
    }
  }
}