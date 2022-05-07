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
    data: {},
    onInit() {
    },

    onClickAnimationStyle() {
        router.push({
            url: 'pages/animation/index/index'
        })
    },

    onClickGradientStyle() {
        router.push({
            url: 'pages/gradient/index'
        })
    },

    onClickTransitionStyle() {
        router.push({
            url: 'pages/transitions/index/index'
        })
    },

    onClickCustomFontStyle() {
        router.push({
            url: 'pages/customfont/index'
        })
    }
}