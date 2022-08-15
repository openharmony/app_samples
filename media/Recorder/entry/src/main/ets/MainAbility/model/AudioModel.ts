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
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../model/Logger'

const TAG: string = '[Recorder.AudioModel]'

export class AudioModel {
  private audioPlayer = undefined;
  private playFile: mediaLibrary.FileAsset = undefined
  private dataLoad: boolean = false

  initAudioPlayer(playSrc: mediaLibrary.FileAsset, isPlay) {
    this.playFile = playSrc
    this.dataLoad = false
    this.release()
    this.audioPlayer = media.createAudioPlayer()
    this.audioPlayer.on('dataLoad', () => {
      Logger.info(TAG, `case dataLoad called`)
      this.dataLoad = true
    })
    this.audioPlayer.on('stop', () => {
      Logger.info(TAG, `audioPlayer stop called`)
      this.audioPlayer.release()
      this.audioPlayer = undefined
    })
    this.audioPlayer.on('error', () => {
      Logger.info(TAG, `audioPlayer error called`)
    })
    this.audioPlayer.reset()
    let fdPath = playSrc.open('r')
    fdPath.then(fdNumber => {
      this.audioPlayer.src = `fd://${fdNumber}`
      Logger.info(TAG, `create audioPlayer success`)
    })
  }

  release() {
    if (typeof (this.audioPlayer) != `undefined`) {
      Logger.info(TAG, `audioPlayer  release`)
      this.audioPlayer.release()
      this.audioPlayer = undefined
    }
  }

  onFinish(callback) {
    console.info(`${TAG}set onFinish`)
    this.audioPlayer.on('finish', () => {
      Logger.info(TAG, `audioPlayer finish called`)
      this.audioPlayer.seek(0)
      callback()
    });
  }

  play(callback) {
    if (typeof (this.audioPlayer) != `undefined`) {
      this.audioPlayer.on('play', () => {
        Logger.info(TAG, `audioPlayer play called`)
        callback()
      })
      if (this.dataLoad) {
        this.audioPlayer.play()
      } else {
        this.audioPlayer.on('dataLoad', () => {
          Logger.info(TAG, `case dataLoad called`)
          this.dataLoad = true
          this.audioPlayer.play()
        })
      }
    }
  }

  pause(callback) {
    if (typeof (this.audioPlayer) != `undefined`) {
      this.audioPlayer.on('pause', () => {
        Logger.info(TAG, `case pause called`)
        callback()
      })
      this.audioPlayer.pause()
    }
  }

  finish() {
    if (typeof (this.audioPlayer) != `undefined`) {
      this.audioPlayer.stop()
    }
  }
}