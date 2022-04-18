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
import faultLogger from '@ohos.faultLogger'
import Logger from '../model/Logger'
import { TitleBar } from '../common/TitleBar'
import { FaultDialog } from '../common/FaultDialog'

const TAG: string = 'Index'

@Entry
@Component
struct Index {
  @State message: string = 'FaultLog'
  private operates: Array<Resource> = [$r('app.string.create_fault'), $r('app.string.catch_js_fault'),
  $r('app.string.catch_cpp_fault'), $r('app.string.catch_app_freeze_fault'), $r('app.string.catch_all_fault')]
  private faultDialogController: CustomDialogController = null

  async catchFaultLog(faultType) {
    this.message = ''
    let value = await faultLogger.querySelfFaultLog(faultType)
    if (value) {
      let len = value.length;
      if(len === 0) {
        this.message = '未获取到异常日志'
      }
      for (let i = 0; i < len; i++) {
        this.message = `Log pid: ${value[i].pid}\nLog type:${value[i].type}\n Log reason: ${value[i].reason}\n` +
        `Log module: ${value[i].module}\nLog text:\n ${value[i].fullLog} `
      }
    }
  }

  handleOperate(index) {
    switch (index) {
      case 0:
        if (this.faultDialogController === null) {
          this.faultDialogController = new CustomDialogController({
            builder: FaultDialog(),
            autoCancel: true })
        }
        this.faultDialogController.open()
        break
      case 1:
        Logger.info(TAG, 'catch JS_CRASH')
        this.catchFaultLog(faultLogger.FaultType.JS_CRASH)
        break
      case 2:
        Logger.info(TAG, 'catch CPP_CRASH')
        this.catchFaultLog(faultLogger.FaultType.CPP_CRASH)
        break
      case 3:
        Logger.info(TAG, 'catch APP_FREEZE')
        this.catchFaultLog(faultLogger.FaultType.APP_FREEZE)
        break
      case 4:
        Logger.info(TAG, 'catch NO_SPECIFIC')
        this.catchFaultLog(faultLogger.FaultType.NO_SPECIFIC)
        break
      default:
        break
    }
  }

  build() {
    Column() {
      TitleBar()
      Scroll() {
        Text(this.message)
          .textAlign(TextAlign.Start)
          .width('100%')
          .fontSize(22)
      }
      .size({ width: '95%', height: '35%' })
      .border({ width: 1, radius: 20, color: Color.Black })
      .padding(10)
      .margin({ top: 16 })

      Scroll() {
        Column() {
          ForEach(this.operates, (item, index) => {
            Button(item)
              .type(ButtonType.Capsule)
              .size({ width: '90%', height: 60 })
              .margin({ top: 10 })
              .onClick(() => {
                this.handleOperate(index)
              })
          }, item => JSON.stringify(item))
        }
        .width('100%')
        .padding({ bottom: '8%' })
      }
      .size({ width: '95%', height: '50%' })
    }
    .width('100%')
    .height('100%')
  }
}