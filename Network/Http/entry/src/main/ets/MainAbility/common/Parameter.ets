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

import Logger from '../model/logger'

const TAG = '[Parameter]'

@CustomDialog
export struct Parameter {
  @State list: number[] = [0]
  private keys: string[] = []
  private values: string[] = []
  private flag: number = 1
  controller: CustomDialogController

  setList() {
    this.list = []
    for (let i = 0; i < this.flag; i++) {
      this.list[i] = i
    }
  }

  build() {
    Scroll() {
      Column() {
        ForEach(this.list, item => {
          Row() {
            Text('Key: ')
              .margin(10)
              .fontSize(18)
              .textAlign(TextAlign.End)
            TextInput()
              .margin(10)
              .width('60%')
              .onChange((value: string) => {
                this.keys[this.flag - 1] = value
              })
          }

          Row() {
            Text('Value: ')
              .margin(10)
              .fontSize(18)
              .textAlign(TextAlign.End)
            TextInput()
              .margin(10)
              .width('60%')
              .onChange((value: string) => {
                this.values[this.flag -1] = value
              })
          }
        }, item => item.toString())

        Row() {
          Button($r('app.string.add'))
            .margin(8)
            .fontSize(16)
            .width('26%')
            .onClick(() => {
              this.flag += 1
              this.setList()
              Logger.info(TAG, `This list is ${JSON.stringify(this.list)}`)
            })

          Button($r('app.string.reduce'))
            .margin(8)
            .fontSize(16)
            .width('26%')
            .onClick(() => {
              this.flag -= 1
              this.setList()
              Logger.info(TAG, `This list is ${JSON.stringify(this.list)}`)
            })

          Button($r('app.string.confirm'))
            .margin(8)
            .fontSize(16)
            .width('28%')
            .onClick(() => {
              Logger.info(TAG, `This key is ${JSON.stringify(this.keys)} this value is ${JSON.stringify(this.values)}`)
              this.controller.close()
            })
        }
      }
    }
    .layoutWeight(1)
  }
}