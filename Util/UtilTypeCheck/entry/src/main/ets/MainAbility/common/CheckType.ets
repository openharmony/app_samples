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

import util from '@ohos.util'

@Component
export struct CheckType {
  @State result: string = ' '
  @Link checkResult: string
  @Link presetValue: Array<unknown>

  check(value) {
    let utilType = new util.types()
    let utilData = new Map([
      ['ArrayBuffer', utilType.isAnyArrayBuffer(value)],
      ['Int8Array', utilType.isInt8Array(value)],
      ['Number', utilType.isNumberObject(value)],
      ['String', utilType.isStringObject(value)],
      ['Boolean', utilType.isBooleanObject(value)],
      ['ArrayBuffer', utilType.isAnyArrayBuffer(value)],
      ['DataView', utilType.isDataView(value)],
      ['Arguments', utilType.isArgumentsObject(value)],
      ['AsyncFunction', utilType.isAsyncFunction(value)],
      ['External', utilType.isExternal(value)],
      ['Float32Array', utilType.isFloat32Array(value)],
      ['Generator', utilType.isGeneratorFunction(value)]
    ])
    for (let [key, value] of utilData) {
      if (value === true) {
        this.result = key
        break
      }
    }
    utilData = null
    return this.result
  }

  show() {
    let showResult: string = ''
    for (let i = 0; i < this.presetValue.length; i++) {
      let typeResult = this.check(this.presetValue[i])
      showResult = showResult + `${this.presetValue[i]} check success,this value type is ${typeResult}\n`
    }
    this.checkResult = showResult
  }

  build() {
    Button() {
      Text($r('app.string.check'))
        .fontColor(Color.Black)
        .fontSize(20)
        .textAlign(TextAlign.Center)
        .width('85%')
    }
    .type(ButtonType.Capsule)
    .backgroundColor('#0D9FFB')
    .padding(5)
    .margin({ top: 10 })
    .onClick(() => {
      this.show()
    })
  }
}