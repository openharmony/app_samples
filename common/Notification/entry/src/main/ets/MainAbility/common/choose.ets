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
export struct Choose {
  @Link selectIndex: number

  getImg(current) {
    if (this.selectIndex === current) {
      return $r("app.media.checked")
    } else {
      return $r("app.media.uncheck")
    }
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column }) {
        Text($r("app.string.choose_notification_type"))
          .width(300)
          .padding({ top: 10 })
          .fontSize(20)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
        Column() {
          Row() {
            Image(this.getImg(0))
              .height(30).width(30)
              .objectFit(ImageFit.Contain)
            Text($r("app.string.notification_type_normal"))
              .padding(10)
              .fontSize(20)
              .fontColor(Color.Black)
          }
          .width(300)
          .onClick(() => {
            this.selectIndex = 0
          })

          Row() {
            Image(this.getImg(1))
              .height(30).width(30)
              .objectFit(ImageFit.Contain)
            Text($r("app.string.notification_type_long_text"))
              .padding(10)
              .fontSize(20)
              .fontColor(Color.Black)
          }
          .width(300)
          .onClick(() => {
            this.selectIndex = 1
          })

          Row() {
            Image(this.getImg(2))
              .height(30).width(30)
              .objectFit(ImageFit.Contain)
            Text($r("app.string.notification_type_multiline"))
              .padding(10)
              .fontSize(20)
              .fontColor(Color.Black)
          }.width(300)
          .onClick(() => {
            this.selectIndex = 2
            console.info('this.selectIndex = ' + this.selectIndex)
          })
        }
      }
    }
  }
}