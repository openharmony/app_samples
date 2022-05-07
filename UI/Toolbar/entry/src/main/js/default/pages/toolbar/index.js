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

import prompt from '@ohos.prompt';
import router from '@ohos.router'

export default {
    data: {
        containerBackground: "white",
        listBackground: "white",
        hidden: "hidden",
        title: "",
        num: 0,
        isState: true,
        isHidden: false
    },
    onInit() {
        this.num = this.ref
        this.flash(this.num)
    },
    flash(id) {
        this.title = this.$t('strings.the') + JSON.stringify(id) + this.$t('strings.chapter')
    },
    show() {
        if (this.isHidden) {
            this.hidden = "hidden"
            this.isHidden = false
        } else {
            this.hidden = "visible"
            this.isHidden = true
        }
    },
    jumpBack() {
        router.push({
            url: 'pages/index/index'
        })
    },
    black() {
        if (this.isState) {
            this.isState = false
            this.containerBackground = "#999999"
            this.listBackground = "#999999"
        } else {
            this.isState = true
            this.containerBackground = "white"
            this.listBackground = "white"
        }
    },
    change(choose) {
        if (this.num == 1 && choose == "previous") {
            prompt.showToast({
                message: this.$t('strings.first')
            })
        } else if (choose == "previous") {
            this.flash(--this.num)
        } else if (this.num == 15 && choose == "next") {
            prompt.showToast({
                message: this.$t('strings.last')
            })
        } else if (choose == "next") {
            this.flash(++this.num)
        }
    }
}