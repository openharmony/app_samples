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

@Component
export struct TitleBar {
  @Link webTitle: string

  build() {
    Column() {
      Text($r('app.string.entry_MainAbility'))
        .width('100%')
        .height(50)
        .padding(10)
        .fontSize(25)
        .fontColor(Color.White)
        .backgroundColor('#0D9FFB')
        .fontWeight(FontWeight.Bold)

      Row() {
        Text(this.webTitle)
          .height(40)
          .maxLines(1)
          .fontSize(20)
          .borderRadius(10)
          .margin({ top: 10, left: 5 })
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.White)
          .padding({ left: 20, right: 20 })
      }
      .width('100%')
      .height(40)
      .backgroundColor(Color.Gray)
    }
  }
}