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

export default {
    data: {
        listItem: [
            {
                title: " "
            },
            {
                title: " "
            },
            {
                title: " "
            },
            {
                title: " "
            }
        ]
    },
    onInit() {
        this.initData()
    },
    refreshData: function (refreshing) {
        if ("end" == refreshing.state) {
            for (var index = 0; index < 2; index++) {
                var item = {
                    title: this.$t('strings.title') + (this.listItem.length + 1)
                }
                this.listItem.splice(0, 0, item)
            }
        }
    },
    initData: function () {
        var index = this.listItem.length
        for (let todolistKey in this.listItem) {
            this.listItem[todolistKey].title = this.$t('strings.title') + index
            index--
        }
    }
}
