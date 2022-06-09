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
import { ThirdTitleBar, MathString, Logger } from '@ohos/library'
import { TextAreaShow } from '../Component/TextAreaShow'
import { TextShow } from '../Component/TextShow'
import { AlertShow } from '../Component/AlertShow'

const TAG: string = 'LocalLibrary'

@Entry
@Component
struct LocalLibrary {
  @State firstString: string = ''
  @State secondString: string = ''
  @State resultString: string = ''
  private mathString: MathString = new MathString()
  private logger: Logger = new Logger('[npm]')
  private pinDialogController: CustomDialogController | undefined = undefined

  build() {
    Column() {
      ThirdTitleBar()
      Scroll() {
        Column() {
          TextShow({ text: $r('app.string.third_string_splicing'), fontSize: 25 })
          TextShow({ text: $r('app.string.input_first_string'), fontSize: 20 })
          TextAreaShow({ placeholder: '', value: $firstString })
          TextShow({ text: $r('app.string.input_second_string'), fontSize: 20 })
          TextAreaShow({ placeholder: '', value: $secondString })
          Button('确定')
            .fontSize(20)
            .width(100)
            .height(50)
            .type(ButtonType.Normal)
            .margin({ top: 20 })
            .onClick(() => {
              if (this.firstString === '') {
                this.pinDialogController = new CustomDialogController({
                  builder: AlertShow({ text: $r('app.string.input_first_string') }),
                })
                this.pinDialogController.open()
                return
              }
              if (this.secondString === '') {
                this.pinDialogController = new CustomDialogController({
                  builder: AlertShow({ text: $r('app.string.input_second_string') }),
                })
                this.pinDialogController.open()
                return
              }
              this.resultString = this.mathString.add(this.firstString, this.secondString)
              this.logger.info(TAG, `onClick resultString = ${this.resultString}`)
            })
          if (this.firstString != '' && this.secondString != '') {
            Text(`拼接后字符串：${this.resultString}`)
              .fontSize(20)
              .alignSelf(ItemAlign.Start)
              .margin({ top: '3%', left: '5%' })
          }
        }.width('100%')
      }
      .constraintSize({ maxHeight: '85%' })
    }
  }
}