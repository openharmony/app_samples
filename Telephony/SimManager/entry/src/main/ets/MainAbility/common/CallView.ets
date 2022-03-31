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
export struct CallView {
  build() {
    Column() {
      Row() {
        Text($r('app.string.data'))
          .fontSize(20)
          .layoutWeight(1)
          .fontColor(Color.Gray)

        Text($r('app.string.sim1_id'))
          .fontSize(20)
          .fontColor(Color.Gray)
          .textAlign(TextAlign.End)
          .margin({ left: '20%' })

        Image($r('app.media.right'))
          .width(20)
          .height(20)
          .objectFit(ImageFit.Contain)
      }
      .margin({ bottom: 5 })

      Divider()
        .width('100%')
        .backgroundColor(Color.Black)

      Column() {
        Text($r('app.string.call'))
          .fontSize(20)
          .margin({ top: 5 })
          .fontColor(Color.Gray)

        Row() {
          Text($r('app.string.calling'))
            .fontSize(14)
            .layoutWeight(1)
            .fontColor(Color.Gray)

          Image($r('app.media.right'))
            .width(20)
            .height(20)
            .margin({ left: '20%' })
            .objectFit(ImageFit.Contain)
        }
      }
      .alignItems(HorizontalAlign.Start)
    }
    .margin(8)
    .padding(10)
    .width('95%')
    .borderRadius(10)
    .backgroundColor(Color.White)
  }
}