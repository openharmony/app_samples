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
import {PublishEventView} from '../common/publishEvent'
import {SubsrcibeEventView} from '../common/subsrcibeEvent'

@Entry
@Component
struct Index {
  @State result: string = ''

  build() {
    Column() {
      Text($r("app.string.entry_MainAbility"))
        .width('100%')
        .height(50)
        .backgroundColor('#0D9FFB')
        .fontColor(Color.White)
        .fontSize(20)
        .padding({ left: 15 })
      Scroll() {
        Column() {
          SubsrcibeEventView({ result: $result })

          Line()
            .width('100%').height(2)
            .backgroundColor('#D5D5D5')
            .margin({ top: 15})

          PublishEventView()

          Text(this.result)
            .width('100%')
            .height(150)
            .backgroundColor('#DFDFDF')
            .fontSize(20)
            .margin({ top: 20 })
            .textAlign(TextAlign.Start)
            .padding(10)
        }.constraintSize({ minHeight: '100%' })
      }
      .width('100%').height('100%')
      .padding({ left: 15, right: 15, bottom: 15 })
    }
  }
}