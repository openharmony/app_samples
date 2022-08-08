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
export struct Cart {
  @Prop ratio: number

  build() {
    Column() {
      Row() {
        Toggle({ type: ToggleType.Checkbox })
          .width(20 * this.ratio)
          .aspectRatio(1)
          .selectedColor('red')

        Image($r('app.media.shopUser'))
          .width(30 * this.ratio)
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
          .margin({ left: '5vp', right: '8vp' })
        Text($r('app.string.shopping_self_support'))
          .fontSize(14 * this.ratio)
      }
      .width('100%')

      Row() {
        Toggle({ type: ToggleType.Checkbox })
          .width(20 * this.ratio)
          .selectedColor('red')
          .aspectRatio(1)
        Image($r('app.media.product005'))
          .width(90 * this.ratio)
          .aspectRatio(0.8)
          .objectFit(ImageFit.Contain)
          .margin({ left: 5 * this.ratio })

        Column() {
          Text($r('app.string.phone_name'))
            .fontSize(14 * this.ratio)
            .fontWeight(400)
            .width('100%')
            .margin({ top: 20 })

          Text($r('app.string.phone_size'))
            .width('100%')
            .fontSize(12 * this.ratio)
            .opacity(0.6)
            .margin({ top: 20 })

          Row() {
            Text($r('app.string.phone_price'))
              .fontSize(18 * this.ratio)
              .fontColor('#EA314D')
              .fontWeight(FontWeight.Medium)
            Blank()
            Row() {
              Image($r('app.media.reduce'))
                .width('30vp')
                .height('30vp')
                .objectFit(ImageFit.Contain)
              Text(`${1}`)
                .margin({ left: '10vp', right: '10vp' })
                .fontSize(12 * this.ratio)
              Image($r('app.media.add'))
                .width('30vp')
                .height('30vp')
                .objectFit(ImageFit.Contain)
            }
          }
          .width('100%')
          .margin({ top: 20 })
        }
        .layoutWeight(1)
        .margin({ left: 5 * this.ratio, bottom: 10 })
      }
      .width('100%')
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .padding(10)
    .margin({ top: 5 })
  }
}