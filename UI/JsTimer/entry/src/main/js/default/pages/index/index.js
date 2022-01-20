'@file function'
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
    timer: undefined,
    data: {
        dataDateTime: '',
        dataTime: '00:00:00',
        multiText: [["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17",
        "18", "19", "20", "21", "22", "23", "24"],
        ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17",
        "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35",
        "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53",
        "54", "55", "56", "57", "58", "59"],
        ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17",
        "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35",
        "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53",
        "54", "55", "56", "57", "58", "59"]],
        timeoutID: '0',
        hour: 0,
        minute: 0,
        second: 0,
        hourStr: '',
        minuteStr: '',
        secondStr: '',
        milliSecond: 0,
        time: 0
    },
    onInit() {
        var date = new Date()
        this.dataDateTime = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate() + "-" +
        date.getHours() + "-" + date.getMinutes()
    },
    dateTimeChange(e) {
        this.dataDateTime = e.year + '-' + (e.month + 1) + '-' + e.day + '-' + e.hour + '-' + e.minute;
        var date = new Date(e.year, e.month, e.day, e.hour, e.minute);
        this.time = date.getTime();
    },
    multiTextChange(e) {
        this.hour = e.newValue[0]
        this.minute = e.newValue[1]
        this.second = e.newValue[2]
        this.hourStr = this.hour + ''
        this.minuteStr = this.minute + ''
        this.secondStr = this.second + ''
        if (this.hour < 10) {
            this.hourStr = '0' + this.hour
        }
        if (this.minute < 10) {
            this.minuteStr = '0' + this.minute
        }
        if (this.second < 10) {
            this.secondStr = '0' + this.second
        }
        this.dataTime = this.hourStr + ':' + this.minuteStr + ':' + this.secondStr;
        this.milliSecond = this.hour * 3600 * 1000 + this.minute * 60 * 1000 +
        this.second * 1000;
    },
    updateTime: function () {
        var hper = 60 * 60 * 1000
        var mper = 60 * 1000
        var ts = this.milliSecond
        this.hour = parseInt(ts / hper)
        this.hourStr = this.hour + ''
        if (ts / hper < 10) {
            this.hourStr = '0' + this.hour
        }
        ts = ts - this.hour * hper
        this.minute = parseInt(ts / mper)
        this.minuteStr = this.minute + ''
        if (ts / mper < 10) {
            this.minuteStr = '0' + this.minute
        }
        ts = ts - this.minute * mper
        this.second = parseInt(ts / 1000)
        this.secondStr = this.second + ''
        if (ts / 1000 < 10) {
            this.secondStr = '0' + this.second
        }
        this.dataTime = this.hourStr + ':' + this.minuteStr + ':' + this.secondStr;
        if (this.milliSecond > 0) {
            this.milliSecond = this.milliSecond - 1000
        }
        if (this.hour == 0 && this.minute == 0 && this.second == 0) {
            clearInterval(this.timer)
        }
    },
    setTimer() {
        this.timer = setInterval(this.updateTime, 1000)
        prompt.showToast({
            message: this.$t('strings.success'),
        });
        var message = this.$t('strings.shutdown');
        this.timeoutID = setTimeout(function () {
            prompt.showToast({
                message: message,
                duration: 2000
            });
        }, this.milliSecond + 1000);
    },
    clearTimer() {
        clearInterval(this.timer)
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
