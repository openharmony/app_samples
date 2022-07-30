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
import Window from '@ohos.window'
import Logger from '../../../../../base/src/main/ets/default/utils/Logger'

const TAG: string = 'WindowManager'

export const WINDOW_NAMES = {
  HOME: 'Home'
}

export const WINDOW_PAGES = {
  HOME: 'pages/Home'
}

export default class WindowManager {
  private context: any = undefined

  constructor(context) {
    this.context = context
  }

  /**
 * 设置窗口大小
 *
 * @param width 窗口宽度
 * @param width 窗口高度
 */
  async setWindowSize(width: number, height: number): Promise<void> {
    const abilityWindow = await Window.getTopWindow(this.context)
    void abilityWindow.resetSize(width, height)
  }

  async createWindow(windowName: string, page: string, isFullScreen) {
    Logger.info(TAG, `createWindow, name: ${windowName}  page: ${page}`)
    try {
      let displayData = await display.getDefaultDisplay()
      let window = await Window.create(this.context, windowName, 2001)
      await window.resetSize(displayData.height, displayData.width)
      await window.loadContent(page)
      if (isFullScreen) {
        await window.setFullScreen(true)
      }
      await window.show()
    } catch (error) {
      Logger.error(TAG, `createWindow, create error: ${JSON.stringify(error)}`)
    }
  }

  async showOrCreateWindow(windowName: string, page: string, isFullScreen) {
    Logger.info(TAG, `showOrCreateWindow, name ${windowName}`)
    try {
      let window = await Window.find(windowName)
      await window.show()
    } catch (error) {
      Logger.error(TAG, `showWindow, show error: ${JSON.stringify(error)}`)
      await this.createWindow(windowName, page, isFullScreen)
    }
  }

  async hideWindow(windowName: string) {
    Logger.info(TAG, 'hideWindow')
    try {
      let window = await Window.find(windowName)
      await window.hide()
    } catch (error) {
      Logger.error(TAG, `showWindow, show error: ${JSON.stringify(error)}`)
    }
  }
}