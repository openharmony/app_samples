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
import mediaQuery from '@ohos.mediaquery'
import { Record } from '../model/record'
import { HomeView } from '../common/homeView'
import { PlayView } from '../common/playView'
import { FileManager, PATH } from '../model/fileManager'
import { AudioModel } from '../model/audioModel'
import { RenameDialog } from '../common/renameDialog'
import { grantPermission } from '../model/permissionUtils'

let portraitFunc = null
let TAG = '[Record.Index]'

@Entry
@Component
struct Index {
  private fileManager = new FileManager()
  private audioModel: AudioModel = new AudioModel()
  @State recordList: Array<Record> = []
  @State isLand: boolean = false
  @State record: Record = new Record('', '', '', '', false)
  @State renameRecord: Record = new Record('', '', '', '', false)
  private renameDialogController: CustomDialogController = new CustomDialogController({
    builder: RenameDialog({ record: this.renameRecord, renameCallback: this.renameCallBack.bind(this) }),
    autoCancel: true
  })
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5)')

  onPortrait(mediaQueryResult) {
    console.info(`${TAG}onPortrait: mediaQueryResult.matches=${mediaQueryResult.matches}`)
    if (mediaQueryResult.matches) {
      this.isLand = true
    } else {
      this.isLand = false
    }
    console.info(`${TAG}onPortrait: isLand=${this.isLand}`)
    this.recordList = this.fileManager.getFiles()
    console.info(`${TAG}onPortrait: recordList=${JSON.stringify(this.recordList)}`)
  }

  clickItem(recorder, operate) {
    console.info(`${TAG}clickItem: operate=${operate}`)
    if (operate === 'play') {
      if (!this.isLand) {
        router.push({
          params: { recorder: recorder },
          uri: 'pages/play' })
      } else {
        if (this.record.fileName != recorder.fileName) {
          this.audioModel.initAudioPlayer(recorder.filePath, true)
          this.record = recorder
        }
      }
    } else if (operate === 'delete') {
      this.deleteDialogShow(1, function(){
        let index = this.recordList.indexOf(recorder)
        this.recordList.splice(index, 1)
        this.fileManager.deleteFile(recorder, this.recordList)
      }.bind(this))
    } else if (operate === 'rename') {
      this.renameRecord = recorder
      this.renameDialogController.open()
    }
  }

  renameCallBack(record, newName) {
    console.info(`${TAG}renameCallBack: newName=${newName}, oldRecord=${record.fileName}`)
    this.fileManager.renameFile(record, newName)
    this.recordList = this.fileManager.getFiles()
    if (this.record.fileName == record.fileName) {
      console.info(`${TAG}renameCallBack: renameCallBack:this.recorder == record`)
      this.audioModel.initAudioPlayer(PATH + newName + '.wav', false)
      this.record.fileName = newName
    }
  }

  deleteDialogShow(num, deleteAction) {
    let message = $r('app.string.delete_message_one')
    if (num > 1) {
      message = $r('app.string.delete_message_other')
    }
    AlertDialog.show(
      {
        message: message,
        primaryButton: {
          value: $r('app.string.sure'),
          fontColor: Color.Red,
          action: () => {
            deleteAction()
            if (this.fileManager.isDelete(this.record.fileName)) {
              this.record = new Record('', '', '', '', false)
            }
          }
        },
        secondaryButton: {
          value: $r('app.string.cancel'),
          fontColor: Color.Blue,
          action: () => {
          }
        }
      }
    )
  }

  aboutToAppear() {
    grantPermission()
    portraitFunc = this.onPortrait.bind(this)
    this.listener.on('change', portraitFunc)
  }

  build() {
    Row() {
      HomeView({
        recordList: $recordList,
        clickItem: this.clickItem.bind(this),
        deleteDialogShow: this.deleteDialogShow.bind(this) })
      if (this.isLand) {
        Column() {
          Row() {
            Text(this.record.fileName)
              .fontColor(Color.Black)
              .fontWeight(FontWeight.Bold)
              .fontSize(30)
              .layoutWeight(1)
          }
          .size({ width: '100%', height: '8%' })
          .constraintSize({ minHeight: 50 })
          .padding({ left: 20 })

          PlayView({ fileName: this.record.fileName, duration: this.record.duration, audioModel: this.audioModel })
        }
        .layoutWeight(3)
      }
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor('#F0F0F0')
  }
}