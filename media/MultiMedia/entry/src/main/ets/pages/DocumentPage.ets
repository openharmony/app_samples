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
import fileIo from '@ohos.fileio'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import router from '@ohos.router'
import Logger from '../model/Logger'
import MediaUtils from '../model/MediaUtils'
import TitleBar from '../view/TitleBar'

@Entry
@Component
struct DocumentPage {
  private tag: string = 'DocumentPage'
  private mediaUtils: MediaUtils = MediaUtils.getInstance()
  @State fileContent: string = ''

  async saveFile() {
    Logger.info(this.tag, 'saveFile')
    let fd = await this.mediaUtils.createFile(mediaLibrary.MediaType.FILE)
    Logger.info(this.tag, `fd = ${fd}`)
    await fileIo.write(fd, this.fileContent)
    await fileIo.close(fd)
    router.back()
  }

  build() {
    Column() {
      TitleBar()
      TextArea({ placeholder: 'input file content', text: this.fileContent })
        .placeholderColor(Color.Gray)
        .fontSize(22)
        .margin({ left: 15, right: 15, top: 15 })
        .textAlign(TextAlign.Start)
        .height('30%')
        .onChange((value: string) => {
          this.fileContent = value
        })
      Button() {
        Text($r('app.string.save'))
          .fontColor(Color.Black)
          .fontSize(17)
      }
      .backgroundColor('#0D9FFB')
      .height(50)
      .width(200)
      .margin({ top: 10 })
      .onClick(() => {
        Logger.info(this.tag, 'saveFile onClick')
        this.saveFile()
      })
    }
    .height('100%')
    .width('100%')
  }
}