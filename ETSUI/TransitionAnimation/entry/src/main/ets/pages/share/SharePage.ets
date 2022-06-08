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
import { SHARE_IMAGES } from './ShareItem'

@Entry
@Component
struct SharePage {
  private index: number = router.getParams()['index']

  build() {
    Column() {
      TitleBar({ hasBackPress: true })
      Row() {
        Image(SHARE_IMAGES[this.index])
          .width('100%')
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
          .sharedTransition(this.index.toString(), { duration: 600, curve: Curve.Smooth, delay: 100 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}