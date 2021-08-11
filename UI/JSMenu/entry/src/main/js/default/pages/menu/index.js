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

import prompt from '@system.prompt';

export default {
    data: {
        result: "",
        menus: [],
        snacks:[],
        drinks:[],
        menu_result:"",
        snack_result:"",
        drink_result:""
    },
    onInit() {
        this.menus = this.$t('strings.menus')
        this.snacks = this.$t('strings.snacks')
        this.drinks = this.$t('strings.drinks')
        this.menu_result = this.menus[0].name
        this.snack_result = this.snacks[0].name
        this.drink_result = this.drinks[0].name
    },
    onMenuSelected(e) {
        this.menu_result = e.value
        this.onSelect(e)
    },
    onSnackSelected(e) {
        this.snack_result = e.value
        this.onSelect(e)
    },
    onDrinkSelected(e) {
        this.drink_result = e.value
        this.onSelect(e)
    },
    onSelect(e) {
        if (this.result.length > 0) {
            this.result = this.result + "," + e.value
        } else {
            this.result = e.value
        }
    },
    onMenuClick() {
        this.$element("menu").show({
            x: 130,
            y: 45
        });
    },
    onSnackClick() {
        this.$element("snackMenu").show({
            x: 130,
            y: 120
        });
    },
    onDrinkClick() {
        this.$element("drinkMenu").show({
            x: 130,
            y: 190
        });
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
