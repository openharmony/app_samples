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

import { CallView } from '../common/callView'

@Entry
@Component
struct Index {
  @State input: string = ''
  @State output: string = `call information\n`

  build() {
    Flex() {
      Column() {
        Text($r('app.string.entry_MainAbility'))
          .width('100%')
          .height(50)
          .backgroundColor('#0D9FFB')
          .fontColor(Color.White)
          .fontSize(20)
          .padding({ left: 20 })
        Scroll() {
          Column() {
            TextInput({ placeholder: $r('app.string.input_hint') })
              .type(InputType.Number)
              .placeholderColor(Color.Grey)
              .placeholderFont({ size: 20, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal })
              .enterKeyType(EnterKeyType.Next)
              .caretColor('#0D9FFB')
              .height(60)
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .fontFamily("cursive")
              .maxLength(11)
              .margin({ left: 20, right: 20, top: 20, bottom: 20 })
              .onChange((value: string) => {
                this.input = value
              })
            CallView({ input: $input, output: $output })
            Text(this.output)
              .width('90%')
              .height('45%')
              .fontSize(20)
              .padding(15)
              .margin({ left: 20, right: 20, top: 20 })
              .border({ width: 2, radius: 15, color: Color.Grey })
          }
        }
      }
    }
    .height('100%')
    .width('100%')
  }
}