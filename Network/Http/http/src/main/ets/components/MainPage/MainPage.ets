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

import router from '@ohos.router'
import Http from '../model/http'

@Entry
@Component
export struct setting {
  private getUri: string
  private getOption: object
  @State url: string = ''
  @State option: object = undefined
  @State flag: number = 1
  @State keys: string[] = []
  @State list: number[] = [0]
  @State values: string[] = []
  @State result: string = ''
  @State method: string = 'GET'
  @State showPage: boolean = false
  @State resultInfo: string = ''
  @State methods: Array<{ name: string }> = [{ name: 'GET' }, { name: 'POST' }, { name: 'PUT' }, { name: 'DELETE' }]

  @Builder MenuBuilder() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      ForEach(this.methods, item => {
        Text(item.name)
          .margin(5)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.method = item.name
          })

        Divider().height(1)
      }, item => item.name.toString())
    }
    .width('60%')
  }

  aboutToAppear() {
    this.url = this.getUri
    this.option = this.getOption
    Http.setUrl(this.url)
    let context: any = getContext(this)
    this.resultInfo = context.resourceManager.getStringSync($r('app.string.result').id)
  }

  build() {
    Scroll() {
      Column() {
        if (!this.showPage) {
          Text($r('app.string.configuration'))
            .margin('2%')
            .fontSize(28)

          Row() {
            Text(this.method)
              .width('20%')
              .fontSize(18)
              .textAlign(TextAlign.Center)
              .bindMenu(this.MenuBuilder)
              .margin({ left: 2, right: 4 })

            TextInput({ placeholder: $r('app.string.web') })
              .width('75%')
              .margin({ left: 4, right: 2 })
              .placeholderFont({ size: 25, weight: 500, family: 'cursive', style: FontStyle.Normal })
              .onChange((value: string) => {
                this.url = value
              })
          }
          .width('95%')
          .height('10%')

          ForEach(this.list, item => {
            Row() {
              Text('Key: ')
                .width('20%')
                .fontSize(18)
                .margin({ left: 2, right: 4 })
                .textAlign(TextAlign.Center)
              TextInput()
                .width('75%')
                .margin({ left: 4, right: 2 })
                .onChange((value: string) => {
                  this.keys[this.flag - 1] = value
                })
            }
            .width('95%')
            .height('10%')

            Row() {
              Text('Value: ')
                .width('20%')
                .fontSize(18)
                .margin({ left: 2, right: 4 })
                .textAlign(TextAlign.Center)
              TextInput()
                .width('75%')
                .margin({ left: 4, right: 2 })
                .onChange((value: string) => {
                  this.values[this.flag -1] = value
                })
            }
            .width('95%')
            .height('10%')
          }, item => item.toString())

          Column() {
            Button($r('app.string.add'))
              .margin(10)
              .fontSize(20)
              .width('60%')
              .onClick(() => {
                this.flag += 1
                this.list = Http.setList(this.list, this.flag)
              })

            Button($r('app.string.reduce'))
              .margin(10)
              .fontSize(20)
              .width('60%')
              .onClick(() => {
                if (this.flag !== 1) {
                  this.flag -= 1
                }
                this.list = Http.setList(this.list, this.flag)
              })

            Button($r('app.string.reset'))
              .margin(10)
              .fontSize(20)
              .width('60%')
              .onClick(() => {
                this.flag = 1
                this.list = [0]
              })

            Button($r('app.string.confirm'))
              .margin(10)
              .fontSize(20)
              .width('60%')
              .onClick(async () => {
                Http.setUrl(this.url)
                Http.setMethod(this.method)
                Http.setExtraData(Http.setParameter(this.keys, this.values))
                try {
                  let info = await Http.request()
                  if (info.responseCode === 200) {
                    this.result = JSON.stringify(info.result)
                  } else {
                    this.result = 'Failed'
                  }
                } catch (err) {
                  this.result = 'Failed'
                }
                this.showPage = !this.showPage
              })

            Button($r('app.string.back'))
              .margin(10)
              .fontSize(20)
              .width('60%')
              .onClick(() => {
                router.replace({
                  url: 'pages/Index',
                  params: {
                    url: this.url === '' ? Http.url : this.url,
                    option: Http.options
                  }
                })
              })
          }
          .margin({ top: '2%', bottom: '2%' })
          .width('100%')
        } else {
          Text(`${this.resultInfo} ${this.result}`)
            .fontSize(20)
            .margin('5%')

          Button($r('app.string.back'))
            .fontSize(25)
            .onClick(() => {
              this.url = ''
              this.flag = 1
              this.keys = []
              this.list = [0]
              this.values = []
              this.result = ''
              this.method = 'GET'
              this.showPage = !this.showPage
            })
        }
      }
    }
    .width('100%')
    .height('100%')
  }
}