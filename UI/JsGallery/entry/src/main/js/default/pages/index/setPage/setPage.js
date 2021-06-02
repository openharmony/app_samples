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
import router from "@system.router"

export default {
    data: {
        col: 8,
        num: 5000
    },
    onInit() {
    },
    changeCol(e) {
        this.col = e.text;
    },
    changeNum(e) {
        this.num = e.text;
    },
    redirect() {
        router.push({
            uri: "pages/index/index",
            params: {
                message: [this.col, this.num],
                pass: true
            }
        })
    },
    back() {
        router.back();
    }
}