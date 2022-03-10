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
import { TitleBar } from '../common/titleBar'
import { CheckTitle } from '../common/checkTitle'
import { Record } from '../model/record'
import { AudioItem } from '../common/audioItem'
import { FileManager } from '../model/fileManager'

@Component
export struct HomeView {
  private fileManager = new FileManager()
  private clickItem: (record: Record, operate: string) => void
  private deleteDialogShow: (num: number, deleteAction: () => void) => void
  @State leftSliderIndex: number = -1
  @State checkNum: number = 0
  @Link recordList: Array<Record>
  @State @Watch('checkStateChange') checkState: boolean = false

  checkItem() {
    this.checkNum = 0
    for (let i = 0;i < this.recordList.length; i++) {
      if (this.recordList[i].isCheck == true) {
        this.checkNum++
      }
    }
  }

  checkStateChange() {
    if (!this.checkState) {
      for (let i = 0;i < this.recordList.length; i++) {
        this.recordList[i].isCheck = false
      }
    }
    this.checkNum = 0
  }

  batchDelete() {
    let checkRecords = []
    let newRecords = []
    for (let i = 0;i < this.recordList.length; i++) {
      if (this.recordList[i].isCheck == true) {
        checkRecords.push(this.recordList[i])
      } else {
        newRecords.push(this.recordList[i])
      }
    }
    this.deleteDialogShow(checkRecords.length, function(){
      this.fileManager.deleteFiles(checkRecords, newRecords)
      this.recordList = newRecords
      this.checkState = false
    }.bind(this))
  }

  build() {
    Column() {
      if (this.checkState) {
        CheckTitle({ checkState: $checkState, num: this.checkNum })
      } else {
        TitleBar()
      }
      List() {
        ForEach(this.recordList, (item, index) => {
          ListItem() {
            AudioItem({
              checkState: $checkState,
              record: item,
              index: index,
              leftSliderIndex: $leftSliderIndex,
              clickItem: this.clickItem,
              checkItem: this.checkItem.bind(this)
            })
          }
        }, item => JSON.stringify(item))
      }
      .layoutWeight(1)

      if (this.checkState) {
        Row() {
          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Column() {
              Image($r('app.media.ic_rename'))
                .objectFit(ImageFit.Contain)
                .size({ width: 30, height: 30 })
              Text($r('app.string.rename'))
                .fontSize(15)
                .margin({ top: 5 })
                .width(70)
                .textAlign(TextAlign.Center)
            }
          }
          .size({ width: 70, height: 70 })
          .layoutWeight(1)
          .backgroundColor('#F5F5F5')
          .enabled(this.checkNum == 1)
          .opacity(this.checkNum == 1 ? 1.0 : 0.5)
          .onClick(() => {
            let checkRecord = null
            for (let i = 0;i < this.recordList.length; i++) {
              if (this.recordList[i].isCheck == true) {
                checkRecord = this.recordList[i]
              }
            }
            this.clickItem(checkRecord, 'rename')
            this.checkState = false
          })

          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Column() {
              Image($r('app.media.delete'))
                .objectFit(ImageFit.Contain)
                .size({ width: 25, height: 25 })
              Text($r('app.string.delete'))
                .fontSize(15)
                .margin({ top: 5 })
                .width(70)
                .textAlign(TextAlign.Center)
            }
          }
          .size({ width: 70, height: 70 })
          .layoutWeight(1)
          .backgroundColor('#F5F5F5')
          .enabled(this.checkNum > 0)
          .opacity(this.checkNum > 0 ? 1.0 : 0.5)
          .onClick(() => {
            this.batchDelete()
          })
        }
        .width('100%')
        .margin(10)
      } else {
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Image($r('app.media.rectangle'))
            .objectFit(ImageFit.Contain)
            .size({ width: 30, height: 30 })
        }
        .size({ width: 70, height: 70 })
        .backgroundColor('#FFFFFF')
        .margin(10)
        .onClick(() => {
          this.fileManager.createFile((fileName, file, addDate) => {
            router.push({
              params: { fileName: fileName, file: file, addDate: addDate },
              uri: 'pages/recordPage' })
          })
        })
      }
    }
    .layoutWeight(2)
    .height('100%')
    .backgroundColor('#F5F5F5')
    .zIndex(2)
  }
}