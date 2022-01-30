/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import { ShowKey } from '../common/showKey.ets'
import { CheckType } from '../common/checkType.ets'

let int8Array = new Int8Array(new ArrayBuffer(8))
let numVal = new Number(55)
let strVal = new String('sdsddadas')
let boolVal = new Boolean(true)
for (let i = 0; i < int8Array.length; i++) {
  int8Array[i] = i
}

@Entry
@Component
struct Index {
  @State checkResult: string = ''
  @State presetValue: Array<any> = [numVal, strVal, boolVal, int8Array]

  build() {
    Flex() {
      Column() {
        Text($r('app.string.entry_MainAbility'))
          .textAlign(TextAlign.Center)
          .width('100%')
          .height('6%')
          .backgroundColor('#0D9FFB')
          .fontSize(20)
          .fontColor(Color.Black)

        Scroll() {
          Column() {
            Text(this.checkResult)
              .width('90%')
              .height('65%')
              .fontSize(20)
              .margin(20)
              .padding({ left: 5, right: 5 })
              .border({ width: 2, radius: 15, color: Color.Gray })
          }
        }

        Column() {
          ShowKey({ presetValue: $presetValue, checkResult: $checkResult })
          CheckType({ presetValue: $presetValue, checkResult: $checkResult })
        }
      }
    }
    .width('100%')
    .height('100%')
  }
}
