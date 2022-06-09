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
import dayjs from 'dayjs'
import router from '@ohos.router'
import { TitleBar } from '../Component/TitleBar'
import { AlertShow } from '../Component/AlertShow'
import { TextShow } from '../Component/TextShow'
import { TextAreaShow } from '../Component/TextAreaShow'

@Entry
@Component
struct DatePage {
  @State value: string = ''
  @State beforeValue: string = ''
  @State afterValue: string = ''
  @State afterDays: string = ''
  @State beforeDays: string = ''
  private pinDialogController: CustomDialogController | undefined = undefined
  onClickButton = () => {
    router.back()
  }

  build() {
    Column() {
      TitleBar({ handleButtonClick: this.onClickButton })
      Scroll() {
        Column() {
          TextShow({ text: $r('app.string.second_dayjs'), fontSize: 25 })
          TextShow({ text: $r('app.string.input_math_date'), fontSize: 20 })
          TextAreaShow({ placeholder: '2000-01-01', value: $value })
          TextShow({ text: $r('app.string.before_day'), fontSize: 20 })
          TextAreaShow({ placeholder: '0', value: $beforeDays })
          TextShow({ text: $r('app.string.after_day'), fontSize: 20 })
          TextAreaShow({ placeholder: '0', value: $afterDays })
          Button($r('app.string.sure'))
            .fontSize(20)
            .width(100)
            .height(50)
            .type(ButtonType.Normal)
            .margin({ top: 20 })
            .onClick(() => {
              if (this.value === '') {
                this.pinDialogController = new CustomDialogController({
                  builder: AlertShow({ text: $r('app.string.input_math_date') }),
                })
                this.pinDialogController.open()
                return
              }
              if (this.beforeDays === '' && this.afterDays === '') {
                this.pinDialogController = new CustomDialogController({
                  builder: AlertShow({ text: $r('app.string.input_before_after') }),
                })
                this.pinDialogController.open()
                return
              }

              if (this.beforeDays) {
                let day = dayjs(this.value)
                  .subtract(Number(this.beforeDays), 'day')
                this.beforeValue = `${day.year()}-${day.month() + 1}-${day.date()}`
              }
              if (this.afterDays) {
                let day = dayjs(this.value)
                  .add(Number(this.afterDays), 'day')
                this.afterValue = `${day.year()}-${day.month() + 1}-${day.date()}`
              }
            })


          if (this.beforeDays) {
            Text(`${this.beforeDays} 天前日期：${this.beforeValue}`)
              .fontSize(20)
              .alignSelf(ItemAlign.Start)
              .margin({ top: '3%', left: '5%' })
          }

          if (this.afterDays) {
            Text(`${this.afterDays} 天后日期：${this.afterValue}`)
              .fontSize(20)
              .alignSelf(ItemAlign.Start)
              .margin({ top: '3%', left: '5%' })
          }

          Button($r('app.string.next_page'))
            .fontSize(20)
            .width(150)
            .height(50)
            .type(ButtonType.Normal)
            .margin({ top: 20 })
            .onClick(() => {
              this.value = ''
              router.push({
                url: 'pages/LocalLibrary'
              })
            })

        }.width('100%')
      }
      .constraintSize({ maxHeight: '85%' })
    }
  }
}