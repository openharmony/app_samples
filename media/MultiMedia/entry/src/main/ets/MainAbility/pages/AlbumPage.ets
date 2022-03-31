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
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import router from '@system.router'
import Logger from '../model/Logger'
import MediaUtils from '../model/MediaUtils'
import { MediaItem } from '../view/MediaItem'
import { RenameDialog } from '../view/RenameDialog'
import TitleBar from '../view/TitleBar'

@Entry
@Component
struct AlbumPage {
  private tag: string = 'AlbumPage'
  private albumName: string = <string> router.getParams().albumName
  private mediaType: number = <number> router.getParams().mediaType
  private mediaUtils: MediaUtils = MediaUtils.getInstance()
  private renameDialogController: CustomDialogController = null
  @State mediaList: Array<mediaLibrary.FileAsset> = []
  @State selectMedia: mediaLibrary.FileAsset = undefined

  btnAction(operate, index) {
    Logger.log(this.tag, `btnAction callback,operate: ${operate}, index: ${index}`)
    this.selectMedia = this.mediaList[index]
    if (operate === 'delete') {
      this.deleteMedia(() => {
        let deleteResult = this.mediaUtils.deleteFile(this.selectMedia)
        deleteResult.then(() => {
          Logger.log(this.tag, 'deleteFile callback')
          this.mediaList.splice(index, 1)
        }).catch(err => {
          Logger.error(this.tag, `deleteFile err,err: ${err}`)
        })
      })
    } else {
      if (this.renameDialogController === null) {
        this.renameDialogController = new CustomDialogController({
          builder: RenameDialog({ title: this.selectMedia.title, action: this.renameMedia.bind(this) }),
          autoCancel: true
        })
      }
      this.renameDialogController.open()
    }
  }

  renameMedia(title) {
    Logger.log(this.tag, `renameMedia newName = ${this.selectMedia.displayName}`)
    this.selectMedia.title = title
    this.selectMedia.commitModify(err => {
      if (err !== undefined) {
        Logger.log(this.tag, `commitModify,err: ${err}`)
        return
      }
      Logger.log(this.tag, 'commitModify success')
      this.renameDialogController.close()
      this.refreshData()
    })
  }

  deleteMedia(deleteAction) {
    AlertDialog.show(
      {
        message: $r('app.string.delete_file'),
        primaryButton: {
          value: $r('app.string.yes'),
          fontColor: Color.Red,
          action: () => {
            deleteAction()
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

  refreshData() {
    this.mediaList = []
    let fileAsset = this.mediaUtils.getFileAssetsFromType(this.mediaType)
    fileAsset.then(fileList => {
      Logger.log(this.tag, 'getFileList callback')
      this.mediaList = fileList
    }).catch(err => {
      Logger.error(this.tag, `getFileList err,err = ${err}`)
    })
  }

  aboutToAppear() {
    Logger.log(this.tag, `mediaType=${this.mediaType}`)
    this.refreshData()
  }

  build() {
    Column() {
      TitleBar({ title: this.albumName })
      List() {
        ForEach(this.mediaList, (item, index) => {
          ListItem() {
            MediaItem({ media: item, index: index, btnAction: this.btnAction.bind(this) })
          }
        }, item => item.title)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}