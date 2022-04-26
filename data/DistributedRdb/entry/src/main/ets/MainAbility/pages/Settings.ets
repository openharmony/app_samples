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
import LiteStore from '../model/LiteStore'
import Logger from '../model/Logger'
import { SyncState } from '../model/LiteStore'
import { TitleBar } from '../common/TitleBar'

const TAG: string = 'Settings'

@Entry
@Component
struct Settings {
  @State syncState: string = SyncState.ManualSync

  aboutToAppear() {
    LiteStore.getValue().then((value) => {
      Logger.info(TAG, `liteStore getValue: ${value}`)
      this.syncState = `${value}`
      Logger.info(TAG, `liteStore this.syncState: ${this.syncState}`)
    })
  }

  @Builder SwitchBar(text, switchOn, onChange) {
    Row() {
      Text(text)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
      Column() {
        Toggle({ type: ToggleType.Switch, isOn: switchOn })
          .onChange(onChange)
      }
    }
    .width('95%')
    .padding(16)
    .margin({ top: 10 })
    .backgroundColor(Color.White)
    .borderRadius(16)
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true })
      this.SwitchBar($r('app.string.automatic'), this.syncState === SyncState.AutomaticSync, (isOn: boolean) => {
        Logger.info(TAG, `automatic swtich is: ${isOn}`)
        LiteStore.setValue(SyncState.AutomaticSync)
        this.syncState = SyncState.AutomaticSync
      })

      this.SwitchBar($r('app.string.manual'), this.syncState === SyncState.ManualSync, (isOn: boolean) => {
        Logger.info(TAG, `manualmatic swtich is: ${isOn}`)
        LiteStore.setValue(SyncState.ManualSync)
        this.syncState = SyncState.ManualSync
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F9F9F9')
  }
}