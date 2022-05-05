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

import { getFdNumber } from './Util'
import logger from '../common/Logger'
import media from '@ohos.multimedia.media'

const TAG = '[AudioModel]'

export class AudioModel {
    audioPlayer = undefined
    playPath = ''
    isPlay = false

    initAudioPlayer(playSrc, isPlay) {
        logger.info(`${TAG}playSrc=${JSON.stringify(playSrc)}`)
    this.playPath = playSrc
    this.isPlay = isPlay
    this.release();
    this.audioPlayer = media.createAudioPlayer()
    this.audioPlayer.on('dataLoad', () => {
      logger.info(`${TAG}case dataLoad called`)
      if (this.isPlay) {
        this.audioPlayer.play()
      }
    })
    this.audioPlayer.on('pause', () => {
      logger.info(`${TAG}case pause called`)
    })
    this.audioPlayer.on('play', () => {
      logger.info(`${TAG}case play called`)
    })
    this.audioPlayer.on('stop', () => {
      logger.info(`${TAG}audioPlayer stop called`)
      this.audioPlayer.release()
      this.audioPlayer = undefined
    })
    this.audioPlayer.on('error', () => {
      logger.info(`${TAG}audioPlayer error called`)
    })
    this.audioPlayer.reset()
    let fdPath = getFdNumber(playSrc)
    fdPath.then(fdNumber => {
      this.audioPlayer.src = fdNumber
      logger.info(`${TAG}create audioPlayer success`)
    })
  }

  release() {
    if (typeof (this.audioPlayer) !== `undefined`) {
      logger.info(`${TAG}audioPlayer  release`)
      this.audioPlayer.release()
      this.audioPlayer = undefined
    }
  }

  onFinish(callback) {
    logger.info(`${TAG}set onFinish`)
    this.audioPlayer.on('finish', () => {
      logger.info(`${TAG}audioPlayer finish called`)
      this.audioPlayer.seek(0)
      callback()
    });
  }

  onPlay(callback) {
    this.audioPlayer.on('play', () => {
      logger.info(`${TAG}audioPlayer play called`)
      callback()
    })
  }

  play() {
    if (typeof (this.audioPlayer) !== `undefined`) {
      this.audioPlayer.play()
    } else {
      this.initAudioPlayer(this.playPath, true)
    }
  }

  pause() {
    if (typeof (this.audioPlayer) !== `undefined`) {
      this.audioPlayer.pause()
    }
  }

  finish() {
    if (typeof (this.audioPlayer) !== `undefined`) {
      this.audioPlayer.stop()
    }
  }
}