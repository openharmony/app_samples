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
import DataModel from '../data/DataModel'

const TAG: string = 'DistributedDataModel'

class DistributedDataModel {
  public documents: Array<DataModel> = []
  public distributedObject?: any
  public changeCallback?: () => void = null
  public statusCallback?: () => void = null

  constructor() {
    this.distributedObject = distributedObject.createDistributedObject({
      documents: this.documents
    })
    this.share()
  }

  share() {
    Logger.info(TAG, 'share start')
    this.distributedObject.setSessionId('123456789')
    Logger.info(TAG, `share setSessionId`)
  }

  clearCallback() {
    this.distributedObject.off('change')
    this.changeCallback = undefined
    this.distributedObject.off('status')
    this.statusCallback = undefined
  }

  onChangeCallback(callback) {
    if (this.changeCallback === callback) {
      Logger.info(TAG, 'setCallback same callback')
      return
    }
    if (this.changeCallback !== undefined) {
      Logger.info(TAG, 'setCallback start off')
      this.distributedObject.off('change', this.changeCallback)
    }
    this.changeCallback = callback
    Logger.info(TAG, 'setCallback start watch change')
    this.distributedObject.on('change', this.changeCallback)
  }

  onStatusCallback(callback) {
    if (this.statusCallback === callback) {
      Logger.info(TAG, 'setStatusCallback same callback')
      return
    }
    if (this.statusCallback !== undefined) {
      Logger.info(TAG, 'setStatusCallback start off')
      this.distributedObject.off('status', this.statusCallback)
    }
    this.statusCallback = callback
    Logger.info(TAG, 'setStatusCallback start watch change')
    this.distributedObject.on('status', this.statusCallback)
  }

  add(deviceId: string, screenSize: string, content: string) {
    Logger.info(TAG, `add start ${deviceId} ${screenSize} ${content} ${JSON.stringify(this.distributedObject.documents)}`)
    this.documents = this.distributedObject.documents
    let dataModel = new DataModel
    dataModel.deviceId = deviceId
    dataModel.screenSize = screenSize
    dataModel.content = content
    this.documents.push(dataModel)
    this.distributedObject.documents = this.documents
    Logger.info(TAG, `this.distributedObject.documents = ${JSON.stringify(this.distributedObject.documents)}`)
  }
}

export let distributedDataModel = new DistributedDataModel()
