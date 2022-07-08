/*
 *Copyright (c) 2022 Huawei Device Co., Ltd.
 *Licensed under the Apache License, Version 2.0 (the "License");
 *you may not use this file except in compliance with the License.
 *You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *Unless required by applicable law or agreed to in writing, software
 *distributed under the License is distributed on an "AS IS" BASIS,
 *WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *See the License for the specific language governing permissions and
 *limitations under the License.
*/

import mediaquery from '@system.mediaquery';

export default {
  data: {
    title: "",
    list: [0, 1, 2],
    isWidescreen: false
  },
  onInit() {
    this.title = this.$t("strings.repeat_layout")
    var mMediaQueryList = mediaquery.matchMedia('screen and (width>1400)')
    mMediaQueryList.addListener(this.screenMatch)
  },

  screenMatch(e) {
    if (e.matches) {
      this.isWidescreen = true
    } else {
      this.isWidescreen = false
    }
  }
}
