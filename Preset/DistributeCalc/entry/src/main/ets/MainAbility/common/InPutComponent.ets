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
export struct InPutComponent {
  private isLand: boolean = false
  @Link result: string
  @Link expression: string

  build() {
    Stack({ alignContent: this.isLand ? Alignment.BottomStart : Alignment.TopEnd }) {
      Column() {
        Scroll() {
          Text(this.expression)
            .maxLines(1)
            .opacity(0.9)
            .fontWeight(400)
            .textAlign(TextAlign.Start)
            .fontSize(this.isLand ? 50 : 35)
        }
        .width('90%')
        .scrollable(ScrollDirection.Horizontal)
        .align(this.isLand ? Alignment.Start : Alignment.End)

        Scroll() {
          Text(this.result)
            .maxLines(1)
            .opacity(0.38)
            .textAlign(TextAlign.Start)
            .fontSize(this.isLand ? 45 : 30)
            .margin(this.isLand ? { bottom: 64 } : {})
        }
        .width('90%')
        .scrollable(ScrollDirection.Horizontal)
        .align(this.isLand ? Alignment.Start : Alignment.End)
      }
      .width('100%')
      .align(Alignment.Center)
    }
    .width(this.isLand ? '45%' : '100%')
    .height(this.isLand ? '100%' : '30%')
  }
}