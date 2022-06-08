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
import router from '@ohos.router'
import TitleBar from '../../common/TitleBar'

export const SHARE_IMAGES = [
  $r('app.media.share1'),
  $r('app.media.share2'),
  $r('app.media.share3'),
  $r('app.media.share4'),
  $r('app.media.share5'),
  $r('app.media.share6')]

@Entry
@Component
struct ShareItem {
  build() {
    Column() {
      TitleBar({ hasBackPress: true })
      Text($r('app.string.share_transition_tips'))
        .fontColor(Color.Black)
        .fontSize(25)
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin(10)
      Grid() {
        ForEach(SHARE_IMAGES, (item, index) => {
          GridItem() {
            Image(item)
              .width(120)
              .aspectRatio(1)
              .sharedTransition(index.toString(), { duration: 600, curve: Curve.Smooth, delay: 100 })
          }
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(10)
          .onClick(() => {
            router.push({
              url: 'pages/share/SharePage',
              params: {
                index: index
              }
            })
          })
        }, item => JSON.stringify(item))
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .padding(10)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}