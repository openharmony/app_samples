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
export struct ServiceSectionComponent {
  @Prop ratio: number

  build() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Column() {
        Image($r('app.media.officialService'))
          .width(45 * this.ratio)
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
        Text($r("app.string.officialService"))
          .fontSize(16)
          .margin({ top: '6vp' })
      }
      .width('20%')
      .height('100%')
      .justifyContent(FlexAlign.Center)

      Column() {
        Image($r('app.media.cash'))
          .width(45 * this.ratio)
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
        Text($r("app.string.cash"))
          .fontSize(16)
          .margin({ top: '6vp' })
      }
      .width('20%')
      .height('100%')
      .justifyContent(FlexAlign.Center)

      Column() {
        Image($r('app.media.oldForNew'))
          .width(45 * this.ratio)
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
        Text($r("app.string.oldForNew"))
          .fontSize(16)
          .margin({ top: '6vp' })
      }
      .width('20%')
      .height('100%')
      .justifyContent(FlexAlign.Center)

      Column() {
        Image($r('app.media.my_evaluation'))
          .width(45 * this.ratio)
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
        Text($r("app.string.my_evaluation"))
          .fontSize(16)
          .margin({ top: '6vp' })
      }
      .width('20%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
  }
}