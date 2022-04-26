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
import featureAbility from '@ohos.ability.featureAbility'
import Logger from '../mode/Logger'
import { TitleBar } from '../common/TitleBar'

const TAG = "Index"

async function startServiceAbility() {
  Logger.info(TAG, '==========================>startAbility start=======================>')
  let StartAbilityParameter = {
    want: {
      bundleName: 'ohos.samples.backgroundtaskmanager',
      abilityName: 'ohos.samples.backgroundtaskmanager.ServiceAbility',
    }
  }
  let startNum = await featureAbility.startAbility(StartAbilityParameter)
  Logger.info(TAG, `==========================>startAbility end=======================> ${startNum}`)
}

@Entry
@Component
struct Index {
  build() {
    Column() {
      TitleBar()
      Image($r('app.media.file'))
        .width('100%')
        .height('30%')
        .margin({top:30})
        .objectFit(ImageFit.Contain)
      Text($r('app.string.fileName'))
        .fontSize(30)
      Button() {
        Text($r('app.string.download'))
        .fontSize(20)
      }
      .margin({ top: 60 })
      .type(ButtonType.Capsule)
      .backgroundColor('#0D9FFB')
      .size({width:'60%'})
      .onClick(() => {
        Logger.info(TAG, 'ServiceAbility Start')
        startServiceAbility()
      })
    }
    .width('100%')
    .height('100%')
  }
}