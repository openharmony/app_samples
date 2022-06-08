/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

class DateTimeUtil {
    getTime() {
        const DATETIME = new Date()
        return this.concatTime(DATETIME.getHours(), DATETIME.getMinutes())
    }

    getDate() {
        const DATETIME = new Date()
        return this.concatDate(DATETIME.getFullYear(), DATETIME.getMonth() + 1, DATETIME.getDate())
    }

    fill(value: number) {
        return (value > 9 ? '' : '0') + value
    }

    concatDate(year: number, month: number, date: number) {
        return `${month}月${date}日`
    }

    concatTime(hours: number, minutes: number) {
        return `${this.fill(hours)}:${this.fill(minutes)}`
    }
}

export default new DateTimeUtil()