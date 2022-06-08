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
export struct Element {
  @Builder dateText(text: string, margin: number) {
    Text(text)
      .height(100)
      .width("14%")
      .margin({ left: margin })
      .textAlign(TextAlign.Center)
      .fontSize(15)
  }

  build() {
    Row() {
      this.dateText('CO', 0)
      this.dateText('SO2', 5)
      this.dateText('PM10', 5)
      this.dateText('PM2.5', 5)
      this.dateText('NO2', 5)
    }
    .width('100%')
  }
}