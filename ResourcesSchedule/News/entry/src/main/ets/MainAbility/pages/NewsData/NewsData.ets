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

export class NewsData {
  title: string;
  image: Resource;
  detail: Resource;
  constructor(title: string, image: Resource, detail: Resource) {
    this.title = title;
    this.image = image;
    this.detail = detail;
  }
}

export function initNewsData(): Array<NewsData> {
  const newsComposition: NewsData[] = [
    { 'title': '国家卫健委：15省38000多名医务人员驰援上海', 'image': $r('app.media.new1'), 'detail': $r('app.string.news1') },
    { 'title': '西安：发现阳性病例后 我市迅速开展流调排查、隔离管控', 'image': null, 'detail': $r('app.string.news2') },
    { 'title': '多武器实弹射击 新疆军区某红军师检验官兵高海拔作战能力', 'image': $r('app.media.new3'), 'detail': $r('app.string.news3') },
    { 'title': '国家公园 生态之窗', 'image': $r('app.media.new4'), 'detail': $r('app.string.news4') },
    { 'title': '多地通报“气溶胶传播新冠”', 'image': $r('app.media.new5'), 'detail': $r('app.string.news5') }
  ]

  let newsDataArray: Array<NewsData> = []
  for (let index = 0; index < 100; index++) {
    newsComposition.forEach(item => {
      newsDataArray.push(new NewsData(item.title, item.image, item.detail));
    })
  }
  return newsDataArray;
}