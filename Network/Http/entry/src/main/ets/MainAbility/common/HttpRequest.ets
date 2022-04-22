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
import Logger from '../model/Logger'
import { Parameter } from '../common/Parameter'
import HttpRequestOptions from '../model/HttpRequestOptions'

const TAG = '[HttpRequest]'

@Component
export struct HttpRequest {
  @State url: string = ''
  @State result: string = ''
  @State header: string = ''
  @State keys: string[] = []
  @State values: string[] = []
  @State method: string = 'GET'
  @State requestData: http.HttpResponse = undefined
  @State methods: Array<{ name: string }> = [{ name: 'GET' }, { name: 'POST' }, { name: 'PUT' }, { name: 'DELETE' }]
  private controller: TabsController = new TabsController()
  dialogController: CustomDialogController = new CustomDialogController({
    builder: Parameter({ keys: this.keys, values: this.values }), autoCancel: true, alignment: DialogAlignment.Center })

  setParameter(keys: string[], values: string[]) {
    let result = {}
    for (let i = 0; i <= keys.length - 1; i++) {
      let key = keys[i]
      let value = values[i]
      result[key] = value
    }
    Logger.info(TAG, `Result is ${JSON.stringify(result)}}`)
    return result
  }

  async request(uri: string, op: Object) {
    let httpRequest = http.createHttp()
    Logger.info(TAG, `createHttp uri = ${uri}`)
    try {
      let result = await httpRequest.request(uri, op)
      Logger.info(TAG, `HttpResponse's result is ${JSON.stringify(result.result)}`)
      Logger.info(TAG, `responseCode is ${result.responseCode} header is ${JSON.stringify(result.header)}
        cookies is ${JSON.stringify(result.cookies)}}`)
      return result
    } catch (err) {
      Logger.info(TAG, `This err is ${JSON.stringify(err)}`)
      httpRequest.destroy()
      return err
    }
  }

  @Builder MenuBuilder() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      ForEach(this.methods, item => {
        Text(item.name)
          .margin(5)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.method = item.name
            HttpRequestOptions.setMethod(this.method)
          })

        Divider().height(1)
      }, item => item.name.toString())
    }
    .width('60%')
  }

  build() {
    Scroll() {
      Column() {
        Row() {
          Text(this.method)
            .margin(5)
            .fontSize(18)
            .bindMenu(this.MenuBuilder)
            .textAlign(TextAlign.Center)
            .width('20%')

          Blank()
            .width('10%')

          TextInput({ placeholder: $r('app.string.web') })
            .margin(5)
            .width('60%')
            .onChange((value: string) => {
              this.url = value
              Logger.info(TAG, `This url is ${this.url}`)
            })
        }
        .height('15%')

        Row() {
          Button($r('app.string.parameter'))
            .fontSize(16)
            .margin({ left: 10, right: 10 })
            .width('30%')
            .onClick(() => {
              this.keys = []
              this.values = []
              this.dialogController.open()
            })

          Blank()
            .width('15%')

          Button($r('app.string.submit'))
            .fontSize(16)
            .width('30%')
            .margin({ left: 10, right: 10 })
            .onClick(async () => {
              Logger.info(TAG, `onClick This method is ${HttpRequestOptions.method}`)
              if (this.keys !== []) {
                HttpRequestOptions.extraData = this.setParameter(this.keys, this.values)
                Logger.info(TAG, `onClick ExtraData is ${JSON.stringify(HttpRequestOptions.extraData)}`)
              }
              this.requestData = await this.request(this.url, {
                method: HttpRequestOptions.method,
                extraData: HttpRequestOptions.extraData,
                header: HttpRequestOptions.header,
                readTimeout: HttpRequestOptions.readTimeout,
                connectTimeout: HttpRequestOptions.connectTimeout,
              })
              this.result = `responseCode = ${JSON.stringify(this.requestData.responseCode)}\n` +
              JSON.stringify(this.requestData.result)
              Logger.info(TAG, `onClick Request result result is ${JSON.stringify(this.result)}`)
              this.header = JSON.stringify(this.requestData.header)
              Logger.info(TAG, `onClick Request result header is ${JSON.stringify(this.header)}`)
            })
        }

        Tabs() {
          TabContent() {
            Text(this.result)
              .margin(15)
              .fontSize(16)
              .width('90%')
              .height('95%')
              .border({ width: 1 })
          }.tabBar('Result')

          TabContent() {
            Text(this.header)
              .margin(15)
              .fontSize(16)
              .width('90%')
              .height('95%')
              .border({ width: 1 })
          }.tabBar('Header')
        }
        .margin({ top: 10 })
        .height('70%')
        .barWidth('90%')
        .barHeight('8%')
        .vertical(false)
        .barMode(BarMode.Fixed)

        Button($r('app.string.clear'))
          .margin(10)
          .fontSize(18)
          .width('60%')
          .onClick(() => {
            this.result = ''
            this.header = ''
          })
      }
    }
    .layoutWeight(1)
  }
}