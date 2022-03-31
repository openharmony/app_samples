/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import { CustomDialogList } from '../common/customDialogList'

let TAG = '[eTSRPC.FlexList]'

@Component
export struct FlexList {
  private index: number = 0
  private menu: Array<string> = []
  private category: string = ''
  private selectStuff: (index: number, good: string, count: number) => void
  @State @Watch('amountChange') select: string = ''
  @State @Watch('amountChange') amount: number = 0
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogList({
      menu: this.menu,
      action: this.action.bind(this)
    }),
    autoCancel: true
  })

  amountChange() {
    if (this.select != undefined) {
      this.selectStuff(this.index, this.select, this.amount)
    }
  }

  action(value) {
    this.select = value
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        Text(this.category)
          .width('25%')
          .height(50)
          .padding(10)
          .fontSize(24)
          .textAlign(TextAlign.Center)
          .textOverflow({ overflow: TextOverflow.None })

        Text(this.select)
          .width('35%')
          .height(50)
          .padding(12)
          .fontSize(20)
          .textAlign(TextAlign.Center)
          .border({ width: 2, color: Color.Black })
          .textOverflow({ overflow: TextOverflow.None })
          .onClick(() => {
            this.dialogController.open()
          })

        Row() {
          Button('-', { type: ButtonType.Normal })
            .width(50)
            .height(50)
            .fontSize(16)
            .fontColor('#000000')
            .backgroundColor('#CCCCCC')
            .onClick(() => {
              if (this.amount > 0) {
                this.amount--
                console.log(`${TAG} amount is ${this.amount}`)
              }
            })

          Text(this.amount.toString())
            .width(50)
            .height(50)
            .fontSize(16)
            .backgroundColor('#CCCCCC')
            .textAlign(TextAlign.Center)
            .border({ width: 1, color: '#999999' })

          Button('+', { type: ButtonType.Normal })
            .width(50)
            .height(50)
            .fontSize(16)
            .fontColor('#000000')
            .backgroundColor('#CCCCCC')
            .onClick(() => {
              this.amount++
              console.log(`${TAG} amount is ${this.amount}`)
            })
        }
      }
      .margin({ top: 30 })
    }
  }
}