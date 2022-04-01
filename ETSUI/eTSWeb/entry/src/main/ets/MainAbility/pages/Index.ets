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

import { TitleBar } from '../common/TitleBar'
import { WebError, HttpError } from '../model/Error'
import { HomePage } from '../common/HomePage'
import { SearchBar } from '../common/SearchWeb'
import { WebData, initWebData } from '../model/WebData'
import { BottomBar } from '../common/BottomBar'
import { WebComponent } from '../common/WebComponent'
import { BrowseHistory } from '../common/BrowseHistory'

@Extend(Text) function errText (fontSize: number, marginTop: number) {
  .width('85%')
  .maxLines(2)
  .fontSize(fontSize)
  .margin({ top: marginTop })
}

@Entry
@Component
struct Index {
  private controller: WebController = new WebController()
  @State url: string = ''
  @State browses: string[] = []
  @State webTitle: string = '主页'
  @State newProgress: number = 0
  @State isWebError: boolean = false
  @State webState: boolean = false
  @State backToHome: boolean = true
  @State isHttpError: boolean = false
  @State isLoading: boolean = true
  @State homeWebs: Array<WebData> = initWebData()
  @State webError: WebError = { errCode: null, errInfo: '' }
  @State httpError: HttpError = {
    message: '',
    code: null,
    data: '',
    enCoding: '',
    header: '',
    mimeType: ''
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar({ webTitle: $webTitle })
      SearchBar({
        url: $url,
        webState: $webState,
        isLoading: $isLoading,
        backToHome: $backToHome,
        isWebError: $isWebError,
        isHttpError: $isHttpError,
        controller: this.controller,
      })

      Column() {
        Column() {
          if (this.webState === true) {
            if (this.isWebError === true) {
              Text(`errCode : ${this.webError.errCode.toString()}`).errText(40, 100)
              Text(`errInfo : ${this.webError.errInfo}`).errText(25, 15)
            }
            else if (this.isHttpError === true) {
              Text(`code : ${this.httpError.code.toString()}`).errText(35, 100)
              Text(`message : ${this.httpError.message}`).errText(25, 15)
              Text(`data : ${this.httpError.data}`).errText(25, 15)
              Text(`enCoding : ${this.httpError.enCoding}`).errText(25, 15)
              Text(`header : ${this.httpError.header}`).errText(25, 15)
              Text(`mimeType : ${this.httpError.mimeType}`).errText(25, 15)
            } else {
              WebComponent({
                url: $url,
                browses: $browses,
                webTitle: $webTitle,
                webError: $webError,
                httpError: $httpError,
                isLoading: $isLoading,
                isWebError: $isWebError,
                isHttpError: $isHttpError,
                newProgress: $newProgress,
                controller: this.controller,
              })
            }
          }
          else if (this.backToHome === true) {
            HomePage({ homeWebs: $homeWebs, url: $url, webState: $webState, backToHome: $backToHome })
          }
          else {
            BrowseHistory({
              url: $url,
              browses: $browses,
              webState: $webState,
              isLoading: $isLoading,
              backToHome: $backToHome,
              isWebError: $isWebError,
              isHttpError: $isHttpError
            })
          }
        }
        .width('100%')
        .height('93%')
        .backgroundColor('#e5e5e5')

        if (this.isLoading && this.newProgress !== 0) {
          Progress({ value: this.newProgress, total: 100, type: ProgressType.Linear })
            .width('90%')
            .color(Color.Grey)
        }
        BottomBar({
          url: $url,
          webTitle: $webTitle,
          webState: $webState,
          backToHome: $backToHome,
          isWebError: $isWebError,
          isHttpError: $isHttpError,
          controller: this.controller,
        })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}