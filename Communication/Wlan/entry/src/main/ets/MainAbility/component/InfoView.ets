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
export struct InfoView {
  private infoList: Array<any> = []

  build() {
    Column() {
      ForEach(this.infoList, (item, index) => {
        Column() {
          Text(item.key)
            .fontColor(Color.Black)
            .fontSize(20)
            .width('100%')
          Text(item.value)
            .fontColor(Color.Black)
            .fontSize(20)
            .width('100%')
            .margin({ top: 5, bottom: 5 })
          if (index < this.infoList.length - 1) {
            Divider().color(Color.Grey)
          }
        }
        .padding(5)
      }, item => JSON.stringify(item))
    }
    .margin(10)
    .border({ width: 1, color: Color.Gray, radius: 15 })
  }
}