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

import window from '@ohos.window'
import brightness from '@ohos.brightness'
import { LockSwitch } from '../common/LockSwitch'
import Logger from '../model/Logger'

const TAG: string = '[Setting]'

@Component
export struct Setting {
  @State flag: boolean= false
  @State inSetValue: number= 40

  brightness() {
    brightness.setValue(this.inSetValue)
  }

  build() {
    Column({ space: 10 }) {
      Divider()
        .strokeWidth(5)
        .color('#F1F3F5')
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('全屏')
          .fontSize('18vp')
        Toggle({ type: ToggleType.Switch, isOn: false })
          .switchPointColor(0xe5ffffff)
          .onChange(async () => {
            this.flag = !this.flag
            try {
              const win = await window.getTopWindow()
              await win.setFullScreen(this.flag)
            } catch (err) {
              Logger.info(TAG, `setFullScreen fail, code = ${err.code}`)
            }
          })
      }
      .height(62)
      .borderRadius(24)
      .margin({ top: 10 })
      .backgroundColor('#ffffff')
      .padding({ left: '3%', right: '3%' })

      Divider()
        .strokeWidth(5)
        .color('#F1F3F5')
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Lock()
      }
      .height(62)
      .borderRadius(24)
      .margin({ top: 10 })
      .backgroundColor('#ffffff')
      .padding({ left: '3%', right: '3%' })

      Divider()
        .strokeWidth(5)
        .color('#F1F3F5')
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('亮度')
          .fontSize('18vp')
        Slider({
          value: this.inSetValue,
          min: 0,
          max: 255,
          step: 5,
          style: SliderStyle.OutSet
        })
          .width('90%')
          .showTips(false)
          .showSteps(false)
          .blockColor(0xCCCCCC)
          .trackColor(Color.Black)
          .selectedColor(0xCCCCCC)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.inSetValue = value
            this.brightness()
          })
      }
      .height(62)
      .borderRadius(24)
      .margin({ top: 10 })
      .backgroundColor('#ffffff')
      .padding({ left: '3%', right: '3%' })

      Divider()
        .strokeWidth(5)
        .color('#F1F3F5')
    }
    .height('100%')
  }
}


@Component
struct Lock {
  @State isComTime: boolean= true

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Column() {
        LockSwitch({ isComTime: $isComTime })
      }
      .width('100%')
    }
  }
}