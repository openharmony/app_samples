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
        collectStr: "",
        collectColor: "blue",
        props: {
            name: {
                default: 'Book Name',
            },
            collect: {
                default: false
            }
        }
    },
    onInit() {
        console.info('[JsCustomComponet] comp onInit')
    },
    initData() {
        if (this.collect) {
            this.collectStr = this.$t("strings.collected")
            this.collectColor = "gray"
        } else {
            this.collectStr = this.$t("strings.collect")
            this.collectColor = "blue"
        }
    },
    clearData() {
        this.collectStr = ""
        this.collectColor = ""
    },
    onAttached() {
        console.info('[JsCustomComponet] comp onAttached')
    },
    onDetached() {
        console.info('[JsCustomComponet] comp onDetached')
    },
    onPageShow() {
        this.initData();
        console.info('[JsCustomComponet] comp onPageShow')
    },
    onPageHide() {
        console.info('[JsCustomComponet] comp onPageHide')
        this.clearData()
    },
    childClicked() {
        this.$emit('eventType1', {
            bookName: this.name
        })
        this.initData()
    },
}