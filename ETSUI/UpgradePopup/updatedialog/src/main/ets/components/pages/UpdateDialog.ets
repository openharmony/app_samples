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

import Logger  from '../util/Logger'
import { updateData } from '../mock/dialogdata'
import { dialogFeature } from '../feature/DialogFeature'
import { AbilityContext } from '../model/dialogdatamodel'
import {RequestResponseContent} from '../net/RequestResponse'

const TAG: string = 'UpdateDialog'

// 按钮共同样式
@Styles function commonButtonStyle () {
  .width('45%')
  .height(50)
  .alignSelf(ItemAlign.Center)
  .borderRadius(20)
}

@CustomDialog
export struct UpdateDialog {
  @State currentVersion: string = ''
  @State richTextData: string = ''
  @State lastVersion: string = ''
  @State updateContent: string = ''
  private isLand: boolean
  private context?: AbilityContext
  private customDialogController?: CustomDialogController

  aboutToAppear() {
    this.getData()
  }

  async getData() {
    this.context = getContext(this) as AbilityContext
    this.richTextData = await dialogFeature.getRichTextData(this.context)
    Logger.info(TAG, `this.richTextData = ${this.richTextData}`)
    try {
      this.currentVersion = await dialogFeature.getCurrentVersion()
      let requestResponseContent: RequestResponseContent = await dialogFeature.getLastVersion()
      if (requestResponseContent.content === null || requestResponseContent.content === undefined) {
        return
      }
      this.updateContent = requestResponseContent.content
      if (requestResponseContent.versionName === null || requestResponseContent.versionName === undefined) {
        return
      }
      this.lastVersion = requestResponseContent.versionName
    } catch (err) {
      Logger.info(TAG, `getApplicationVersion is fail`)
    }
  }

  build() {
    Stack() {
      // mask 遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#000000')
        .opacity(.4)
      Column() {
        Stack({ alignContent: Alignment.TopStart }) {
          Text($r('app.string.update_title'))
            .fontSize(30)
            .fontColor('#FFFFFF')
            .fontWeight(500)
            .margin({ top: 70, left: 76 })

          Text(`V${(this.lastVersion || updateData.versionName)}`)
            .fontSize(16)
            .backgroundColor('#FFFFFF')
            .textAlign(TextAlign.Center)
            .fontColor('#E9304E')
            .borderRadius(20)
            .width(80)
            .aspectRatio(2.8)
            .margin({ top: 110, left: 76 })

          Column() {
            // 富文本容器
            Scroll() {
              Column() {
                if (this.richTextData) {
                  RichText((this.updateContent || this.richTextData))
                    .width('100%')
                    .height('100%')
                }
              }
              .width('100%')
            }
            .height(200)

            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Button($r('app.string.cancel'))
                .commonButtonStyle()
                .fontSize(20)
                .margin({left:10})
                .fontColor('#E92F4F')
                .backgroundColor('rgba(0,0,0,0.05)')
                .onClick(() => {
                  this.customDialogController.close()
                })

              Button($r('app.string.update_now'))
                .commonButtonStyle()
                .fontSize(20)
                .margin({right:10})
                .fontColor('#FFFFFF')
                .backgroundColor('#E92F4F')
                .onClick(() => {
                  this.customDialogController.close()
                })
            }
            .margin({ top: 30 })
          }
          .width('100%')
          .padding({ left: 25, right: 25 })
          .margin({ top: 230 })
        }
        .height(600)
        .width('100%')
        .backgroundImage($r('app.media.update'), ImageRepeat.NoRepeat)
        .backgroundImageSize(ImageSize.Contain)
      }
      .width((this.isLand ? '40%' : '100%'))
      .padding({ top: (this.isLand ? 20 : 120), left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
  }
}


