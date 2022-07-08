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

export default {
  data: {
    title: '',
    width: "400vp",
    height: "400vp",
    value: 400
  },
  onInit() {
    this.title = this.$t("strings.scaling_capability");
  },
  setWidth(e) {
    this.width = e.value + "vp";
  },
  setHeight(e) {
    this.height = e.value + "vp";
  }
}