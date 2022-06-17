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
import Logger from '../model/Logger'
import PreferencesUtils from '../model/PreferencesUtils'
import TitleBar from '../common/TitleBar'

const TAG: string = 'Index'

@Entry
@Component
struct Index {
  private defaultPassword: string = ''
  private patternLockController: PatternLockController = new PatternLockController()
  @State message: Resource = $r('app.string.message_input')
  @State isReset: boolean = false
  @State password: Number[] = []
  @State isHasPass: boolean = true
  @State isShowSetting: boolean = false

  aboutToAppear() {
    this.password = []
    PreferencesUtils.getPassword().then((password) => {
      this.defaultPassword = <string> password
      Logger.info(TAG, `get passworld ${this.defaultPassword}`)
      if (this.defaultPassword === 'null') {
        this.isHasPass = false
      } else {
        this.isHasPass = true
      }
    })
  }

  build() {
    Column() {
      TitleBar()
      Column() {
        if (this.isHasPass && !this.isReset) {
          Text($r('app.string.reset_password'))
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
            .padding(20)
            .width('100%')
            .fontColor(Color.Blue)
            .onClick(() => {
              this.isReset = true
              this.message = $r('app.string.message_input_old')
            })
        }
        Text(this.message)
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .width('90%')
          .padding(10)
        PatternLock(this.patternLockController)
          .sideLength(300)
          .circleRadius(15)
          .pathStrokeWidth(15)
          .autoReset(true)
          .margin({ top: 30, bottom: 50 })
          .onPatternComplete((input: Array<number>) => {
            if (input === null || input === undefined || input.length < 5) {
              this.message = $r('app.string.message_password_length_insufficient')
              return
            }
            if (this.isHasPass) {
              if (this.defaultPassword === input.toString()) {
                if (this.isReset) {
                  this.message = $r('app.string.message_input_new')
                  this.defaultPassword = 'null'
                  this.patternLockController.reset()
                  this.password = []
                  this.isHasPass = false
                  return
                }
                router.replace({
                  url: 'pages/Home'
                })
              } else {
                this.message = $r('app.string.message_incorrect')
                this.password = []
                return
              }
            }
            if (this.password.length > 0) {
              if (this.password.toString() === input.toString()) {
                this.password = input
                this.message = $r('app.string.message_correct')
                this.isShowSetting = true
              } else {
                this.message = $r('app.string.message_not_match')
                this.patternLockController.reset()
              }
            } else {
              this.password = input
              this.message = $r('app.string.message_input_again')
              this.patternLockController.reset()
            }
          })
        if (this.isShowSetting) {
          Button($r('app.string.message_set_password'))
            .margin(30)
            .width('60%')
            .onClick(() => {
              Logger.info(TAG, `set passWorld`)
              this.defaultPassword = this.password.toString()
              PreferencesUtils.setPassword(this.password.toString())
              this.message = $r('app.string.message_set_success')
              this.isHasPass = true
              this.patternLockController.reset()
              this.password = []
              this.isReset = false
            })
        }
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.End)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
    .opacity(0.7)
  }
}