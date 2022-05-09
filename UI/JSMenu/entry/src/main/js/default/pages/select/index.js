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

export default {
    data: {
        result: "",
        menus: [],
        snacks: [],
        drinks: []
    },
    onInit() {
        this.menus = this.$t('strings.menus')
        this.snacks = this.$t('strings.snacks')
        this.drinks = this.$t('strings.drinks')
    },
    onMenuChange(e) {
        this.onSelect(e)
    },
    onSnackChange(e) {
        this.onSelect(e)
    },
    onDrinkChange(e) {
        this.onSelect(e)
    },
    onSelect(e) {
        console.info("onSelect:" + e.newValue)
        if (this.result.length > 0) {
            this.result = this.result + "," + e.newValue
        } else {
            this.result = e.newValue
        }
    },
    onClearClick() {
        this.result = ""
    },
    onFinishClick() {
        if (this.result.length > 0) {
            prompt.showToast({
                message: this.$t('strings.finish_oder')
            })
        } else {
            prompt.showToast({
                message: this.$t('strings.empty_order')
            })
        }
        this.result = ""
    }
}
