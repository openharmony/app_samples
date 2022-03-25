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

import Logger from '../model/Logger'
import { WebError, HttpError } from '../model/Error'

@Component
export struct WebComponent {
  private tag: string = 'WebComponent'
  private controller: WebController = null
  @Link url: string
  @Link webTitle: string
  @Link browses: string[]
  @Link newProgress: number
  @Link webError: WebError
  @Link httpError: HttpError
  @Link isLoading: boolean
  @Link isWebError: boolean
  @Link isHttpError: boolean

  build() {
    Column() {
      Web({ src: this.url, controller: this.controller })
        .zoomAccess(true)
        .mixedMode(MixedMode.All)
        .onDownloadStart((event?: {
          url: string,
          userAgent: string,
          contentDisposition: string,
          mimetype: string,
          contentLength: number
        }) => {
          let message = `URL:${event.url}\n媒体资源类型:${event.mimetype}\n文件长度:${event.contentLength}`
          AlertDialog.show(
            {
              title: `userAgent:${event.userAgent}`,
              message: message,
              confirm: {
                value: $r('app.string.sure'),
                action: () => {
                  Logger.log(this.tag, 'Button-clicking callback')
                }
              },
              cancel: () => {
                Logger.log(this.tag, 'Closed callbacks')
              }
            }
          )
        })
        .onErrorReceive((event?: {
          request: WebResourceRequest,
          error: WebResourceError
        }) => {
          this.webError.errCode = event.error.getErrorCode()
          this.webError.errInfo = event.error.getErrorInfo()
          this.isWebError = true
        })
        .onHttpErrorReceive((event?: {
          request: WebResourceRequest,
          response: WebResourceResponse
        }) => {
          this.httpError.message = event.response.getReasonMessage()
          this.httpError.code = event.response.getResponseCode()
          this.httpError.data = event.response.getResponseData()
          this.httpError.enCoding = event.response.getResponseEncoding()
          this.httpError.header = JSON.stringify(event.response.getResponseHeader())
          this.httpError.mimeType = event.response.getResponseMimeType()
          this.isHttpError = true
        })
        .onTitleReceive((event?: { title: string }) => {
          this.webTitle = event.title
          if (this.webTitle.length > 10) {
            this.webTitle = this.webTitle.substr(0, 10) + '...'
          }
        })
        .onProgressChange((event?: { newProgress: number }) => {
          this.newProgress = event.newProgress
        })
        .onPageBegin(e => {
          this.isLoading = true
          if (this.browses.indexOf(this.url, 0) !== -1) {
            this.browses.splice(this.browses.indexOf(this.url, 0), 1)
          }
          this.browses.unshift(this.url)
        })
        .onPageEnd(e => {
          this.isLoading = false
        })
    }
  }
}