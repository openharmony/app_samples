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

import display from '@ohos.display'
import Logger from '../model/Logger'
import { ShowInfo } from '../common/ShowInfo'
import { DisplayModel } from '../model/DisplayModel'

const TAG: string = '[DisplayDevice]'

@Component
export struct DisplayDevice {
  @State devices: number[] = []
  private screenIds: number[] = []
  private allScreens: display.Display[] = []
  private defaultScreens: display.Display = undefined
  private defaultOrAllScreen: boolean = false
  private displayModel: DisplayModel = new DisplayModel()
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ShowInfo({
      defaultScreens: this.defaultScreens,
      allScreens: this.allScreens,
      defaultOrAllScreen: this.defaultOrAllScreen
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default
  })

  addWatch() {
    display.on('add', (data) => {
      if (this.devices.length < 3) {
        this.devices.push(this.screenIds[this.screenIds.length - 1])
        Logger.info(TAG, `this push devices = ${JSON.stringify(this.devices)} this id = ${data}`)
      } else {
        Logger.info(TAG, `this screen's number is exceed three`)
      }
    })
  }

  removeWatch() {
    display.on('remove', (result) => {
      this.devices.pop()
      this.screenIds.pop()
      Logger.info(TAG, `this pop devices = ${JSON.stringify(this.devices)} this screenIds = ${JSON.stringify(this.screenIds)} result = ${result}`)
    })
  }

  aboutToAppear() {
    this.addWatch()
    this.removeWatch()
  }

  async getDefaultScreen() {
    this.defaultOrAllScreen = true
    this.defaultScreens = await display.getDefaultDisplay()
    Logger.info(TAG, `This getDefaultScreen = ${JSON.stringify(this.defaultScreens)}`)
  }

  async getAllScreen() {
    this.defaultOrAllScreen = false
    this.allScreens = await display.getAllDisplay()
    Logger.info(TAG, `This getAllScreen = ${JSON.stringify(this.allScreens)}`)
  }

  build() {
    Column() {
      Row() {
        Rect({ width: '34%', height: '17%' })
          .margin({ top: '10%', left: 4, right: 4, bottom: 4 })
          .fill('#5dbbff')
          .onClick(async () => {
            await this.getDefaultScreen()
            Logger.info(TAG, `defaultOrAllScreen = ${this.defaultOrAllScreen}`)
            this.dialogController.open()
          })

        ForEach(this.devices, item => {
          Rect({ width: '18%', height: '9%' })
            .margin({ top: '10%', left: 4, right: 4, bottom: 4 })
            .fill('#5dbbff')
            .onClick(async () => {
              await this.getAllScreen()
              Logger.info(TAG, `defaultOrAllScreen = ${this.defaultOrAllScreen}`)
              this.dialogController.open()
            })
        }, item => item.toString())
      }
      .margin({ top: 10, bottom: '8%' })

      Button($r('app.string.add_screen'))
        .width('58%')
        .height('6%')
        .fontSize(18)
        .margin({ top: 10, left: 4, right: 4, bottom: '8%' })
        .onClick(async () => {
          let result = await this.displayModel.createVirtualScreen(this.screenIds.length)
          Logger.info(TAG, `this createVirtualScreen screen id = ${JSON.stringify(this.screenIds)}`)
          this.screenIds.push(result.id)
        })

      Button($r('app.string.remove_screen'))
        .width('58%')
        .height('6%')
        .fontSize(18)
        .margin({ top: 10, left: 4, right: 4, bottom: 4 })
        .onClick(async () => {
          await this.displayModel.destroyVirtualScreen(this.screenIds[this.screenIds.length - 1])
          Logger.info(TAG, `this after destroyVirtualScreen screen id = ${JSON.stringify(this.screenIds)}`)
        })
    }
  }
}
