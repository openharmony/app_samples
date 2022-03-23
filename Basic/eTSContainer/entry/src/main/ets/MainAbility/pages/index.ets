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

import { AddDialog } from '../common/AddDialog.ets'
import Information from '../model/Information.ets'
import Hilog from '../model/hilog.ets'
import ArrayList from '@ohos.util.ArrayList'

const TAG = 'index'

@Entry
@Component
struct Index {
  @State writeInformation: Information = new Information(0, '', NaN, '')
  @State isInserted: boolean = false
  @State list: Array<Information> = []
  private informations: ArrayList<Information> = new ArrayList()
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: AddDialog({
      isInserted: this.isInserted,
      saveData: (isInserted: boolean, writeInformation: Information) => {
        if (!isInserted) {
          return;
        }
        if (this.informations.isEmpty()) {
          writeInformation.id = 0
          Hilog.log(TAG, `writeInformation.id= ${writeInformation.id}`)
        } else {
          writeInformation.id = this.informations.length
          Hilog.log(TAG, `writeInformation.id= ${writeInformation.id}`)
        }
        this.informations.add(writeInformation)
        this.list = this.informations.convertToArray()
        Hilog.log(TAG, `this.list= ${this.list}`)
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default
  })

  build() {
    Column() {
      Row() {
        Text($r('app.string.entry_MainAbility'))
          .width('90%')
          .fontColor(Color.White)
          .fontSize(30)
        Button() {
          Image($r('app.media.add'))
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
      .height(100).width('100%')
      .backgroundColor('#0D9FFB')
      .padding({ left: 15, right: 15 })

      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.list, (item, index) => {
          ListItem() {
            Row() {
              Image($r('app.media.contact'))
                .width('20%')
                .margin({ left: 10 })
                .objectFit(ImageFit.Contain)
              Flex({ direction: FlexDirection.Column }) {
                Row() {
                  Text($r("app.string.contact_name"))
                    .fontSize(24)
                    .fontColor(Color.Black)
                  Text(item.name)
                    .fontColor(Color.Black)
                    .fontSize(24)
                }
                .margin({ top: 5 })

                Row() {
                  Text($r("app.string.contact_age"))
                    .fontColor(Color.Black)
                    .fontSize(24)
                  Text(item.age.toString())
                    .fontColor(Color.Black)
                    .fontSize(24)
                }
                .margin({ top: 5 })

                Row() {
                  Text($r("app.string.contact_phone"))
                    .fontColor(Color.Black)
                    .fontSize(24)
                  Text(item.phone)
                    .fontColor(Color.Black)
                    .fontSize(24)
                }
                .margin({ top: 5 })
              }
              .width('55%')
              .margin({ left: 10 })

              Button() {
                Text($r('app.string.button_delete'))
                  .fontColor(Color.Red)
                  .fontSize(19)
                  .width(100)
                  .textAlign(TextAlign.Center)
              }
              .type(ButtonType.Capsule)
              .backgroundColor('#F5F5F5')
              .onClick(() => {
                this.informations.remove(this.informations[index])
                this.list = this.informations.convertToArray()
              })
            }
            .width('100%')
            .align(Alignment.Center)
            .borderRadius(20)
            .backgroundColor('#FFFFFF')
          }
        })
      }
      .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#EEEEEE')
  }
}