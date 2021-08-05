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
        data: ["15", "20", "25"],
        multiText: [["A", "B", "C", "D"], ["a", "b", "c", "d"], ["1", "2", "3", "4"]],
        dataText: "15",
        dataDate: "2021-8-2",
        dataTime: "24:00:00",
        dataDateTime: "2021-8-2-12-00",
        pickerMulti: "Ab1"
    },
    textChange(e) {
        this.dataText = e.newValue
    },
    dateChange(e) {
        this.dataDate = e.year + "-" + e.month + "-" + e.day
    },
    timeChange(e) {
        this.dataTime = e.hour + ":" + e.minute + ":" + e.second
    },
    dateTimeChange(e) {
        this.dataDateTime = e.year + "-" + e.month + "-" + e.day + "-" + e.hour + "-" + e.minute
    },
    multiTextChange(e) {
        var sum = " "
        e.newValue.forEach(function (value, index, array) {
            array[index] == value
            sum += value
        });
        this.pickerMulti = sum
    }
}
