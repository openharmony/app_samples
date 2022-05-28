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

import logger from '@ohos/log'
import { LogLevel } from '@ohos/log'
import { Configure }  from '@ohos/log'

const RUN_LENGTH: number = 20 //测试日志打印运行次数常量
let configure: Configure = {
  cheese: {
    types: ['file'],
    filename: 'index.log'
  },
  defaults: {
    appenders: 'Index',
    level: LogLevel.DEBUG
  }
}
logger.setConfigure(configure)

@Entry
@Component
struct Index {
  aboutToAppear() {
    for (let i = 0; i <= RUN_LENGTH; i++) {
      if ((i < 10)) { //测试日志打印运行次数常量
        logger.debug(`This is a debug message. Message number: ${i}`)
      } else {
        logger.warn(`This is a warning message. Message number: ${i}`)
      }
      for (let j = 0; j <= 4; j++) { //测试日志打印运行次数常量
        if ((j < 2)) { //测试日志打印运行次数常量
          logger.info(`This is a info message. Message number: ${j}`)
        } else {
          logger.fatal(`This is a fatal message. Message number: ${j}`)
        }
        logger.error(`This is a error message. i type of ${typeof (i)} j type of ${typeof (j)}`)
      }
    }
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.entry_MainAbility'))
          .fontSize(18)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
      }
      .height('6%')
      .width('100%')
      .padding({ left: 15 })
      .backgroundColor('#0D9FFB')
      .constraintSize({ minHeight: 50 })

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Text($r('app.string.log'))
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F1F1')
  }
}