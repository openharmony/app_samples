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

export class WebError {
  errCode: number
  errInfo: string

  constructor(errCode: number, errInfo: string) {
    this.errCode = errCode
    this.errInfo = errInfo
  }
}

export class HttpError {
  message: string // 资源响应的状态码描述
  code: number // 资源响应的状态码
  data: string // 资源响应数据
  enCoding: string // 源响应的编码
  header: string // 资源响应头
  mimeType: string // 资源响应的媒体（MIME）类型

  constructor(message: string, code: number, data: string, enCoding: string, header: string, mimeType: string) {
    this.message = message
    this.code = code
    this.data = data
    this.enCoding = enCoding
    this.header = header
    this.mimeType = mimeType
  }
}

