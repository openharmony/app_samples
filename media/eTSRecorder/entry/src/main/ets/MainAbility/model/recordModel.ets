/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

const TAG: string = '[Record.RecordModel]'
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
    console.info(`${TAG}create audioRecorder success`)
  }

  release() {
    if (typeof (this.audioRecorder) != `undefined`) {
      console.info(`${TAG}case audioRecorder  release`)
      this.audioRecorder.release()
      this.audioRecorder = undefined
    }
  }

  startRecorder(pathName, callback) {
    console.info(`${TAG}enter the startRecorder,audioRecorder=${JSON.stringify(this.audioRecorder)}`)
    console.info(`${TAG}typeof (this.audioRecorder)=${JSON.stringify(typeof (this.audioRecorder))}`)
    if (typeof (this.audioRecorder) != 'undefined') {
      console.info(`${TAG}enter the if`)
      this.audioRecorder.on('prepare', () => {
        console.info(`${TAG}setCallback  prepare case callback is called`)
        this.audioRecorder.start()
      })
      this.audioRecorder.on('start', () => {
        console.info(`${TAG}setCallback start case callback is called`)
        callback()
      })
      console.info(`${TAG}start prepare`)
      audioConfig.uri = pathName
      this.audioRecorder.prepare(audioConfig)
    } else {
      console.info(`${TAG}case failed, audioRecorder is null`)
    }
  }

  pause(callback) {
    console.info(`${TAG}audioRecorder pause called`)
    if (typeof (this.audioRecorder) != `undefined`) {
      this.audioRecorder.on('pause', () => {
        console.info(`${TAG}audioRecorder pause finish`)
        callback()
      })
      this.audioRecorder.pause()
    }
  }

  resume(callback) {
    console.info(`${TAG}audioRecorder resume called`)
    if (typeof (this.audioRecorder) != `undefined`) {
      this.audioRecorder.on('resume', () => {
        console.info(`${TAG}audioRecorder resume finish`)
        callback()
      })
      this.audioRecorder.resume()
    }
  }

  finish(callback) {
    if (typeof (this.audioRecorder) != `undefined`) {
      this.audioRecorder.on('stop', () => {
        console.info(`${TAG}audioRecorder stop called`)
        this.audioRecorder.release()
        callback()
      })
      this.audioRecorder.stop()
    }
  }
}