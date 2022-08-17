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
import fileIo from '@ohos.fileio'
import Logger from '../model/Logger'

const TAG: string = 'PlayerModel'

class PlayList {
  public audioFiles: Array<Song> = []

  constructor() {
  }
}

class Song {
  public name: string
  public fileUri: string
  public duration: number

  constructor(name, fileUri, duration) {
    this.name = name
    this.fileUri = fileUri
    this.duration = duration
  }
}

class PlayerModel {
  public isPlaying: boolean = false
  public playlist: PlayList = new PlayList()
  public index: number
  public player: media.AudioPlayer
  public statusChangedListener
  public playingProgressListener
  public intervalID = undefined
  public currentTimeMs: number = 0

  constructor() {
    Logger.info(TAG, `createAudioPlayer start`)
    this.player = media.createAudioPlayer()
    Logger.info(TAG, `createAudioPlayer end and initAudioPlayer`)
    this.initAudioPlayer()
    Logger.info(TAG, `createAudioPlayer= ${this.player}`)
  }

  initAudioPlayer() {
    Logger.info(TAG, 'initAudioPlayer begin')
    this.player.on('error', () => {
      Logger.error(TAG, `player error`)
    })
    this.player.on('finish', () => {
      Logger.info(TAG, 'finish() callback is called')
      this.seek(0)
      this.notifyPlayingStatus(false)
    })
    this.player.on('timeUpdate', () => {

      Logger.info(TAG, `timeUpdate() callback is called`)
    })
    Logger.info(TAG, 'initAudioPlayer end')
  }

  release() {
    if (typeof (this.player) !== 'undefined') {
      Logger.info(TAG, 'player.release begin')
      this.player.release()
      Logger.info(TAG, 'player.release end')
      this.player = undefined
    }
  }

  restorePlayingStatus(status, callback) {
    Logger.info(TAG, `restorePlayingStatus ${JSON.stringify(status)}`)
    for (let i = 0; i < this.playlist.audioFiles.length; i++) {
      if (this.playlist.audioFiles[i].fileUri === status.uri) {
        Logger.info(TAG, `restore to index ${i}`)
        this.preLoad(i, () => {
          this.play(status.seekTo, status.isPlaying)
          Logger.info(TAG, 'restore play status')
          callback(i)
        })
        return
      }
    }
    Logger.info(TAG, 'restorePlayingStatus failed')
    callback(-1)
  }

  getPlaylist(callback) {
    // generate play list
    Logger.info(TAG, 'generatePlayList')
    Logger.info(TAG, 'getAudioAssets begin')
    this.playlist = new PlayList()
    this.playlist.audioFiles = []
    this.playlist.audioFiles[0] = new Song('dynamic.wav', 'system/etc/dynamic.wav', 0)
    this.playlist.audioFiles[1] = new Song('demo.wav', 'system/etc/demo.wav', 0)
    callback()
    Logger.info(TAG, 'getAudioAssets end')
  }

  setOnStatusChangedListener(callback) {
    this.statusChangedListener = callback
  }

  setOnPlayingProgressListener(callback) {
    this.playingProgressListener = callback
  }

  notifyPlayingStatus(isPlaying) {
    this.isPlaying = isPlaying
    this.statusChangedListener(this.isPlaying)
    Logger.info(TAG, `notifyPlayingStatus isPlaying= ${isPlaying} intervalId= ${this.intervalID}`)
    if (isPlaying) {
      if (typeof (this.intervalID) === 'undefined') {
        this.intervalID = setInterval(() => {
          if (typeof (this.playingProgressListener) !== 'undefined' && this.playingProgressListener !== null) {
            let timeMs = this.player.currentTime
            this.currentTimeMs = timeMs
            if (typeof (timeMs) === 'undefined') {
              timeMs = 0
            }
            Logger.info(TAG, `player.currentTime= ${timeMs}`)
            this.playingProgressListener(timeMs)
          }
        }, 500)
        Logger.info(TAG, `set update interval ${this.intervalID}`)
      }
    } else {
      this.cancelTimer()
    }
  }

  cancelTimer() {
    if (typeof (this.intervalID) !== 'undefined') {
      Logger.info(TAG, `clear update interval ${this.intervalID}`)
      clearInterval(this.intervalID)
      this.intervalID = undefined
    }
  }

  preLoad(index, callback) {
    Logger.info(TAG, `preLoad ${index}/${this.playlist.audioFiles.length}`)
    if (index < 0 || index >= this.playlist.audioFiles.length) {
      Logger.error(TAG, 'preLoad ignored')
      return 0
    }
    this.index = index
    let uri = this.playlist.audioFiles[index].fileUri
    fileIo.open(uri, (err, fdNumber) => {
      let fdPath = 'fd://'
      let source = fdPath + fdNumber
      Logger.info(TAG, `preLoad source ${source}`)
      if (typeof (source) === 'undefined') {
        Logger.error(TAG, `preLoad ignored source= ${source}`)
        return
      }
      Logger.info(TAG, `preLoad ${source} begin`)
      Logger.info(TAG, `state= ${this.player.state}`)

      if (source === this.player.src && this.player.state !== 'idle') {
        Logger.info(TAG, 'preLoad finished. src not changed')
        callback()
      } else {
        this.notifyPlayingStatus(false)
        this.cancelTimer()
        Logger.info(TAG, 'player.reset')
        this.player.reset()
        Logger.info(TAG, `player.reset done, state= ${this.player.state}`)
        this.player.on('dataLoad', () => {
          Logger.info(TAG, `dataLoad callback, state= ${this.player.state}`)
          callback()
        })
        Logger.info(TAG, `player.src= ${source}`)
        this.player.src = source
      }
      Logger.info(TAG, `preLoad ${source} end`)
    })
  }

  getDuration() {
    Logger.info(TAG, `getDuration index= ${this.index}`)
    if (this.playlist.audioFiles[this.index].duration > 0) {
      return this.playlist.audioFiles[this.index].duration
    }
    Logger.info(TAG, `getDuration state= ${this.player.state}`)
    this.playlist.audioFiles[this.index].duration = Math.min(this.player.duration, 97615)
    Logger.info(TAG, `getDuration player.src= ${this.player.src} player.duration= ${this.playlist.audioFiles[this.index].duration} `)
    return this.playlist.audioFiles[this.index].duration
  }

  getCurrentMs() {
    return this.currentTimeMs
  }

  play(seekTo, startPlay) {
    Logger.info(TAG, `play seekTo= ${seekTo} startPlay= ${startPlay}`)
    this.notifyPlayingStatus(startPlay)
    if (startPlay) {
      if (seekTo < 0 && this.currentTimeMs > 0) {
        Logger.info(TAG, `pop seekTo= ${this.currentTimeMs}`)
        seekTo = this.currentTimeMs
      }
      let self = this
      this.player.on('play', () => {
        Logger.info(TAG, `play() callback entered, player.state= ${self.player.state}`)
        if (seekTo > 0) {
          self.seek(seekTo)
        }
      })
      Logger.info(TAG, 'call player.play')
      this.player.play()
      Logger.info(TAG, `player.play called player.state= ${this.player.state}`)
    } else if (seekTo > 0) {
      this.playingProgressListener(seekTo)
      this.currentTimeMs = seekTo
      Logger.info(TAG, `stash seekTo= ${this.currentTimeMs}`)
    }
  }

  pause() {
    if (!this.isPlaying) {
      Logger.info(TAG, `pause ignored, isPlaying= ${this.isPlaying}`)
      return
    }
    this.notifyPlayingStatus(false)
    Logger.info(TAG, 'call player.pause')
    this.player.pause()
    Logger.info(TAG, `player.pause called, player.state= ${this.player.state}`)
  }

  seek(ms) {
    this.currentTimeMs = ms
    if (this.isPlaying) {
      Logger.info(TAG, `player.seek= ${ms}`)
      this.player.seek(ms)
    } else {
      Logger.info(TAG, `stash seekTo= ${ms}`)
    }
  }

  stop() {
    if (!this.isPlaying) {
      Logger.info(TAG, `stop ignored, isPlaying= ${this.isPlaying}`)
      return
    }
    this.notifyPlayingStatus(false)
    Logger.info(TAG, 'call player.stop')
    this.player.stop()
    Logger.info(TAG, `player.stop called, player.state= ${this.player.state}`)
  }
}

export default new PlayerModel()