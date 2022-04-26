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
import dataRdb from '@ohos.data.rdb'
import router from '@ohos.router'
import prompt from '@ohos.prompt'
import Contact from '../model/Contact'
import Logger from '../model/Logger'
import RdbModel from '../model/RdbModel'
import { TitleBar } from '../common/TitleBar'
import { TABLE_NAME } from '../model/RdbConst'

const TAG = 'ContactEdit'

@Entry
@Component
struct ContactEdit {
  private params: any = router.getParams()
  private isInsert: boolean = <boolean> this.params.isInsert
  @State contact: Contact = <Contact> this.params.contact
  @State handleSelect: boolean = false

  @Builder InputText(icon, placeHolder, text, filter, maxLength, onChange) {
    Row() {
      Image(icon)
        .height(30).width(30)
        .objectFit(ImageFit.Contain)
      TextInput({ placeholder: placeHolder, text: text })
        .layoutWeight(1)
        .fontSize(25)
        .placeholderFont({ size: 25 })
        .height(50)
        .inputFilter(filter)
        .maxLength(maxLength)
        .backgroundColor(Color.White)
        .onChange(onChange)
    }
    .width('95%')
    .padding(16)
    .margin({ top: 16 })
    .backgroundColor(Color.White)
    .borderRadius(16)
  }

  @Builder popupBuilder() {
    Column({ space: 2 }) {
      Text($r('app.string.male'))
        .fontSize(25)
        .width('100%')
        .padding(5)
        .onClick(() => {
          this.handleSelect = !this.handleSelect
          this.contact.gender = 0
        })
      Divider().color(Color.Black).height(1)
      Text($r('app.string.female'))
        .fontSize(25)
        .width('100%')
        .padding(5)
        .onClick(() => {
          this.handleSelect = !this.handleSelect
          this.contact.gender = 1
        })
    }
    .width('35%')
    .padding(10)
    .backgroundColor(Color.White)
  }

  handleSubmit = async () => {
    if (this.contact.name === '') {
      prompt.showToast({ message: '姓名不能为空', duration: 1000 })
      return
    }
    if (this.contact.phone === '') {
      prompt.showToast({ message: '手机不能为空', duration: 1000 })
      return
    }
    if (this.isInsert) {
      let predicates = new dataRdb.RdbPredicates(TABLE_NAME)
      predicates.equalTo('name', this.contact.name)
      let alreadyExist = await RdbModel.query(predicates)
      if (alreadyExist.length > 0) {
        Logger.info(TAG, 'already exist, need update')
        this.contact.id = alreadyExist[0].id
        await RdbModel.updateData(this.contact)
      } else {
        await RdbModel.insertData(this.contact)
        Logger.info(TAG, 'insert success')
      }
    } else {
      await RdbModel.updateData(this.contact)
      Logger.info(TAG, 'update success')
    }
    router.back()
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true, rightBtn: $r('app.media.submit'), handleRightBtn: this.handleSubmit })
      Image($r('app.media.contact_photo'))
        .width('30%')
        .aspectRatio(1)
        .objectFit(ImageFit.Fill)
        .onClick(() => {
          router.back()
        })
      Row() {
        Text($r('app.string.gender'))
          .fontSize(25)
        Text(this.contact.gender === 0 ? $r('app.string.male') : $r('app.string.female'))
          .fontSize(25)
          .border({ width: 1, color: Color.Black })
          .width('30%')
          .padding(5)
          .margin({ left: 5 })
          .textAlign(TextAlign.Center)
          .bindPopup(this.handleSelect, {
            builder: this.popupBuilder,
            placement: Placement.Bottom,
            maskColor: 0x33000000,
            popupColor: Color.White,
            enableArrow: false
          })
          .onClick(() => {
            this.handleSelect = !this.handleSelect
          })
      }

      this.InputText($r('app.media.ic_contact'), $r('app.string.name'), this.contact.name, '', 20, (value: string) => {
        this.contact.name = value
      })
      this.InputText($r('app.media.ic_telephone'), $r('app.string.phone'), this.contact.phone, '^1[0-9]*$', 11, (value: string) => {
        this.contact.phone = value
      })
      this.InputText($r('app.media.ic_remark'), $r('app.string.remark'), this.contact.remark, '', 50, (value: string) => {
        this.contact.remark = value
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F9F9F9')
  }
}