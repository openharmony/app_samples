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

import prompt from '@system.prompt';

@Entry
@Component
struct CounterPage {
  @State value: number = 0

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Counter() {
          Text(`${this.value}`)
            .fontSize(15)
        }
        .onInc(() => {
          this.value++
          prompt.showToast({
            message: '数值增加'
          })
        })
        .onDec(() => {
          this.value--
          prompt.showToast({
            message: '数值减少'
          })
        })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 10 })
    }
    .width('100%')
  }
}