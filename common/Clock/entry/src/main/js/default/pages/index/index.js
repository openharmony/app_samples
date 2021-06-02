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
    timer: undefined,
    data: {
        hour: 0,
        minute: 0,
        second: 0
    },
    onInit() {
        this.updateTime();
        this.timer = setInterval(this.updateTime, 1000)
    },
    updateTime: function () {
        var nowTime = new Date()
        this.hour = nowTime.getHours()
        this.minute = nowTime.getMinutes()
        this.second = nowTime.getSeconds()
        if (this.hour < 10) {
            this.hour = '0' + this.hour
        }
        if (this.minute < 10) {
            this.minute = '0' + this.minute
        }
        if (this.second < 10) {
            this.second = '0' + this.second
        }
    },
    onDestroy() {
        clearInterval(this.timer)
    }
}