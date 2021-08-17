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
        array: [
            {
                imgPath: '/common/images/Image1.jpg',
                contacts: "",
                message: "",
                visibility: "",
                count: "",
                maxCount: ""
            },
            {
                imgPath: '/common/images/Image2.jpg',
                contacts: '',
                message: '',
                visibility: "",
                count: "100",
                maxCount: "99"
            },
            {
                imgPath: '/common/images/Image3.jpg',
                contacts: '',
                message: '',
                visibility: "",
                count: "35",
                maxCount: "99"
            }
        ],
        badgeConfig: {
            badgeColor: "#FFFF0F0F",
            textColor: "#ffffff",
        }
    },
    onInit() {
        for (var arr in this.array) {
            this.array[arr].contacts = this.$t('strings.contacts');
            this.array[arr].message = this.$t('strings.message');
            this.array[arr].visibility = "visible"
        }
    },
    badgeInvalidation(id) {
        var idx = JSON.stringify(id)
        console.log(idx)
        this.array[idx].visibility = "hidden";
        console.log(this.array[idx].visibility)
    }
}