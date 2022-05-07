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

export default {
    data: {
        list: []
    },
    onInit() {
        for (var i = 0; i < 15; i++) {
            var item = {
                url: 'pages/transitions/cardtargetpage/cardtargetpage',
                title: "this is title" + i,
                id: "item_" + i
            }
            this.list.push(item);
        }
    },

    jumpPage(id, url) {
        var cardId = this.$element(id).ref;
        router.push({
            url: url, params: {
                ref: cardId
            }
        });
    }
}