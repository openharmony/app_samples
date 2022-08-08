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

import http from '@ohos.net.http'

class Http {
  url: string
  extraData: Object
  options: http.HttpRequestOptions

  constructor() {
    this.url = ''
    this.options = {
      method:  http.RequestMethod.GET,
      extraData: this.extraData,
      header: { 'Content-Type': 'application/json' },
      readTimeout: 50000,
      connectTimeout: 50000
    }
  }

  setUrl(url: string) {
    this.url = url
  }

  setMethod(method: string) {
    switch (method) {
      case 'GET':
        this.options.method = http.RequestMethod.GET
        break
      case 'POST':
        this.options.method = http.RequestMethod.POST
        break
      case 'PUT':
        this.options.method = http.RequestMethod.PUT
        break
      case 'DELETE':
        this.options.method = http.RequestMethod.DELETE
        break
      default:
        this.options.method = http.RequestMethod.GET
        break
    }
  }

  setExtraData(extraData: Object) {
    this.options.extraData = extraData
  }

  setOptions(option: Object) {
    this.options = option
  }

  setList(list: number[], flag: number) {
    list = []
    for (let i = 0; i < flag; i++) {
      list[i] = i
    }
    return list
  }

  setParameter(keys: string[], values: string[]) {
    let result = {}
    for (let i = 0; i <= keys.length - 1; i++) {
      let key = keys[i]
      let value = values[i]
      result[key] = value
    }
    return result
  }

  async request() {
    let httpRequest = http.createHttp()
    let result = await httpRequest.request(this.url, this.options)
    return result
  }
}

export default new Http()