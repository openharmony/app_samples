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
import { Texts } from '../common/component.ets'
import { ButtonComponent } from '../common/button.ets'

@Entry
@Component
struct Index {
  @State textTitle: string = ''

  build() {
    Scroll() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Text($r('app.string.rationalNumber'))
          .width('100%')
          .fontSize(32)
          .textAlign(TextAlign.Start)
          .margin({ top: 20, bottom: 20 })

        Texts({ Numerator: '1', Denominator: '2' })

        Text($r('app.string.rationalNumber'))
          .width('100%')
          .fontSize(32)
          .textAlign(TextAlign.Start)
          .margin({ bottom: 20 })

        Texts({ Numerator: '3', Denominator: '4' })

        Text(this.textTitle)
          .border({ width: 1, color: '#000000', radius: 10, style: BorderStyle.Solid })
          .width('80%').height('100')
          .fontSize(30)
          .margin({ top: 20 })
          .textAlign(TextAlign.Center)

        ButtonComponent({ textTitle: $textTitle })
      }
    }
  }
}