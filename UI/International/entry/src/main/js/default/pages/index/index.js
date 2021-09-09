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

import Intl from '@ohos.intl';

export default {
    data: {
        result: '',
        result1: '',
        result2: '',
        date: null,
        dateTime: ''
    },
    onInit() {
        this.date = new Date();
        this.dateTime = this.date.getFullYear() + '-' + this.date.getMonth() + '-' + this.date.getDay() + '-' +
            this.date.getDate() + '-' + this.date.getMinutes() + '-' + this.date.getSeconds();
    },
    cn() {
        var dateFmt = new Intl.DateTimeFormat('zh-CN');
        var date = new Date(this.date.getFullYear(), this.date.getMonth(), this.date.getDay(), this.date.getDate(),
            this.date.getMinutes(), this.date.getSeconds());
        this.result = dateFmt.format(date);
    },
    en() {
        var dateFmt1 = new Intl.DateTimeFormat('en-GB');
        var date = new Date(this.date.getFullYear(), this.date.getMonth(), this.date.getDay(), this.date.getDate(),
            this.date.getMinutes(), this.date.getSeconds());
        this.result1 = dateFmt1.format(date);
    },
    ja() {
        var dateFmt2 = new Intl.DateTimeFormat('ja-JP');
        var date = new Date(this.date.getFullYear(), this.date.getMonth(), this.date.getDay(), this.date.getDate(),
            this.date.getMinutes(), this.date.getSeconds());
        this.result2 = dateFmt2.format(date);
    }
}



