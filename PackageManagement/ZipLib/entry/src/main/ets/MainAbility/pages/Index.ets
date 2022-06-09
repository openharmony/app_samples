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

import zlib from '@ohos.zlib'
import fileio from '@ohos.fileio'
import prompt from '@ohos.prompt'
import Logger from '../model/Logger'
import storage from '@ohos.data.storage'
import { AddDialog } from '../common/AddDialog'
import featureAbility from '@ohos.ability.featureAbility'

const TAG: string = '[Index]'
let fileList: storage.Storage = null

@Entry
@Component
struct Index {
  @State isInserted: boolean = false
  @State files: Array<string> = []
  @State fileName: string = ''
  @State fileContent: string = ''
  private path: string = ''
  private title: Resource = $r('app.string.MainAbility_label')
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: AddDialog({
      fileName: this.fileName,
      fileContent: this.fileContent,
      isInserted: this.isInserted,
      createFile: (isInserted: boolean, fileName: string, fileContent: string) => {
        Logger.info(TAG, `enter the createFile`)
        this.fileName = `${fileName}.txt`
        let isDuplication = this.files.includes(this.fileName)
        Logger.info(TAG, `isInserted = ${isInserted}  isDuplication = ${isDuplication}`)
        if (!isInserted || isDuplication) {
          return
        }
        let fd = fileio.openSync(`${this.path}/${this.fileName}`, 0o100 | 0o2, 0o666)
        let number = fileio.writeSync(fd, fileContent)
        Logger.info(TAG, `fd = ${fd} number = ${number}`)
        this.files.push(this.fileName)
        Logger.info(TAG, `this.files = ${JSON.stringify(this.files)}`)
        fileList.putSync('fileName', JSON.stringify(this.files))
        fileList.flushSync()
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default
  })

  aboutToAppear() {
    let context = featureAbility.getContext()
    context.getFilesDir().then((path) => {
      this.path = path
      Logger.info(TAG, `path = ${this.path}`)
      fileList = storage.getStorageSync(`${this.path}/fileList`)
      let value = fileList.getSync('fileName', '')
      this.files = JSON.parse(`${value}`)
    })
  }

  zipHandler(path: string, fileName: string) {
    let zipFile = `${path}/${fileName}`
    Logger.info(TAG, `zipFile = ${zipFile}`)
    let tempName = fileName.split('.')
    let newName = `${tempName[0]}.zip`
    let zipOutFile = `${this.path}/${newName}`
    Logger.info(TAG, `zipOutFile = ${zipOutFile}`)

    let options = {
      level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION,
      memLevel: zlib.MemLevel.MEM_LEVEL_DEFAULT,
      strategy: zlib.CompressStrategy.COMPRESS_STRATEGY_DEFAULT_STRATEGY
    }
    if (this.files.includes(newName)) {
      prompt.showToast({
        message: `已存在压缩文件，压缩失败`
      })
      return
    }
    try {
      zlib.zipFile(zipFile, zipOutFile, options).then(data => {
        Logger.info(TAG, `data = ${JSON.stringify(data)}`)
        prompt.showToast({
          message: `文件压缩完成`
        })
        this.files.push(`${newName}`)
      })
    } catch {
      prompt.showToast({
        message: `文件压缩失败`
      })
    }
    fileList.putSync('fileName', JSON.stringify(this.files))
    fileList.flushSync()
  }

  unzipHandler(path: string, fileName: string) {
    let zipFile = `${path}/${fileName}`
    Logger.info(TAG, `zipFile = ${zipFile}`)
    let tempName = this.fileName.split('.')
    let newName = tempName[0]
    let zipOutFile = `${this.path}/${newName}`
    Logger.info(TAG, `zipOutFile = ${zipOutFile}`)
    if (this.files.includes(newName)) {
      prompt.showToast({
        message: '已存在同名压缩文件，解压失败'
      })
      return
    }
    let options = {
      level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION,
      memLevel: zlib.MemLevel.MEM_LEVEL_DEFAULT,
      strategy: zlib.CompressStrategy.COMPRESS_STRATEGY_DEFAULT_STRATEGY
    }

    zlib.unzipFile(zipFile, zipOutFile, options).then(data => {
      Logger.info(TAG, `data = ${JSON.stringify(data)}`)
    })
    prompt.showToast({
      message: `文件解压完成`
    })
    this.files.push(`${newName}`)
    fileList.putSync('fileName', JSON.stringify(this.files))
    fileList.flushSync()
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      Column() {
        Row() {
          Text(this.title)
            .width('90%')
            .fontColor(Color.White)
            .fontSize(28)

          Button() {
            Image($r("app.media.add"))
              .height(45).width('100%')
              .objectFit(ImageFit.Contain)
              .align(Alignment.End)
          }
          .width('10%')
          .type(ButtonType.Normal)
          .backgroundColor('#0D9FFB')
          .align(Alignment.End)
          .onClick(() => {
            this.dialogController.open()
          })
        }
        .width('100%')
        .height('8%')
        .constraintSize({ minHeight: 70 })
        .padding({ left: 10, right: 10 })
        .backgroundColor('#0D9FFB')

        List({ space: 20, initialIndex: 0 }) {
          ForEach(this.files, (item) => {
            ListItem() {
              Row() {
                Image(item.includes('.zip') ? $r('app.media.zip') : $r('app.media.file'))
                  .width('10%')
                  .margin({ left: 15, top: 5, bottom: 5 })
                  .objectFit(ImageFit.Contain)
                Column() {
                  Text(item)
                    .width('50%')
                    .fontSize(18)
                    .margin({ left: 15 })
                }

                Row() {
                  Button(item.includes('.zip') ? $r('app.string.unzip') : $r('app.string.zip'))
                    .fontSize(18)
                    .onClick(() => {
                      item.includes('.zip') ? this.unzipHandler(this.path, item) : this.zipHandler(this.path, item)
                    })
                }
                .width('25%')
                .margin({ left: '15' })
              }
            }
            .width('95%')
            .borderRadius(10)
            .margin({ top: '1%', left: '2.5%' })
            .align(Alignment.Center)
            .backgroundColor('#FFFFFF')
          }, item => item)
        }
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#eeeeee')
    }
  }
}
