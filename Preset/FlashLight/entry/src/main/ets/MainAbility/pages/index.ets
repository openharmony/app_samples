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

import brightness from '@ohos.brightness'

@Entry
@Component
struct Index {
  @State flag: boolean = false
  @State textColor: string = '#ffffff'
  @State clockColor: string = '#ff000000'

  aboutToAppear() {
    brightness.setValue(128)
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Column() {
          Image($r('app.media.light'))
            .width('30%')
            .height('30%')
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              let value = 255
              this.textColor === '#ffffff' ? value = 255 : value = 128
              brightness.setValue(value)
              this.flag ? this.textColor = '#ffffff' : this.textColor = '#ff000000'
              this.flag = !this.flag
              this.textColor === '#ffffff' ? this.clockColor = '#ff000000' : this.clockColor = '#ffffff'
            })

          TextClock()
            .margin(10)
            .fontSize(40)
            .format('HH/mm')
            .fontColor(this.clockColor)
        }
      }
      .width('100%')
      .height('100%')
    }
    .backgroundColor(this.textColor)
  }
}