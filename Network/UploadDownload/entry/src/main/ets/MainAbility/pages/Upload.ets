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
import router from '@ohos.router'
import request from '@ohos.request'
import logger from '../model/Logger'
import { TitleBar } from '../common/TitleBar'
import { UploadFile } from '../model/UploadFile'
import { UploadConfigs }  from '../model/UploadConfigs'
import { UploadRequestData } from '../model/UploadRequestData'

const TAG: string = 'Upload'

@Entry
@Component
struct Upload {
  private files: Array<UploadFile> = []
  private uploadConfig: UploadConfigs = new UploadConfigs()
  @State uploadedSize: number = 0
  @State totalSize: number = 0
  @State uploads: Array<string> = router.getParams()['uploads']
  @State isDialog: boolean = false
  @State selectIndex: number = -1
  handlerClickButton = () => {
    router.back()
  }

  build() {
    Column() {
      TitleBar({ handlerClickButton: this.handlerClickButton })
      Scroll() {
        Column() {
          Text($r('app.string.choice_upload_file'))
            .fontSize(25)
            .alignSelf(ItemAlign.Start)
            .margin({ top: 20, left: 10 })
          ForEach(this.uploads, (item, index) => {
            Divider()
              .margin({ top: 20 })
            Row() {
              Text(item)
                .fontSize(25)
                .constraintSize({ maxWidth: '75%' })
                .fontWeight(FontWeight.Bold)
                .margin({ top: 20, left: 10 })
              Blank()

              Button($r('app.string.click_upload'))
                .fontSize(20)
                .backgroundColor('#ff2ea9d2')
                .margin({ top: 10, right: 10 })
                .onClick(() => {
                  if (this.selectIndex === index) {
                    return
                  }
                  this.selectIndex = index
                  logger.info(TAG, `enter upload onclick`)
                  let file = new UploadFile()
                  file.uri = `internal://cache/${item.split('//')[1].split('/')[1]}`
                  logger.info(TAG, `file.uri = ${file.uri}`)
                  file.filename = item.split('//')[1].split('/')[1].split('.')[0]
                  logger.info(TAG, `file.filename = ${file.filename}`)
                  file.name = item.split('//')[1].split('/')[1].split('.')[0]
                  logger.info(TAG, `file.name = ${file.name}`)
                  file.type = item.split('//')[1].split('/')[1].split('.')[1]
                  logger.info(TAG, `file.type = ${file.type}`)
                  let uploadRequestData = new UploadRequestData()
                  let uploadRequestDatas = new Array()
                  uploadRequestData.name = 'name123'
                  uploadRequestData.value = '123'
                  uploadRequestDatas.push(uploadRequestData)
                  this.uploadConfig.data = uploadRequestDatas
                  this.uploadConfig.files = [file]
                  this.uploadConfig.url = 'http://192.168.0.123/upload'
                  this.uploadConfig.method = 'POST'
                  this.uploadConfig.header = 'header_http'
                  logger.info(TAG, `uploadConfigs = ${JSON.stringify(this.uploadConfig)}`)
                  request.upload(this.uploadConfig, (err, uploadTask) => {
                    logger.info(TAG, 'enter upload')
                    if (err) {
                      logger.info(TAG, `err: ${JSON.stringify(err)}`)
                      return
                    }
                    logger.info(TAG, `uploadTask: ${JSON.stringify(uploadTask)}`)
                    uploadTask.on('progress', (uploadedSize, totalSize) => {
                      this.uploadedSize = uploadedSize
                      this.totalSize = totalSize
                      logger.info(TAG, `upload totalSize: ${totalSize} , uploadedSize: ${uploadedSize}`)
                      if (uploadedSize >= totalSize && !this.isDialog) {
                        logger.info(TAG, `item = ${item}`)
                        this.isDialog = true
                        AlertDialog.show({
                          message: item + '上传完成',
                          primaryButton: {
                            value: $r('app.string.confirm'),
                            action: () => {
                              this.isDialog = false
                              uploadTask.off('progress')
                              uploadTask.remove()
                            }
                          }
                        })
                      }
                    })
                    logger.info(TAG, `upload progress end`)
                  })
                })
            }
            .width('100%')
            .margin({ top: 10, left: 10 })

            if (index === this.uploads.length - 1) {
              Divider()
                .margin({ top: 20 })
            }
          })
        }
        .width('100%')
      }
      .constraintSize({ maxHeight: '87%' })

      if (this.uploadedSize !== 0 && this.totalSize !== 0 && this.uploads.length > 0) {
        Row() {
          Text($r('app.string.upload_progress'))
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
          Progress({ value: this.uploadedSize, total: this.totalSize, type: ProgressType.Capsule })
            .color(Color.Grey)
            .width('40%')
            .height(10)
            .margin({ left: 10 })
          Text(`${JSON.stringify(Math.floor(this.uploadedSize / this.totalSize * 100))}%`)
            .margin({ left: 10 })
        }
        .margin({ top: 10 })
        .alignSelf(ItemAlign.Center)
      }
    }
  }
}