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

import prompt from '@system.prompt'
import router from '@system.router'

export default {
    data: {
        name: '',
        date: '1990-01-01',
        gender: 'Strings.male',
        education: 'Strings.graduated',
    },
    onInit() {
    },
    getName(e) {
        this.name = e.value;
        console.info("name=" + this.name)
    },
    getDate(e) {
        this.date = e.year + '-' + (e.month + 1) + '-' + e.day;
        console.info("date=" + this.date)
    },
    getFemaleGender(e) {
        if (e.checked) {
            this.gender = 'Strings.female'
            console.info("gender =" + this.gender)
        }
    },
    getMaleGender(e) {
        if (e.checked) {
            this.gender = 'Strings.male'
            console.info("gender =" + this.gender)
        }
    },
    getEducation(e) {
        this.education = e.newValue;
        console.info("education=" + this.education)
    },
    onRegiste() {
        if (this.name.length == 0) {
            prompt.showToast({
                message: this.$t('Strings.name_null')
            })
            return;
        }
        if (this.name.length < 6) {
            prompt.showToast({
                message: this.$t('Strings.name_short')
            })
            return;
        }
        if (this.date.length == 0) {
            prompt.showToast({
                message: this.$t('Strings.date_null')
            })
            return;
        }

        if (this.gender.length == 0) {
            prompt.showToast({
                message: this.$t('Strings.gender_null')
            })
            return;
        }

        if (this.education.length == 0) {
            prompt.showToast({
                message: this.$t('Strings.education_null')
            })
            return;
        }

        router.push({
            uri: 'pages/success/success'
        })
    }
}
