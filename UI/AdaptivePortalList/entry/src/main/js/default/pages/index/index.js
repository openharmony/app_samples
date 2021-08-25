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

import mediaquery from '@system.mediaquery';

export default {
    data: {
        list_data: Array(16).fill().map((_, index) => ({id: "item_" + index})),
        tabBars: [
            {icon: "icon_person_blue.png", text: "页签"},
            {icon: "icon_person_gray.png", text: "页签"},
            {icon: "icon_person_gray.png", text: "页签"},
            {icon: "icon_person_gray.png", text: "页签"},
        ],
        menu_tabs_index: 0,
        isTabletLandscape: false
    },
    onInit() {
        this.regMediaQuery();
    },
    regMediaQuery() {
        let mq = mediaquery.matchMedia('(min-aspect-ratio: 1)');
        mq.addListener((data) => { this.isTabletLandscape = data.matches; });
    }
}