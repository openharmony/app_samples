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

@Component
export struct TitleBar {
  private batchInsertCallback = null

  build() {
    Row() {
      Text($r('app.string.title'))
        .fontColor(Color.White)
        .fontSize(20)
        .layoutWeight(1)
      Button() {
        Text($r('app.string.batch_insert'))
          .fontColor(Color.White)
          .fontSize(22)
          .textAlign(TextAlign.End)
      }
      .type(ButtonType.Normal)
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        if (this.batchInsertCallback !== null) {
          this.batchInsertCallback()
        }
      })
    }
    .height(50).width('100%')
    .backgroundColor('#0D9FFB')
    .padding({ left: 15, right: 15 })
  }
}