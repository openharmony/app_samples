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
import router from '@system.router'
import { TitleBar } from '../common/TitleWithBack'
import { AnimateView } from '../common/AnimateView'
import { FileManager } from '../model/FileManager'
import { RecordModel } from '../model/RecordModel'
import { Record } from '../model/Record'
import { updateTime, prepareFdNumber} from '../model/Utils'

const TAG = '[Recorder.Record]'

@Entry
@Component
struct RecordPage {
  private fileName: string = <string> router.getParams().fileName
  private file: string = <string> router.getParams().file
  private addDate: string = <string> router.getParams().addDate
  private recordModel: RecordModel = new RecordModel()
  private fileManager: FileManager = new FileManager()
  private millisecond: number = 0
  @State isRecording: boolean = false
  @State duration: string = '00:00'

  finish() {
    this.recordModel.finish(function(){
      this.isRecording = false
      let recorder = new Record(this.fileName, this.file, this.addDate, this.duration, false)
      this.fileManager.putFile(recorder)
    }.bind(this))
  }

  aboutToAppear() {
    this.recordModel.initAudioRecorder()
    let fdPath = prepareFdNumber(this.file)
    fdPath.then(fdNumber => {
      this.recordModel.startRecorder(fdNumber, () => {
        console.info(`${TAG}startRecorder callback success`)
        this.millisecond = 0
        this.isRecording = true
      })
    })
  }

  updateTimeStr() {
    this.millisecond += 1000
    this.duration = updateTime(this.millisecond)
  }

  build() {
    Column() {
      TitleBar({ title: this.fileName })
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
          Blank().layoutWeight(5)
          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Rect({ width: 20, height: 20 }).fill(Color.Red).radius(5)
          }
          .size({ width: 70, height: 70 })
          .backgroundColor('#FFFFFF')
          .onClick(() => {
            router.back()
            this.finish()
          })
          Blank().layoutWeight(2)
          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Image(this.isRecording ? $r('app.media.ic_pause') : $r('app.media.ic_play'))
              .objectFit(ImageFit.Contain)
              .size({ width: 55, height: 55 })
          }
          .size({ width: 60, height: 60 })
          .backgroundColor('#FFFFFF')
          .onClick(() => {
            let callback = function(){
              this.isRecording = !this.isRecording
            }.bind(this)
            if (this.isRecording) {
              this.recordModel.pause(callback)
            } else {
              this.recordModel.resume(callback)
            }
          })
          Blank().layoutWeight(2)
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  onPageHide() {
    this.finish()
  }
}