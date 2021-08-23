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

import router from '@system.router';

export default {
    data: {
        bookNames: []
    },
    onInit() {
        this.bookNames = this.$t('strings.bookNames')
    },
    textClicked(obj) {
        console.info("textClicked, " + obj.detail.bookName)
        for (let todolistKey in this.bookNames) {
            if(obj.detail.bookName == this.bookNames[todolistKey].name) {
                var result = this.bookNames[todolistKey].collect
                this.bookNames[todolistKey].collect = !result
            }
        }
    },
    onShelfClick() {
        var collects = new Array();
        for (let todolistKey in this.bookNames) {
            if(true == this.bookNames[todolistKey].collect) {
                collects.push(this.bookNames[todolistKey])
            }
        }
        router.push({
            uri: "pages/collect/index",
            params:{
                bookNames: collects,
            }
        })
    }
}

