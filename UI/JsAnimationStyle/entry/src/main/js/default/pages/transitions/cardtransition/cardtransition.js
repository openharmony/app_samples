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

import router from '@ohos.router'
import mediaQuery from '@system.mediaquery'

export default {
  data: {
    list: [],
    isTablet: true
  },
  onInit() {
    for (var i = 0; i < 15; i++) {
      var item = {
        url: 'pages/transitions/cardtargetpage/cardtargetpage',
        title: "this is title" + i,
        id: "item_" + i
      }
      this.list.push(item)
    }
    let mMediaQueryList = mediaQuery.matchMedia('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)');
    mMediaQueryList.addListener(this.orientationMatch);
  },
  orientationMatch(data) {
    this.isTablet = data.matches
  },
  jumpPage(id, url) {
    var cardId = this.$element(id).ref
    if (this.isTablet) {
      router.push({
        url: url
      })
    } else {
      router.push({
        url: url, params: {
          ref: cardId
        }
      })
    }
  }
}