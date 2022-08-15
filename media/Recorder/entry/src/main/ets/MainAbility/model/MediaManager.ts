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

import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import dataStorage from '@ohos.data.storage'
import featureAbility from '@ohos.ability.featureAbility'
import DateTimeUtil from '../model/DateTimeUtil'
import Logger from './Logger'
import { Record } from './Record'

const TAG = '[Recorder.MediaManager]'
let PATH: string = ''

class MediaManager {
  private mediaTest: mediaLibrary.MediaLibrary = mediaLibrary.getMediaLibrary()
  private storage: any = undefined

  constructor() {
    this.initStorage()
  }

  initStorage() {
    let context = featureAbility.getContext()
    context.getFilesDir().then(path => {
      PATH = path + '/'
      console.info(`${TAG}create store PATH=${PATH}`)
      this.storage = dataStorage.getStorageSync(path + '/myStore')
      console.info(`${TAG}create store success`)
    })
  }

  async createAudioFile() {
    this.mediaTest = mediaLibrary.getMediaLibrary()
    let info = {
      suffix: '.m4a', directory: mediaLibrary.DirectoryType.DIR_AUDIO
    }
    let dateTimeUtil = new DateTimeUtil()
    let name = `${dateTimeUtil.getDate()}_${dateTimeUtil.getTime()}`
    let displayName = `${name}${info.suffix}`
    Logger.info(TAG, `createAudioFile displayName=${displayName}`)
    let publicPath = await this.mediaTest.getPublicDirectory(info.directory)
    Logger.info(TAG, `createAudioFile publicPath=${publicPath}`)
    return await this.mediaTest.createAsset(mediaLibrary.MediaType.AUDIO, displayName, publicPath)
  }

  async queryAllAudios() {
    let fileKeyObj = mediaLibrary.FileKey
    let fetchOp = {
      selections: `${fileKeyObj.MEDIA_TYPE}=?`,
      selectionArgs: [`${mediaLibrary.MediaType.AUDIO}`],
    }
    const fetchFileResult = await this.mediaTest.getFileAssets(fetchOp)
    let result: Array<Record> = []
    Logger.info(TAG, `queryAllAudios fetchFileResult=${fetchFileResult.getCount()}`)
    if (fetchFileResult.getCount() > 0) {
      let fileAssets = await fetchFileResult.getAllObject()
      for (let i = 0; i < fileAssets.length; i++) {
        let record = new Record(fileAssets[i], false)
        result.push(record)
      }
    }
    return result
  }

  async queryFile(id: number) {
    let fileKeyObj = mediaLibrary.FileKey
    if (id !== undefined) {
      let args = id.toString()
      let fetchOp = {
        selections: `${fileKeyObj.ID}=?`,
        selectionArgs: [args],
      }
      const fetchFileResult = await this.mediaTest.getFileAssets(fetchOp)
      Logger.info(TAG, `fetchFileResult.getCount() = ${fetchFileResult.getCount()}`)
      const fileAsset = await fetchFileResult.getAllObject()
      return new Record(fileAsset[0], false)
    } else {
      return undefined
    }
  }

  deleteFile(uri) {
    Logger.info(TAG, `deleteFile,uri = ${uri}`)
    return this.mediaTest.deleteAsset(uri)
  }

  onAudioChange(callback: () => void) {
    this.mediaTest.on('audioChange', () => {
      callback()
    })
  }

  saveFileDuration(name: string, value) {
    this.storage.putSync(name, value)
    this.storage.flush()
  }

  getFileDuration(name: string) {
    return this.storage.getSync(name, '00:00')
  }
}

export default new MediaManager()