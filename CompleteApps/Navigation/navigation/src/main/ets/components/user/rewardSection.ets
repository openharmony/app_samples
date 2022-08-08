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
export struct rewardSectionComponent {
  @Prop ratio: number

  build() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Column() {
        Image($r('app.media.vip_channel'))
          .aspectRatio(1)
          .width(40 * this.ratio)
          .objectFit(ImageFit.Contain)
        Text($r("app.string.vip_channel"))
          .margin({ top: '6vp' })
          .fontSize(16)
      }
      .width('20%')
      .height('100%')
      .justifyContent(FlexAlign.Center)

      Column() {
        Image($r('app.media.PointReward'))
          .aspectRatio(1)
          .width(40 * this.ratio)
          .objectFit(ImageFit.Contain)
        Text($r("app.string.PointReward"))
          .margin({ top: '6vp' })
          .fontSize(16)
      }
      .width('20%')
      .height('100%')
      .justifyContent(FlexAlign.Center)

      Column() {
        Image($r('app.media.interaction'))
          .aspectRatio(1)
          .width(40 * this.ratio)
          .objectFit(ImageFit.Contain)
        Text($r("app.string.interaction"))
          .margin({ top: '6vp' })
          .fontSize(16)
      }
      .width('20%')
      .height('100%')
      .justifyContent(FlexAlign.Center)

      Column() {
        Image($r('app.media.cardVolumn'))
          .aspectRatio(1)
          .width(40 * this.ratio)
          .objectFit(ImageFit.Contain)
        Text($r("app.string.cardVolume"))
          .margin({ top: '6vp' })
          .fontSize(16)
      }
      .width('20%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
  }
}