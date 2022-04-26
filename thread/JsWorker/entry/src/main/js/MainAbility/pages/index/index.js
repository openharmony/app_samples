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

const TAG = 'JsWorker.index'

const str2ab = function(str) {
  let buf = new ArrayBuffer(str.length*2)
  let bufView = new Uint16Array(buf)
  let strLen = str.length
  for(let i = 0;i< strLen;i++) {
    bufView[i] = str.charCodeAt(i)
  }
}
export default {
    data: {
        before: "",
        after: "",
        worker: new worker.Worker("workers/worker.js", {
            name: "worker_test"
        })
    },
    onInit() {
        console.info(`${TAG} on onInit`)
        this.before = this.$t('strings.menus')
        this.worker.onerror =  (data) => {
            console.info(`${TAG} on error: ${JSON.stringify(data)}`)
        }
        this.worker.onmessageerror = (data) => {
            console.info(`${TAG} on messageerror: ${JSON.stringify(data)}`)
        }
        this.worker.onexit =  (data) => {
            console.info(`${TAG} on exit: ${JSON.stringify(data)}`)
        }
        this.worker.onmessage =  (e) => {
            let data = e.data
            if (data.objType == 'normal') {
                console.info(`${TAG} normal: ${data.data}`)
                this.after = data.data
            }
        }
    },

    sendString() {
        console.info(`${TAG} sendString`)
        let obj = {
            objType: "normal",
            data: this.before.toString()
        }
        console.info(`${TAG} sendString: ${obj.data}`)
        this.worker.postMessage(obj)
    },
    clear() {
        this.after = ''
    },
    terminate() {
        this.worker.terminate()
    }
}