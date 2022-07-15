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

import hidebug from '@ohos.hidebug'
import DebugInfo from '../component/DebugInfo'

@Entry
@Component
struct Index {
  @State pssMemory: number = 0
  @State sharedMemory: number = 0
  @State privateMemory: number = 0
  @State debugWindow: boolean = false

  build() {
    Column() {
      Row() {
        Text($r('app.string.MainAbility_label'))
          .margin(4)
          .fontSize(20)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)

        Blank()

        Image($r('app.media.debug'))
          .key('Debug')
          .width('10%')
          .margin({ right: 4 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.debugWindow = !this.debugWindow
            if (this.debugWindow) {
              let pss = hidebug.getPss()
              this.pssMemory = Number(pss !== null ? pss : -1) // -1代表getPss()接口返回值错误
              let sharedDirty = hidebug.getSharedDirty()
              this.sharedMemory = Number(sharedDirty !== null ? sharedDirty : -1) // -1代表getSharedDirty()接口返回值错误
              let privateDirty = hidebug.getPrivateDirty()
              this.privateMemory = Number(privateDirty !== null ? privateDirty : -1) // -1代表getPrivateDirty()接口返回值错误
            }
          })
      }
      .height('6%')
      .width('100%')
      .padding({ right: 10 })
      .backgroundColor('#0D9FFB')
      .constraintSize({ minHeight: 50 })

      // 显示Debug信息窗口
      DebugInfo({
        pssMemory: this.pssMemory,
        sharedMemory: this.sharedMemory,
        debugWindow: this.debugWindow,
        privateMemory: this.privateMemory
      })
    }
    .width('100%')
    .height('100%')
  }
}