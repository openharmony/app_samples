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
import http from '@ohos.net.http'
import request from '@ohos.request'
import resourceManager from '@ohos.resourceManager'
import featureAbility from '@ohos.ability.featureAbility'
import logger from '../model/Logger'
import { TitleBar } from '../common/TitleBar'

const TAG: string = 'Index'

@Entry
@Component
struct Index {
  @State receivedSize: number = 0
  @State totalSize: number = 0
  @State message: string = ''
  @State files: Array<string> = []
  @State uploads: Array<string> = []
  private downloadConfig = {
    url: '',
    filePath: ''
  }
  handlerClickButton = () => {
    featureAbility.terminateSelf()
  }

  aboutToAppear() {
    logger.info(TAG, `enter Index aboutToAppear`)
    featureAbility.getContext()
      .requestPermissionsFromUser(['ohos.permission.INTERNET'], 2, (result) => {
        logger.info(TAG, `grantPermission,requestPermissionsFromUser,result.requestCode=${result}`)
      })
    let httpRequest = http.createHttp()
    httpRequest.request(
      'http://192.168.0.123/?tpl=list&folders-filter=&recursive',
      {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'text/plain'
        }
      }, (err, data) => {
      logger.info(TAG, `error = ${JSON.stringify(err)}`)
      if (!err) {
        logger.info(TAG, `data = ${JSON.stringify(data)}`)
        let result: string = data.result.toString()
        logger.info(TAG, `Result = ${result}`)

        let tempFiles = result.split('\r\n')
        for (let i = 0; i < tempFiles.length; i++) {
          let splitFiles = tempFiles[i].split('//')[1].split('/')
          logger.info(TAG, `splitFiles = ${JSON.stringify(splitFiles)}`)
          if (splitFiles.indexOf('upload') === -1) {
            this.files.push(tempFiles[i])
          }
        }
        logger.info(TAG, `files = ${JSON.stringify(this.files)}`)
      } else {
        logger.info(TAG, `error: ${JSON.stringify(err)}`)
        httpRequest.destroy()
      }
    })
  }

  build() {
    Column() {
      TitleBar({ handlerClickButton: this.handlerClickButton })
      Scroll() {
        Column() {
          Text($r('app.string.choice_download_file'))
            .fontSize(25)
            .alignSelf(ItemAlign.Start)
            .margin({ top: 20, left: 10 })
          ForEach(this.files, (item, index) => {
            Divider()
              .margin({ top: 20 })
            Row() {
              Text(item)
                .fontSize(25)
                .constraintSize({ maxWidth: '75%' })
                .fontWeight(FontWeight.Bold)
                .margin({ top: 20, left: 10 })
              Blank()

              Button($r('app.string.click_download'))
                .margin({ top: 20, right: 10 })
                .onClick(async () => {
                  let resourceManage = await resourceManager.getResourceManager()
                  let downloadSuccess = await resourceManage.getString($r('app.string.download_success').id)
                  this.downloadConfig.url = item
                  logger.info(TAG, `downloadConfig.url = ${JSON.stringify(this.downloadConfig.url)}`)
                  this.downloadConfig.filePath = `/data/storage/el2/base/haps/entry/cache/${
                  item.split('//')[1].split('/')[1]}`
                  logger.info(TAG, `downloadConfig.filePath = ${JSON.stringify(this.downloadConfig.filePath)}`)
                  request.download(this.downloadConfig, (err, downloadTask) => {
                    logger.info(TAG, `enter download`)
                    if (err) {
                      logger.info(TAG, `err = ${JSON.stringify(err)}`)
                      return
                    }
                    logger.info(TAG, `data = ${JSON.stringify(downloadTask)}`)

                    downloadTask.on("progress", (receivedSize, totalSize) => {
                      this.receivedSize = receivedSize
                      this.totalSize = totalSize
                      logger.info(TAG, `download receivedSize: ${receivedSize} , totalSize: ${totalSize}`)
                    })

                    downloadTask.on('complete', async () => {
                      await this.files.splice(index, 1)
                      await this.uploads.push(item)
                      AlertDialog.show({
                        message: `${item}${downloadSuccess}`,
                        confirm: {
                          value: $r('app.string.confirm'),
                          action: () => {
                            downloadTask.off('progress')
                          }
                        }
                      })
                    })

                    downloadTask.on('fail', (err) => {
                      downloadTask.query((error, data) => {
                        logger.info(TAG, `query ${JSON.stringify(data)}`)
                        if (error) {
                          logger.info(TAG, `Download task failed. Cause: ${JSON.stringify(err)}`)
                          return
                        }
                        if (data.fileName === item.split('//')[1].split('/')[1]) {
                          AlertDialog.show({
                            message: item.split('//')[1].split('/')[1] + ',该文件已下载，请选择其他文件',
                            confirm: {
                              value: $r('app.string.confirm'),
                              action: () => {
                              }
                            }
                          })
                        }
                      })
                    })
                  })
                })
            }
            .width('100%')

            if (index === this.files.length - 1) {
              Divider()
                .margin({ top: 20 })
            }
          })
          Button($r('app.string.upload_page'))
            .fontSize(30)
            .width(180)
            .height(50)
            .margin({ top: 30 })
            .onClick(() => {
              router.push({
                url: 'pages/Upload',
                params: { uploads: this.uploads }
              })
            })
        }
        .width('100%')
      }
      .constraintSize({ maxHeight: '87%' })

      if (this.receivedSize !== 0 && this.totalSize !== 0 && this.files.length > 0) {
        Row() {
          Text($r('app.string.download_progress'))
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
          Progress({ value: this.receivedSize, total: this.totalSize, type: ProgressType.Capsule })
            .color(Color.Grey)
            .width('40%')
            .height(10)
            .margin({ left: 10 })
          Text(`${JSON.stringify(Math.floor(this.receivedSize / this.totalSize * 100))}%`)
            .margin({ left: 10 })
        }
        .margin({ top: 10 })
        .alignSelf(ItemAlign.Center)
      }
    }
  }
}