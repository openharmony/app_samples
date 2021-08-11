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
        fontSize: "16px"
    },
    font(e) {
        switch (e.value) {
            case 0:
                this.fontSize = "16px"
                break
            case 20:
                this.fontSize = "20px"
                break
            case 40:
                this.fontSize = "24px"
                break
            case 60:
                this.fontSize = "28px"
                break
            case 80:
                this.fontSize = "32px"
                break
            case 100:
                this.fontSize = "36px"
                break
            default:
                break
        }
    }
}
