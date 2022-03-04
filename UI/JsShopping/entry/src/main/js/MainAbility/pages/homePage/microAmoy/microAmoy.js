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
import amoyData from '../../../common/microAmoyData.js'

export default {
    data: {
        navbarData: ['关注', '推荐', '直播', '畅享', '福利', '视频'],
        tempList: [],
        beginIndex: 0,
        endIndex: 0,
        amoyData: amoyData,
    },
    onInit() {
    },
    buildItem(param) {
        if (this.amoyData.length == 0) {
            return;
        }
        this.beginIndex = param.begin;
        this.endIndex = param.end;
        let tempArray = [];
        for (let index = this.beginIndex;index < this.endIndex; ++index) {
            let tempIndex = index % this.amoyData.length;
            let tempValue = JSON.parse(JSON.stringify(this.amoyData[tempIndex]));
            tempValue.index = index + 1;
            tempArray.push(tempValue);
        }
        this.tempList = tempArray;
    }
}