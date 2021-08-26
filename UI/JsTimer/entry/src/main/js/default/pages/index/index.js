'@file function';
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
import systemTime from '@ohos.systemTime';

export default {
    data: {
        dataDateTime: '2021-8-23-12-00',
        dataTime: '00:00:00',
        timeoutID: '0',
        milliSecond: 0,
        time: 0
    },
    dateTimeChange(e) {
        this.dataDateTime = 'e.year + "-" + e.month + "-" + e.day + "-" + e.hour + "-" + e.minute';
        var date = new Date(this.dataDateTime);
        this.time = date.getTime();
    },
    timeChange(e) {
        this.dataTime = 'e.hour + ":" + e.minute + ":" + e.second';
        this.milliSecond = Number(e.hour) * 3600 * 1000 + Number(e.minute) * 60 * 1000 + Number(e.second) * 1000;
    },
    setTimer() {
        prompt.showToast({
            message: this.$t('strings.success'),
        });
        var message = this.$t('strings.shutdown');
        this.timeoutID = setTimeout(function () {
            prompt.showToast({
                message: message,
                duration: 2000
            });
        }, this.milliSecond);
    },
    clearTimer() {
        clearTimeout(this.timeoutID);
        prompt.showToast({
            message: this.$t('strings.failure'),
            duration: 2000
        });
    },
    setTime() {
        systemTime.setTime(this.time)
        .then((value) => {
            console.log(`success to systemTime.setTime: ${value}`);
        }).catch((err) => {
            console.error(`failed to systemTime.setTime because ${err.message}`);
        });
    }
};
