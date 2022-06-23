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
export struct EmoSitting {
  @Link isClickEmo: boolean
  @State focusIndex: number = 2
  @State onFocus: boolean = false
  @State array: Array<object> = [
    {
      icon: $r("app.media.icon"),
      num: -1
    },
    {
      icon: $r("app.media.icon"),
      num: 0
    },
    {
      icon: $r("app.media.icon"),
      num: 1
    },
    {
      icon: $r("app.media.icon"),
      num: 2
    },
  ]

  build() {
    Column() {
      Column() {
        if (this.focusIndex == 0) {
        } else if (this.focusIndex == 1) {
        } else if (this.focusIndex == 2) {
        }

      }.height("80%").width("100%")

      Row() {
        ForEach(this.array, (item, index) => {
          Flex({
            direction: FlexDirection.Row,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center
          }) {
            Image(item.icon)
              .width("40")
              .height("40")
          }.width("20%").height("100%")
          .backgroundColor(this.focusIndex == item.num ? '#e5e7e7' : Color.White)
          .onClick(() => {
            if (item.num >= 0) {
              this.focusIndex = item.num
            } else if (item.num == -1) {
              console.log("insert");
            }
          })
        })
        Row() {
          Text("返回").width("100%").textAlign(TextAlign.Center).fontSize(18)
        }.width("20%").height("100%").backgroundColor(Color.White)
        .onClick(() => {
          this.isClickEmo = false
        })
      }.width("100%").height("20%")
    }.height("100%").width("100%")
  }
}