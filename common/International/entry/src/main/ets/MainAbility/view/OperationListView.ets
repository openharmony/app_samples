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
export default struct OperationListView {
  private title: string | Resource = ''
  private operations: Array<{
    key: string,
    value: string
  }> = []
  private handleItemClick: (index: number) => void

  @Builder
  OperationItem(operationInfo, index) {
    Column() {
      if (index !== 0) {
        Divider()
          .color(Color.Gray)
          .width('100%')
          .strokeWidth(1)
          .margin({ top: 10, bottom: 10 })
      }
      Text(operationInfo.key)
        .fontSize(25)
        .width('100%')
        .margin({ top: 10, bottom: 10 })
      if (operationInfo.value !== '') {
        Text(operationInfo.value)
          .fontColor(Color.Gray)
          .fontSize(25)
          .width('100%')
          .margin({ top: 10, bottom: 10 })
      }
    }
    .width('100%')
    .onClick(() => {
      if (this.handleItemClick) {
        this.handleItemClick(index)
      }
    })
  }

  build() {
    Column() {
      Text(this.title)
        .width('95%')
        .margin({ left: 10, top: 15 })
        .fontSize(22)
        .fontColor(Color.Gray)
      Column() {
        ForEach(this.operations, (item, index) => {
          this.OperationItem(item, index)
        }, item => item.key)
      }
      .width('95%')
      .backgroundColor(Color.White)
      .margin({ top: 10 })
      .padding(10)
      .border({ color: Color.White, width: 1, radius: 15 })
    }
  }
}