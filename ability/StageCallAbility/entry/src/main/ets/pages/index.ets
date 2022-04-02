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

import ButtonClickModel from '../model/ButtonClickModel'

@Entry
@Component
struct Index {
  private buttonRes: Array<Resource> = [
    $r('app.string.Start_Callee_Ability'),
    $r('app.string.Start_Remote_Ability'),
    $r('app.string.Get_Caller'),
    $r('app.string.Get_Remote_Caller'),
    $r('app.string.Release_Caller'),
    $r('app.string.Caller_CallWithResult')
  ]
  private buttonClickModel = new ButtonClickModel()
  @State message: string = 'Call Sample'
  @State originMsg: string = ''
  @State backMsg: string = ''

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
        ForEach(this.buttonRes, (item, index) => {
          Button() {
            Text(item)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
          }
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('35%')
          .height('5%')
          .onClick(() => {
            switch (index) {
              case 0:
                this.buttonClickModel.onButtonStartSecondAbility()
                break
              case 1:
                this.buttonClickModel.onButtonStartRemoteAbility()
                break
              case 2:
                this.buttonClickModel.onButtonGetCaller()
                break
              case 3:
                this.buttonClickModel.onButtonGetRemoteCaller()
                break
              case 4:
                this.buttonClickModel.onButtonRelease()
                break
              case 5:
                this.buttonClickModel.onButtonCallWithResult(this.originMsg, (after) => {
                  this.backMsg = after
                })
                break
              default:
                break;
            }
          })
        }, item => JSON.stringify(item))

        TextArea({ placeholder: $r('app.string.Input_Placeholder') })
          .fontSize(12)
          .width('35%')
          .constraintSize({ minHeight: 40 })
          .margin({ top: 10 })
          .onChange((value: string) => {
            this.originMsg = value
          })
        Text(this.backMsg)
          .fontSize(16)
          .width('35%')
          .margin({ top: 10 })
          .constraintSize({ minHeight: 40 })
          .padding(10)
          .border({ width: 1, color: Color.Gray, radius: 20 })
      }
      .width('100%')
    }
    .height('100%')
  }
}