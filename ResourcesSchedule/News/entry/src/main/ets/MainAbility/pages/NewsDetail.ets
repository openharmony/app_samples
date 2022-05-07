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

import router from '@ohos.router';
import { NewsDetailTitle } from './NewsDetailTitle'
import { NewsData } from './NewsData/NewsData'

@Entry
@Component
struct NewsDetail {
  private newsItem: NewsData = router.getParams()['data1'] as NewsData

  build() {
    Column() {
      NewsDetailTitle()
      Stack({ alignContent: Alignment.TopStart }) {
        Scroll() {
          Column() {
            Text(this.newsItem.title)
              .fontSize(20)
              .margin({ left: 5, right: 5 })
            if (this.newsItem.image != null) {
              Image(this.newsItem.image)
                .objectFit(ImageFit.Contain)
                .height(250)
                .margin({ left: 5, right: 5, top: 5 })
                .onClick(() => {
                  router.push({
                    url: 'pages/FullImagePage',
                    params: ({ data1: this.newsItem.image })
                  })
                })
                .animation({ duration: 0 })
            }
            Text(this.newsItem.detail)
              .fontSize(16)
              .margin({ left: 5, right: 5, top: 5 })
          }
          .alignItems(HorizontalAlign.Start)
        }
      }
    }
    .alignItems(HorizontalAlign.Center)
  }
}
