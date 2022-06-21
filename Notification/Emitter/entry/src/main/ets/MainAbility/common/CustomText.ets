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
export struct CustomText {
  @State name: string = ''
  @State nameContent: string = ''
  @State color: string = ''
  private resource = 'app.string.' + this.name

  build() {
    Row() {
      Text($r(this.resource))
        .textAlign(TextAlign.End)
        .width('45%')
        .fontSize(20)
        .padding({ right: 20 })
      Text(this.nameContent)
        .textAlign(TextAlign.Start)
        .width('55%')
        .height(42)
        .fontSize(20)
        .fontColor(this.color)
    }
    .height('40%')
  }
}