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
 */

import HiLogUtil from '../model/HiLogUtil'
import { ShowView } from '../common/ShowView'

const TAG = '[Show]'

@Component
export struct Show {
  private slotId: number = 0
  private simColor: string = ''
  private simCard: Resource = undefined
  private simText: Resource = undefined
  private simTitle: Resource = undefined
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ShowView({ slotId: this.slotId }), autoCancel: true, alignment: DialogAlignment.Center })

  aboutToAppear() {
    HiLogUtil.log(TAG, `simText is ${JSON.stringify(this.simText)}, simColor is ${this.simColor}`)
  }

  build() {
    Column() {
      Row() {
        Stack() {
          Image($r('app.media.sim'))
            .objectFit(ImageFit.Contain)
            .width('80%')
            .height('80%')
          Text(this.simTitle)
            .fontSize(14)
            .width('60%')
            .height('60%')
            .textAlign(TextAlign.Center)
        }
        .width('20%')
        .height('10%')

        Flex({ direction: FlexDirection.Column, alignContent: FlexAlign.Start }) {
          Text(this.simCard)
            .fontSize(18)
          Text(this.simText)
            .fontSize(17)
          Text($r('app.string.network'))
            .fontSize(16)
            .fontColor(Color.Gray)
        }
        .margin(10)
        .padding(5)
        .layoutWeight(1)

        Image($r('app.media.right'))
          .width(20)
          .height(20)
          .layoutWeight(1)
          .margin({ left: '5%' })
          .objectFit(ImageFit.Contain)

      }
      .margin(8)
      .width('95%')
      .borderRadius(10)
      .backgroundColor(this.simColor)
      .padding({ top: 6, left: 5, right: 5, bottom: 6 })
      .onClick(() => {
        this.dialogController.open()
        HiLogUtil.log(TAG, `CustomDialog start`)
      })
    }
  }
}