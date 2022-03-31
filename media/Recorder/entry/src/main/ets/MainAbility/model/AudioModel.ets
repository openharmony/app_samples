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
import {getFdNumber} from '../model/Utils'

const TAG: string = '[Record.AudioModel]'

export class AudioModel {
  private audioPlayer = undefined;
  private playPath: string = ''
  public isPlay: boolean = false

  initAudioPlayer(playSrc: string, isPlay) {
    this.playPath = playSrc
    this.isPlay = isPlay
    this.release();
    this.audioPlayer = media.createAudioPlayer()
    this.audioPlayer.on('dataLoad', () => {
      console.info(`${TAG}case dataLoad called`)
      if (this.isPlay) {
        this.audioPlayer.play()
      }
    })
    this.audioPlayer.on('pause', () => {
      console.info(`${TAG}case pause called`)
    })
    this.audioPlayer.on('play', () => {
      console.info(`${TAG}case play called`)
    })
    this.audioPlayer.on('stop', () => {
      console.info(`${TAG}audioPlayer stop called`)
      this.audioPlayer.release()
      this.audioPlayer = undefined
    })
    this.audioPlayer.on('error', () => {
      console.info(`${TAG}audioPlayer error called`)
    })
    this.audioPlayer.reset()
    let fdPath = getFdNumber(playSrc)
    fdPath.then(fdNumber=>{
      this.audioPlayer.src = fdNumber
      console.info(`${TAG}create audioPlayer success`)
    })
  }

  release() {
    if (typeof (this.audioPlayer) != `undefined`) {
      console.info(`${TAG}audioPlayer  release`)
      this.audioPlayer.release()
      this.audioPlayer = undefined
    }
  }

  onFinish(callback) {
    console.info(`${TAG}set onFinish`)
    this.audioPlayer.on('finish', () => {
      console.info(`${TAG}audioPlayer finish called`)
      this.audioPlayer.seek(0)
      callback()
    });
  }

  onPlay(callback) {
    this.audioPlayer.on('play', () => {
      console.info(`${TAG}audioPlayer play called`)
      callback()
    })
  }

  play() {
    if (typeof (this.audioPlayer) != `undefined`) {
      this.audioPlayer.play()
    } else {
      this.initAudioPlayer(this.playPath, true)
    }
  }

  pause() {
    if (typeof (this.audioPlayer) != `undefined`) {
      this.audioPlayer.pause()
    }
  }

  finish() {
    if (typeof (this.audioPlayer) != `undefined`) {
      this.audioPlayer.stop()
    }
  }
}