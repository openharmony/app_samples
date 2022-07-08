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

import router from '@ohos.router';

export default {
  data: {
    title: "",
    content: []
  },
  onInit() {
    this.title = this.$t("strings.typical_scenario");
    this.content = [
      {
        title: this.$t("strings.diversion_layout"),
        uri: "pages/responsiveLayout/typicalScene/diversion/diversion"
      },
      {
        title: this.$t("strings.indentation_layout"),
        uri: "pages/responsiveLayout/typicalScene/indentation/indentation"
      },
      {
        title: this.$t("strings.repeat_layout"), uri: "pages/responsiveLayout/typicalScene/repeat/repeat"
      }
    ];
  },
  onclick: function (uri) {
    router.push({
      url: uri
    });
  }
}
