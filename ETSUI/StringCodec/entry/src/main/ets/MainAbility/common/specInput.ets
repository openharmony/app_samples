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
export struct SpecInput {

  private result_str:Resource = $r('app.string.result_f')
  @State specStrInput:string = ''

  build() {
    Row() {
      Text(this.result_str).width('30%').height(30).fontSize(15).textAlign(TextAlign.Start)
      Text(this.specStrInput)
        .width('70%')
        .height(30)
        .fontSize(15)
        .textAlign(TextAlign.Start)
        .border({ width: 2, radius: 5, color: "#0D9FFB" })
    }.margin({ top: 20 }).width(300)
  }
}