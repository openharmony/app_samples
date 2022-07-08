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

import router from '@ohos.router'

export default {
  data: {
    title: '',
    content: []
  },
  onInit() {
    this.title = this.$t("strings.atomic_layout_capability");
    this.content = [
      {
        title: this.$t("strings.flex_capability_first"),
        uri: "pages/atomicLayoutCapability/flexibleCapability/flexibleCapability1/flexibleCapability1"
      },
      {
        title: this.$t("strings.flex_capability_second"),
        uri: "pages/atomicLayoutCapability/flexibleCapability/flexibleCapability2/flexibleCapability2"
      },
      {
        title: this.$t("strings.scaling_capability"),
        uri: "pages/atomicLayoutCapability/scaleCapability/scaleCapability"
      },
      {
        title: this.$t("strings.hidden_capability"),
        uri: "pages/atomicLayoutCapability/hiddenCapability/hiddenCapability"
      },
      {
        title: this.$t("strings.wrap_capability"),
        uri: "pages/atomicLayoutCapability/wrapCapability/wrapCapability"
      },
      {
        title: this.$t("strings.equally_capability"),
        uri: "pages/atomicLayoutCapability/equipartitionCapability/equipartitionCapability"
      },
      {
        title: this.$t("strings.percentage_capability"),
        uri: "pages/atomicLayoutCapability/proportionCapability/proportionCapability"
      },
      {
        title: this.$t("strings.extension_capability_first"),
        uri: "pages/atomicLayoutCapability/extensionCapability/extensionCapability1/extensionCapability1"
      },
      {
        title: this.$t("strings.extension_capability_second"),
        uri: "pages/atomicLayoutCapability/extensionCapability/extensionCapability2/extensionCapability2"
      },
    ];
  },
  onclick: function (uri) {
    router.push({
      url: uri
    });
  }
}


