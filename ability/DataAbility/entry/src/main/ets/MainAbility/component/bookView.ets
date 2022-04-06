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

import { BookModel } from '../model/BookDataModel'

@Component
export struct BookView {
  private book: BookModel = null
  private deleteCallback = null

  build() {
    Row() {
      Image($r('app.media.book'))
        .height(110).width(80)
        .objectFit(ImageFit.Cover)
        .margin({ top: 5, bottom: 5 })
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
        Text(this.book.name)
          .fontColor(Color.Black)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
        Text(this.book.introduction)
          .fontColor(Color.Grey)
          .fontSize(20)
          .margin({ top: 10 })
      }
      .layoutWeight(1)
      .margin({ left: 5 })

      if (this.deleteCallback !== null) {
        Button() {
          Image($r('app.media.delete_red'))
            .height(35).width(35)
            .objectFit(ImageFit.Contain)
        }
        .type(ButtonType.Circle)
        .height(50).width(50)
        .backgroundColor('#F5F5F5')
        .onClick(() => {
          this.deleteCallback(this.book)
        })
      }
    }
    .width('100%')
    .padding({ left: 15, right: 15 })
  }
}