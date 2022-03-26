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
export struct NavigationBar {
  private flag: boolean
  private title: Resource

  build() {
    Row() {
      if (this.flag) {
        Row() {
          Row() {
            Image($r('app.media.left'))
              .objectFit(ImageFit.Contain)
              .width('10%')
            Text($r('app.string.back'))
              .fontSize(18)
              .textAlign(TextAlign.End)
              .fontColor(Color.White)
          }
          .layoutWeight(1)
          .onClick(() => {
            router.back()
          })

          Text(this.title)
            .fontSize(18)
            .fontColor(Color.White)
            .textAlign(TextAlign.Start)
            .margin({ right: '5%', top: '15%' })
        }
        .height('8%')
        .width('100%')
        .padding({ left: 15 })
        .backgroundColor('#0D9FFB')
        .constraintSize({ minHeight: 50 })
      } else {
        Row() {
          Text(this.title)
            .fontSize(18)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
        }
        .height('8%')
        .width('100%')
        .padding({ left: 15 })
        .backgroundColor('#0D9FFB')
        .constraintSize({ minHeight: 50 })
      }
    }
  }
}