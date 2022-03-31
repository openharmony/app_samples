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

import { TitleBar } from '../component/TitleBar'
import { Operation } from '../component/Operation'

@Entry
@Component
struct Index {
  @State resultText: string = ''

  build() {
    Column() {
      TitleBar()
      Scroll() {
        Column() {
          Text(this.resultText)
            .width('90%')
            .fontSize(16)
            .margin({ top: 10 })
            .constraintSize({ minHeight: 200 })
            .border({ width: 1, color: Color.Gray, radius: 15 })
            .padding(15)
          Operation({ resultText: $resultText })
        }
      }
      .layoutWeight(1)
    }
    .width('100%').height('100%')
  }
}