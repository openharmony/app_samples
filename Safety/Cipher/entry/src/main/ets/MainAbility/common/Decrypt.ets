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

import prompt from '@ohos.prompt'
import { CipherModel } from '../model/CipherModel'
import Logger from '../model/Logger'

const TAG: string = '[Decrypt]'

@Component
export struct Decrypt {
  @State info: string = ''
  @State message: string = ''
  @State algorithmType: string = 'Decrypt Algorithm'
  private cipherModel: CipherModel = new CipherModel()

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Row() {
          Select([{ value: 'RSA' },
                  { value: 'AES' }])
            .margin(5)
            .selected(0)
            .value(this.algorithmType)
            .width('30%')
            .font({ size: 20, weight: 300, family: 'serif', style: FontStyle.Normal })
            .selectedOptionFont({ size: 16, weight: 280, family: 'serif', style: FontStyle.Normal })
            .optionFont({ size: 16, weight: 280, family: 'serif', style: FontStyle.Normal })
            .onSelect((index: number, value: string) => {
              this.algorithmType = value
              Logger.info(TAG, `Select: ${index} value: ${value}`)
            })

          TextInput()
            .margin(6)
            .width('60%')
            .onChange((value: string) => {
              this.message = value
            })
        }
        .width('100%')
        .margin(10)

        Row() {
          Button($r('app.string.decrypt'))
            .fontSize(20)
            .margin(10)
            .width('30%')
            .height('6%')
            .onClick(() => {
              if (this.message === '') {
                prompt.showToast({
                  message: 'This message is null.'
                })
              } else {
                if (this.algorithmType === 'RSA') {
                  this.cipherModel.rsaDecrypt(this.message, (result) => {
                    Logger.info(TAG, `this result = ${JSON.stringify(result)}`)
                    this.info = `Decrypt result is :  ${result.text}`
                  })
                } else {
                  this.cipherModel.aesDecrypt(this.message, (result) => {
                    Logger.info(TAG, `this result = ${JSON.stringify(result)}`)
                    this.info = `Decrypt result is :  ${result.text}`
                  })
                }
              }
            })

          Button($r('app.string.reset'))
            .fontSize(20)
            .margin(10)
            .width('30%')
            .height('6%')
            .onClick(() => {
              this.info = ''
            })
        }
        .margin(10)

        Text(this.info)
          .fontSize(18)
          .width('85%')
          .height('25%')
          .border({ width: 2, color: Color.Black })
          .margin(10)
      }
    }
    .width('100%')
    .height('100%')
  }
}