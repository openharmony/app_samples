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

import logger from '../Common/Logger'

const TAG: string = '[HttpRequestOptions]'

export class HttpRequestOptions {
    private method: string
    private extraData: Object = {
        'location': '',
        'key': '8d8b6e2bac074efb9380bc75042e563a'
    }
    private header: Object
    private readTimeout: number
    private connectTimeout: number

    constructor() {
        this.method = 'GET'
        this.header = {
            'Content-Type': 'application/json'
        }
        this.readTimeout = 1000
        this.connectTimeout = 1000
    }

    setMethod(method: string) {
        this.method = method
        logger.info(TAG, `setMethod method is ${this.method}`)
    }

    setExtraData(extraData: string) {
        this.extraData["location"] = extraData
        logger.info(TAG, `setExtraData extraData is ${JSON.stringify(this.extraData)}`)
    }

    setHeader(header: Object) {
        this.header = header
        logger.info(TAG, `setHeader header is ${JSON.stringify(this.header)}`)
    }
}

export default new HttpRequestOptions()