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

@Entry
@Component
struct BlankPage {
  @State minLength: number = 0
  @State blankFront: boolean = true
  @State blankMiddle: boolean = true
  @State blankBehind: boolean = true

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Row() {
          if (this.blankFront) {
            Blank(this.minLength)
              .width(0)
              .backgroundColor(Color.Orange)
          }
          Image($r('app.media.test'))
            .width(80)
            .height(80)
            .objectFit(ImageFit.Contain)
          if (this.blankMiddle) {
            Blank(this.minLength)
              .width(0)
              .backgroundColor(Color.Orange)
          }
          Image($r('app.media.test'))
            .width(80)
            .height(80)
            .objectFit(ImageFit.Contain)
          if (this.blankBehind) {
            Blank(this.minLength)
              .width(0)
              .backgroundColor(Color.Orange)
          }
        }
        .width('100%')
        .border({ width: 1 })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5, color: Color.Orange, radius: 10, style: BorderStyle.Dotted })

      Column() {
        Text('blank组件是否存在：')
          .fontSize(15)
          .backgroundColor(0xFAEEE0)
          .width('100%')
          .height(40)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bolder)
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
          Button(`front：${this.blankFront}`)
            .fontSize(15)
            .margin({right:10})
            .onClick(() => {
              this.blankFront = !this.blankFront
            })
          Button(`middle：${this.blankMiddle}`)
            .fontSize(15)
            .margin({right:10})
            .onClick(() => {
              this.blankMiddle = !this.blankMiddle
            })
          Button(`behind：${this.blankBehind}`)
            .fontSize(15)
            .onClick(() => {
              this.blankBehind = !this.blankBehind
            })
        }
        .margin({ top: 5, bottom: 5,left: 10  })

        Text(`blank组件的min值：${this.minLength}`)
          .fontSize(15)
          .backgroundColor(0xFAEEE0)
          .width('100%')
          .height(40)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bolder)
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
          Slider({ value: this.minLength, step: 1, min: -10, max: 300 })
            .blockColor(Color.Orange)
            .onChange((e) => {
              this.minLength = Math.round(e)
            })
        }
        .margin({ top: 5, bottom: 5,left: 10  })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 20 })
      .width('100%')
    }
    .margin(5)
    .width('100%')
  }
}