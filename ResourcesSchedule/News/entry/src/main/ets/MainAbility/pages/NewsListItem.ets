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
import { NewsData } from './NewsData/NewsData'

@Entry
@Component
export struct NewsListItem {
  private newsItem: NewsData

  build() {
    Row() {
      Flex({ alignItems: ItemAlign.Start }) {
        if (this.newsItem.image != null) {
          Image(this.newsItem.image)
            .objectFit(ImageFit.Auto)
            .margin({ left: 5 })
            .height('95%')
        }
        Text(this.newsItem.title)
          .fontSize(16)
          .height('95%')
          .width(500)
          .margin({ left: 5, right: 5 })
      }
      .height(this.newsItem.image ? 100 : 80)
    }
    .onClick(() => {
      router.push({
        uri: 'pages/NewsDetail',
        params: ({ data1: this.newsItem })
      })
    })
  }
}