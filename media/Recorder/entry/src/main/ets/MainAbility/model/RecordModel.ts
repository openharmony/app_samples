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

import media from '@ohos.multimedia.media'
import Logger from '../model/Logger'

const TAG: string = '[Recorder.RecordModel]'
let audioConfig = {
  audioSourceType: 1,
  audioEncoder: 3,
  audioEncodeBitRate: 22050,
  audioSampleRate: 22050,
  numberOfChannels: 2,
  format: 6,
  uri: ''
}

export class RecordModel {
  private audioRecorder = undefined

  initAudioRecorder() {
    this.release();
    this.audioRecorder = media.createAudioRecorder()
    Logger.info(TAG, 'create audioRecorder success')
  }

  release() {
    if (typeof (this.audioRecorder) != `undefined`) {
      Logger.info(TAG, 'case audioRecorder  release')
      this.audioRecorder.release()
      this.audioRecorder = undefined
    }
  }

  startRecorder(pathName, callback) {
    Logger.info(TAG, `enter the startRecorder,pathName=${pathName}, audioRecorder=${JSON.stringify(this.audioRecorder)}`)
    if (typeof (this.audioRecorder) != 'undefined') {
      Logger.info(TAG, 'enter the if')
      this.audioRecorder.on('prepare', () => {
        Logger.info(TAG, 'setCallback  prepare case callback is called')
        this.audioRecorder.start()
      })
      this.audioRecorder.on('start', () => {
        Logger.info(TAG, 'setCallback start case callback is called')
        callback()
      })
      Logger.info(TAG, 'start prepare')
      audioConfig.uri = pathName
      this.audioRecorder.prepare(audioConfig)
    } else {
      Logger.info(TAG, 'case failed, audioRecorder is null')
    }
  }

  pause(callback) {
    Logger.info(TAG, 'audioRecorder pause called')
    if (typeof (this.audioRecorder) != `undefined`) {
      this.audioRecorder.on('pause', () => {
        Logger.info(TAG, 'audioRecorder pause finish')
        callback()
      })
      this.audioRecorder.pause()
    }
  }

  resume(callback) {
    Logger.info(TAG, 'audioRecorder resume called')
    if (typeof (this.audioRecorder) != `undefined`) {
      this.audioRecorder.on('resume', () => {
        Logger.info(TAG, 'audioRecorder resume finish')
        callback()
      })
      this.audioRecorder.resume()
    }
  }

  finish(callback) {
    if (typeof (this.audioRecorder) != `undefined`) {
      this.audioRecorder.on('stop', () => {
        Logger.info(TAG, 'audioRecorder stop called')
        this.audioRecorder.release()
        callback()
      })
      this.audioRecorder.stop()
    }
  }
}