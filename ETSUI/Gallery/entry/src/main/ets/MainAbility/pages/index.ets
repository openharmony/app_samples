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

import router from '@system.router';

@Entry
@Component
struct IndexSample {
  @State opacity: number = 0;

  onPageShow() {
    animateTo({
      duration: 3000,
      onFinish: () => {
        router.replace({ uri: 'pages/home' })
      }
    }, () => {
      this.opacity = 1;
    })
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {

        Image($r('app.media.homeAnimation'))
          .width('83.3%')
          .height('42%')
          .objectFit(ImageFit.Contain)

        Text('ArKUI')
          .fontColor('#000000')
          .fontSize('20fp')
          .fontWeight(FontWeight.Medium)
          .opacity(0.8)
          .margin({ top: '4%', bottom: '2%' })

        Text($r('app.string.first_description'))
          .width('83.3%')
          .fontSize('16fp')
          .fontColor('#000000')
          .fontWeight(FontWeight.Regular)
          .opacity(0.4)
          .textAlign(TextAlign.Center)

      }.width('100%').height('100%').margin({ top: '6%' }).opacity(this.opacity)
    }
    .padding({ left: '8.3%', right: '8.3%' })
    .width('100%')
    .height('100%')
  }
}