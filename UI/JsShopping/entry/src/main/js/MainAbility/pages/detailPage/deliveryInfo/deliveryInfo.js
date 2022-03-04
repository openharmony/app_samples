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
import router from '@system.router';

export default {
    props: [
        'deliveryinfo',
        'commonimg'
    ],
    data() {
        return {
            deliveryInfo: this.deliveryinfo,
            commonImg: this.commonimg,
            buyNumber: 1,
        }
    },
    openOptions() {
        this.$element('dialogs').show();
    },
    closeOptions() {
        this.$element('dialogs').close();
    },
    redirect() {
        router.push({
            uri: 'pages/performance/performance',
        });
    },
    cutNumber() {
        if (this.buyNumber > 1) {
            this.buyNumber = this.buyNumber - 1;
        }
    },
    addNumber() {
        this.buyNumber = this.buyNumber + 1;
    },
};