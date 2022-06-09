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
import { create, all, MathJsStatic } from 'mathjs'
import { TitleBar } from '../Component/TitleBar'
import { TextShow } from '../Component/TextShow'

const math: MathJsStatic = create(all)

@Entry
@Component
struct Index {
  @State value: string = ''
  onClickButton = () => {
    globalThis.abilityContext.terminateSelf()
  }

  build() {
    Column() {
      TitleBar({ handleButtonClick: this.onClickButton })
      Scroll() {
        Column() {
          TextShow({ text: $r('app.string.first_mathjs'), fontSize: 25 })
          Button($r('app.string.generate_captcha'))
            .fontSize(20)
            .width(200)
            .height(50)
            .type(ButtonType.Normal)
            .margin('5%')
            .onClick(() => {
              this.value = ''
              for (let i = 0; i < 6; i++) {
                let number = Math.trunc(math.chain(Math.random()).multiply(10).done())
                this.value = this.value + number
              }
            })
          Text(this.value)
            .fontSize(35)
            .backgroundColor('#ffe5d9d9')
            .fontColor('#ffc81c1c')
            .fontStyle(FontStyle.Italic)
            .margin({ top: 20 })
          Button($r('app.string.next_page'))
            .fontSize(20)
            .width(150)
            .height(50)
            .type(ButtonType.Normal)
            .margin({ top: '25%', left: '2%' })
            .onClick(() => {
              this.value = ''
              router.push({
                url: 'pages/DatePage'
              })
            })
        }
        .height('100%')
        .width('100%')
      }
      .constraintSize({ maxHeight: '85%' })
    }
  }
}