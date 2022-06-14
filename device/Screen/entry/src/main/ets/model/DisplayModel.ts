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

import screen from '@ohos.screen'
import Logger from '../model/Logger'

const TAG: string = '[DisplayModel]'

export class DisplayModel {
  async createVirtualScreen(id: number) {
    let result = await screen.createVirtualScreen({
      name: `screen_${id}`,
      width: 480,
      height: 360,
      density: 60,
      surfaceId: `${id}`
    })
    Logger.info(TAG, `createVirtualScreen screen.id = ${result.id}`)
    let info = await screen.makeExpand([{ screenId: result.id, startX: 0, startY: 0 }])
    Logger.info(TAG, `makeExpand number = ${info}`)
    return result
  }

  async destroyVirtualScreen(id: number) {
    await screen.destroyVirtualScreen(id)
    Logger.info(TAG, `destroyVirtualScreen is success`)
  }
}