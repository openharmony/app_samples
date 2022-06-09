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
export struct TextAreaShow {
  @Link value: string
  private placeholder?: string

  build() {
    Row() {
      TextArea({ placeholder: this.placeholder })
        .height(40)
        .width('70%')
        .fontSize(30)
        .margin({ top: 15 })
        .fontColor(Color.Black)
        .caretColor(Color.Blue)
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Bold)
        .fontStyle(FontStyle.Normal)
        .placeholderFont({ size: 20, weight: 50, style: FontStyle.Italic })
        .onChange((value: string) => {
          this.value = value
        })
    }
  }
}