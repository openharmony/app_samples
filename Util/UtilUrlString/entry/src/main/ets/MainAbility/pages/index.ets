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

import {FirstOption} from '../common/paramOption'
const URL_NET: string= "https://gitee.com/openharmony"

@Entry
@Component
struct Index {
  @State output: string = URL_NET

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
          Text(this.output)
            .width('95%').height('30%')
            .fontSize(15)
            .padding(10)
            .margin({ left: 10, right: 10, top: 10 })
            .border({ width: 2, radius: 5, color: Color.Gray })
          Text(URL_NET).fontSize(15).margin({top:15}).fontWeight(FontWeight.Bold)
          FirstOption({outputs:$output})
        }
      }
    }
    .width('100%')
    .height('100%')
  }
}

