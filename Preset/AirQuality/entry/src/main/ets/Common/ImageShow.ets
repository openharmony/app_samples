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

import  BaseModel  from '../Model/BaseModel'

@Extend(Text) function fancyText (fontSize: number, margin: number) {
  .width('100%')
  .height(40)
  .textAlign(TextAlign.Center)
  .fontSize(fontSize)
  .margin({ top: margin })
}

@Component
export struct ImageShow {
  @State quality: BaseModel = undefined
  private cityIndex: number
  public values: Array<Array<number>> = [
    [0, 0, 0, 0, 0, 0, 40, 0, 60],
    [0, 60, 0, 0, 0, 0, 0, 0, 40]
  ]

  build() {
    Column() {
      Row() {
        Text(this.quality.city)
          .width('100%')
          .height(40)
          .fontSize(35)
          .fontWeight(500)
          .textAlign(TextAlign.Center)
      }
      .height(40)
      .width('100%')
      .margin({ top: 30 })

      Stack({ alignContent: Alignment.Top }) {
        DataPanel({ values: this.values[this.cityIndex], max: 100, type: DataPanelType.Circle })
          .width(200)
          .height(200)
          .margin(10)
        Text($r('app.string.aqi'))
          .fancyText(30, 40)
        Text(this.quality.aqi)
          .fancyText(40, 90)
        Text(this.quality.category)
          .fancyText(30, 140)
      }
      .margin({ top: 10 })
    }
  }
}