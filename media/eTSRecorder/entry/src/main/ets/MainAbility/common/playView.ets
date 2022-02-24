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
import { AnimateView } from '../common/animateView'
import { AudioModel } from '../model/audioModel'
import { updateTime } from '../model/updateTime'

const TAG = '[Record.PlayView]'

@Component
export struct PlayView {
  private audioModel: AudioModel = null
  private millisecond: number = 0
  @State duration: string = ''
  @State time: string = '00:00'
  @State isReset: boolean = false
  @State isPlay: boolean = false
  @State @Watch('onFileChange') fileName: string = ''

  aboutToAppear() {
    console.info(`${TAG} aboutToAppear`)
    if (this.fileName !== '') {
      this.isPlay = true
      this.isReset = !this.isReset
      this.reset()
      this.audioModel.onFinish(function(){
        this.isPlay = false
        this.isReset = !this.isReset
        this.reset()
      }.bind(this))
    }
  }

  onFileChange() {
    console.info(`${TAG} onFileChange,fileName=${this.fileName},audioModel.isPlay=${this.audioModel.isPlay}`)
    if (this.fileName === '' || !this.audioModel.isPlay) {
      this.isPlay = false
    } else {
      this.isPlay = true
    }
    this.isReset = !this.isReset
    this.reset()
    if (this.fileName !== '') {
      this.audioModel.onFinish(function(){
        this.isPlay = false
        this.reset()
        this.isReset = !this.isReset
      }.bind(this))
    }
  }

  reset() {
    this.time = '00:00'
    this.millisecond = 0
  }

  updateTimeStr() {
    this.millisecond += 1000
    this.time = updateTime(this.millisecond)
  }

  build() {
    Column() {
      AnimateView({ isPlay: this.isPlay, isReset: this.isReset, updateTimeStr: this.updateTimeStr.bind(this) })
      Image($r('app.media.bg_play'))
        .width('100%')
        .height('30%')
        .objectFit(ImageFit.Fill)
      Column() {
        Text(this.time)
          .fontColor(Color.Black)
          .fontSize(35)
        Text(this.duration)
          .fontColor(Color.Gray)
          .fontSize(25)
      }

      Button() {
        Image(this.isPlay ? $r('app.media.pause') : $r('app.media.play'))
          .objectFit(ImageFit.Contain)
          .size({ width: 70, height: 70 })
      }
      .type(ButtonType.Circle)
      .size({ width: 70, height: 70 })
      .backgroundColor('#FFFFFF')
      .layoutWeight(1)
      .margin({ bottom: 15 })
      .onClick(() => {
        if (this.fileName !== '') {
          this.isPlay = !this.isPlay
          if (this.isPlay) {
            this.audioModel.play()
          } else {
            this.audioModel.pause()
          }
        }
      })
    }
  }
}