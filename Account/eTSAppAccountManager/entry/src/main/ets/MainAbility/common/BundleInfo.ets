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

import router from '@system.router'

@Component
export struct BundleInfo {
  @State dataSet: Array<{
    img: Resource,
    text: Resource,
    name: string
  }> = [
    { img: $r('app.media.music'), text: $r('app.string.music'), name: 'music' },
    { img: $r('app.media.video'), text: $r('app.string.video'), name: 'video' },
    { img: $r('app.media.map'), text: $r('app.string.map'), name: 'map' }
  ]

  build() {
    Column() {
      ForEach(this.dataSet, item => {
        Row() {
          Image(item.img)
            .margin(10)
            .width('40%')
            .height('60%')
            .objectFit(ImageFit.Contain)

          Text(item.text)
            .margin(10)
            .fontSize(20)

          Image($r('app.media.right'))
            .margin(10)
            .width('15%')
            .height('20%')
            .layoutWeight(1)
            .objectFit(ImageFit.Contain)
        }
        .margin(5)
        .width('95%')
        .height('20%')
        .borderRadius(20)
        .backgroundColor('#f6f6f6')
        .onClick(() => {
          router.push({
            uri: 'pages/Login',
            params: {
              bundleName: item.name
            }
          })
        })
      }, item => item.name.toString())
    }
    .layoutWeight(1)
  }
}