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
        dataDate: null,
        dateTime: ''
    },
    onInit() {
        var datet = new Date()
        this.dateTime = datet.getFullYear() + '-' + (datet.getMonth() + 1) + '-' + datet.getDate()
        this.dataDate = new Date(datet.getFullYear(), datet.getMonth(), datet.getDate(), datet.getHours(),
            datet.getMinutes(), datet.getSeconds())
    },
    cn() {
        var dateFmt = new Intl.DateTimeFormat('zh-CN')
        this.result = dateFmt.format(this.dataDate)
    },
    en() {
        var dateFmt1 = new Intl.DateTimeFormat('en-GB')
        this.result1 = dateFmt1.format(this.dataDate)
    },
    ja() {
        var dateFmt2 = new Intl.DateTimeFormat('ja-JP')
        this.result2 = dateFmt2.format(this.dataDate)
    }
}



