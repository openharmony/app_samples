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

import worker from '@ohos.worker'

export default {
    data: {
        before: "",
        after: "",
        worker: new worker.Worker("workers/worker.js", {
            name: "worker_test"
        })
    },
    onInit() {
        this.before = this.$t('strings.menus')
        this.worker.onerror = function (data) {
            console.info('[worker.index] on error:' + data)
        }
        this.worker.onmessageerror = function (data) {
            console.info('[worker.index] on messageerror:' + data)
        }
        this.worker.onexit = function (data) {
            console.info('[worker.index] on exit:' + data)
        }
        this.worker.onmessage = function (e) {
            let data = e.data
            if (data.type == 'normal') {
                console.info('[worker.index] normal:' + data.data)
                this.after = data.data
            }
        }
    },
    sendString: function () {
        let obj = {
            type: "normal", data: this.before.toString()
        }
        console.info('[worker.index] sendString:' + obj.data)
        this.worker.postMessage(obj)
    },
    clear: function () {
        this.after = ""
    },
    terminate() {
        this.worker.terminate()
    }
}