/*
 * Copyright (c) 2020 Huawei Device Co., Ltd.
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
import {NoteListItem} from '../common/noteItem'
import {TitleBar} from '../common/titleBar'
import {KvStoreModel} from '../model/kvStoreModel'
import {RemoteDeviceModel} from '../model/remoteDeviceModel'
import {NoteModel, transStrToNoteModel} from '../model/noteDataModel'

const NOTES_CHANGE = 'notesChange';
const EXIT = 'exit'
let kvStoreModel: KvStoreModel = new KvStoreModel()
let noteList: Array<NoteModel> = [{ title: '', content: '' }]
let notesNum: number = 0

@Entry
@Component
struct Index {
  @State notes: Array<NoteModel> = [{ title: '', content: '' }]
  @State dialogShow: boolean = false
  @State isDistributed: boolean = false
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()

  aboutToAppear() {
    featureAbility.getWant((error, want) => {
      console.info('KvStore[IndexPage] featureAbility.getWant =' + JSON.stringify(want.parameters));
      if (want.parameters.isFA === 'FA') {
        this.isDistributed = true
      }
    })
    kvStoreModel.setOnMessageReceivedListener(NOTES_CHANGE, (value) => {
      console.info('kvstore[IndexPage] NOTES_CHANGE' + value)
      if (this.isDistributed) {
        if (value.search(EXIT) != -1) {
          console.info('[json]EXIT' + EXIT)
          featureAbility.terminateSelf((error) => {
            console.info('kvstore[IndexPage] terminateSelf finished, error=' + error)
          });
        } else {
          var str = value.substring(0, value.lastIndexOf('}]') + 2)
          noteList = transStrToNoteModel(str)
          var strNum = value.substring(value.lastIndexOf('numBegin') + 'numBegin'.length, value.lastIndexOf('numEnd'))
          notesNum = parseInt(strNum)
        }
      }
    })
    setInterval(() => {
      if (!this.dialogShow) {
        this.notes = noteList
      }
    }, 500)
  }

  deleteNoteCallBack(item) {
    console.log('KvStore[IndexPage] deleteNote' + item);
    var index = noteList.indexOf(item)
    this.notes = []
    for (let i = 0;i < noteList.length; i++) {
      if (i != index) {
        this.notes.push(noteList[i])
      }
    }
    noteList = this.notes
    kvStoreModel.put(NOTES_CHANGE, JSON.stringify(noteList) + 'numBegin' + notesNum + 'numEnd')
  }

  startAbilityCallBack(key) {
    console.log('KvStore[IndexPage] startAbilityCallBack' + key);
    if (NOTES_CHANGE === key) {
      kvStoreModel.put(NOTES_CHANGE, JSON.stringify(noteList) + 'numBegin' + notesNum + 'numEnd')
    }
    if (EXIT === key) {
      kvStoreModel.put(NOTES_CHANGE, EXIT)
    }
  }

  build() {
    Column() {
      TitleBar({
        startAbilityCallBack: this.startAbilityCallBack,
        remoteDeviceModel: this.remoteDeviceModel,
        isDistributed: $isDistributed,
        dialogShow: $dialogShow
      })

      Grid() {
        ForEach(this.notes, item => {
          GridItem() {
            NoteListItem({
              note: item,
              deleteNoteCallBack: this.deleteNoteCallBack
            })
          }
          .onClick(() => {
            console.info('KvStore[IndexPage] GridItem.click' + item.title);
            if (item.title === '' && item.content === '') {
              notesNum += 1
              noteList[noteList.length-1] = { title: '笔记' + notesNum, content: '笔记内容' }
              noteList.push({ title: '', content: '' })
              this.notes = noteList
              if (this.isDistributed) {
                kvStoreModel.put(NOTES_CHANGE, JSON.stringify(noteList) + 'numBegin' + notesNum + 'numEnd')
              }
            }
          })
        }, item => item.title)
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .padding(10)
      .margin({ bottom: 50 })
    }
  }

  onDestroy() {
    if(this.remoteDeviceModel != null) {
      this.remoteDeviceModel.unregisterDeviceListCallback()
    }
    if (this.isDistributed) {
      this.isDistributed = false
    }
  }
}