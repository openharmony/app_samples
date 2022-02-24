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
import router from '@system.router'
import { TitleBar } from '../common/titleWithBack'
import { AnimateView } from '../common/animateView'
import { FileManager } from '../model/fileManager'
import { RecordModel } from '../model/recordModel'
import { Record } from '../model/record'
import { updateTime } from '../model/updateTime'

const TAG = '[Recorder.Record]'

let audioConfig = {
  audioSourceType: 1,
  audioEncoder: 3,
  audioEncodeBitRate: 22050,
  audioSampleRate: 22050,
  numberOfChannels: 2,
  format: 2,
  uri: ''
}

@Entry
@Component
struct RecordPage {
  private fileName: string = router.getParams().fileName
  private file: string = router.getParams().file
  private addDate: string = router.getParams().addDate
  private recordModel: RecordModel = new RecordModel()
  private fileManager: FileManager = new FileManager()
  private millisecond: number = 0
  @State isRecording: boolean = true
  @State duration: string = '00:00'

  finish() {
    this.isRecording = false
    this.recordModel.finish()
    let recorder = new Record(this.fileName, this.file, this.addDate, this.duration, false)
    this.fileManager.putFile(recorder)
    router.back()
  }

  aboutToAppear() {
    this.recordModel.initAudioRecorder();
    audioConfig.uri = 'file://' + this.file
    this.recordModel.startRecorder(audioConfig, function(){
      this.animator()
      this.millisecond = 0
      console.info(`${TAG}startRecorder callback success`)
    }.bind(this))
  }

  updateTimeStr() {
    this.millisecond += 1000
    this.duration = updateTime(this.millisecond)
  }

  build() {
    Column() {
      TitleBar({ title: this.fileName})
      Column() {
        AnimateView({ isPlay: this.isRecording, isReset: false, updateTimeStr: this.updateTimeStr.bind(this) })
        Image($r('app.media.bg_record'))
          .width('100%')
          .height('40%')
          .objectFit(ImageFit.Fill)

        Text(this.duration)
          .fontColor(Color.Black)
          .fontSize(35)
        Row() {
          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Rect({ width: 20, height: 20 }).fill(Color.Red).radius(5)
          }
          .size({ width: 70, height: 70 })
          .margin({ left: '45%' })
          .backgroundColor('#FFFFFF')
          .onClick(() => {
            this.finish()
          })

          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Image(this.isRecording ? $r('app.media.ic_pause') : $r('app.media.ic_play'))
              .objectFit(ImageFit.Contain)
              .size({ width: 55, height: 55 })
          }
          .size({ width: 60, height: 60 })
          .backgroundColor('#FFFFFF')
          .margin({ left: '17%' })
          .onClick(() => {
            this.isRecording = !this.isRecording
            if (this.isRecording) {
              this.recordModel.resume()
            } else {
              this.recordModel.pause()
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  onPageHide(){
    this.finish()
  }
}