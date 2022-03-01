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
import router from '@system.router'
import prompt from '@system.prompt'

export default {
    data: {
        videonumopa: 2,
        videonummove: 2,
        num: 6,
    },
    onInit() {
    },
    changeOpa1(e) {
        if (e.checked === true) {
            this.videonumopa = e.target.attr.value;
        }
    },
    changeOpa2(e) {
        if (e.checked === true) {
            this.videonumopa = e.target.attr.value;
        }
    },
    changeOpa3(e) {
        if (e.checked === true) {
            this.videonumopa = e.target.attr.value;
        }
    },
    changeMove1(e) {
        if (e.checked === true) {
            this.videonummove = e.target.attr.value;
        }
    },
    changeMove2(e) {
        if (e.checked === true) {
            this.videonummove = e.target.attr.value;
        }
    },
    changeMove3(e) {
        if (e.checked === true) {
            this.videonummove = e.target.attr.value;
        }
    },
    changeNum(e) {
        this.num = e.text;
    },
    redirect() {
        if (this.num > 10) {
            var that = this;
            prompt.showDialog({
                message: '图片数量最大为10',
                buttons: [
                    {
                        text: '确定',
                        color:'#000000'
                    },
                ],
                success: function () {
                    that.num = '';
                }
            })
        } else {
            router.push({
                uri: 'pages/index/index',
                params: {
                    message: [this.videonumopa, this.videonummove, this.num],
                    pass: true
                }
            });
        }
    },
    back() {
        router.back();
    }
}