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
import featureAbility from '@ohos.ability.featureAbility'
import router from '@ohos.router'
import mediaQuery from '@ohos.mediaquery'
import Logger from '../model/Logger'
import MediaManager from '../model/MediaManager'
import { HomeView } from '../common/HomeView'
import { PlayView } from '../common/PlayView'
import { AudioModel } from '../model/AudioModel'
import { Record } from '../model/Record'
import { RenameDialog } from '../common/RenameDialog'

let TAG = '[Recorder.Index]'

@Entry
@Component
struct Index {
  private audioModel: AudioModel = new AudioModel()
  @State recordList: Array<Record> = []
  @State isLand: boolean = false
  @State record: Record = new Record(undefined, false)
  @State renameRecord: Record = undefined
  private renameDialogController: CustomDialogController = new CustomDialogController({
    builder: RenameDialog({ record: this.renameRecord, renameCallback: this.renameCallBack.bind(this) }),
    autoCancel: true
  })
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')

  onPortrait(mediaQueryResult) {
    this.isLand = mediaQueryResult.matches
    Logger.info(TAG, `onPortrait: isLand=${this.isLand}`)
  }

  clickItem(recorder, operate) {
    Logger.info(TAG, `clickItem: operate=${operate}`)
    if (operate === 'play') {
      if (!this.isLand) {
        router.push({
          params: { fileId: recorder.fileAsset.id },
          url: 'pages/Play' })
      } else {
        if (this.record.title != recorder.title) {
          this.record = recorder
          this.audioModel.initAudioPlayer(this.record.fileAsset, true)
        }
      }
    } else if (operate === 'delete') {
      this.deleteDialogShow(1, [recorder], function(){
        let index = this.recordList.indexOf(recorder)
        this.recordList.splice(index, 1)
        MediaManager.deleteFile(recorder.fileAsset.uri)
      }.bind(this))
    } else if (operate === 'rename') {
      this.renameRecord = recorder
      this.renameDialogController.open()
    }
  }

  renameCallBack(newName) {
    Logger.info(TAG, `renameCallBack: newName=${newName}`)
    this.renameRecord.fileAsset.title = newName
    this.renameRecord.fileAsset.commitModify(err => {
      if (err !== undefined) {
        Logger.info(TAG, `commitModify: err:${err}`)
        return
      }
      Logger.info(TAG, `commitModify success`)
      this.renameDialogController.close()
      this.getAudios()
      if (this.record.title == this.renameRecord.title) {
        Logger.info(TAG, `renameCallBack: renameCallBack:this.recorder == record`)
        this.audioModel.initAudioPlayer(this.renameRecord.fileAsset, false)
        this.record.title = newName
      }
    })
  }

  deleteDialogShow(num, checkRecords, deleteAction) {
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
            for (let record in checkRecords) {
              MediaManager.deleteFile(checkRecords[record].fileAsset.uri)
              if (this.record && this.record.title === checkRecords[record].title) {
                this.audioModel.finish()
                this.record = new Record(undefined, false)
              }
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

  getAudios = async () => {
    this.recordList = await MediaManager.queryAllAudios()
  }

  aboutToAppear() {
    let context = featureAbility.getContext()
    context.requestPermissionsFromUser(['ohos.permission.MICROPHONE', 'ohos.permission.WRITE_MEDIA', 'ohos.permission.READ_MEDIA'], 3, function (result) {
      Logger.info(TAG, `grantPermission,requestPermissionsFromUser,result.requestCode=${result}`)
    })
    this.listener.on('change', this.onPortrait.bind(this))
    MediaManager.onAudioChange(this.getAudios)
  }

  onPageShow() {
    this.getAudios()
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
            Text(this.record.title)
              .fontColor(Color.Black)
              .fontWeight(FontWeight.Bold)
              .fontSize(30)
              .layoutWeight(1)
          }
          .size({ width: '100%', height: '8%' })
          .constraintSize({ minHeight: 50 })
          .padding({ left: 20 })

          PlayView({
            fileName: this.record.title,
            duration: this.record.duration,
            audioModel: this.audioModel
          })
        }
        .layoutWeight(3)
      }
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor('#F0F0F0')
  }
}