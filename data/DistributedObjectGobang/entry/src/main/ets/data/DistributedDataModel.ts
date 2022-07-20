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

import distributedObject from '@ohos.data.distributedDataObject'
import Logger from '../data/Logger'
import {distributedConst} from '../data/DistributedConst'

const TAG: string = 'DistributedDataModel'

function initArray(size, value) {
  return Array.from({ length: size }, () => Array.from({ length: size }, () => value))
}

class DistributedDataModel {
  public island: boolean = false
  public isPlay: boolean = false
  public whichChess: number = 0
  public message: Resource | undefined = undefined
  public chessBoard: Array<Array<number>> = initArray(distributedConst.SIZE, 0)
  public distributedObject?: any
  public changeCallback: () => {}
  public statusCallback: () => {}

  constructor() {
    this.distributedObject = distributedObject.createDistributedObject({
      isPlay: this.isPlay,
      chessBoard: this.chessBoard,
      whichChess: this.whichChess,
      message: this.message
    })
    this.share()
  }

  share() {
    globalThis.abilityContext.requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'], () => {
      this.distributedObject.setSessionId('123456789')
    })
  }

  onChangeCallback(callback) {
    if (this.changeCallback !== undefined) {
      this.distributedObject.off('change', this.changeCallback)
      Logger.info(TAG, `off change success`)
    }
    this.changeCallback = callback
    Logger.info(TAG, `call back = ${JSON.stringify(callback)}`)
    this.distributedObject.on('change', this.changeCallback);
  }

  onStatusCallback(callback) {
    if (this.statusCallback === callback) {
      return
    }
    if (this.statusCallback !== undefined) {
      this.distributedObject.off('status', this.statusCallback)
    }
    this.statusCallback = callback
    this.distributedObject.on('status', this.statusCallback)
  }
}

export let objectModel = new DistributedDataModel()