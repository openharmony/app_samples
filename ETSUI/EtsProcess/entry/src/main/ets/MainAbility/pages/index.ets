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
import process from '@ohos.process'

let child = null

@Entry
@Component
struct Index {
  @State result: string = ''

  build() {
    Column() {
      Text($r('app.string.entry_MainAbility'))
        .width('100%')
        .height(50)
        .backgroundColor('#0D9FFB')
        .fontColor(Color.White)
        .fontSize(20)
        .padding({ left: 15 })
      Scroll() {
        Column() {
          Button() {
            Text($r('app.string.uptime'))
              .fontSize(19)
              .fontWeight(FontWeight.Bold)
              .padding({ left: 10, right: 10 })
              .width('100%')
              .textAlign(TextAlign.Center)
          }.type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .onClick(() => {
            this.result = process.uptime().toString() + 's'
            console.info('[EtsProcess]uptime=' + this.result)
          })
          Button() {
            Text($r('app.string.cwd'))
              .fontSize(19)
              .fontWeight(FontWeight.Bold)
              .padding({ left: 10, right: 10 })
              .width('100%')
              .textAlign(TextAlign.Center)
          }.type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .margin({ top: 15 })
          .onClick(() => {
            console.info('[EtsProcess]process cwd')
            this.result = process.cwd().toString()
          })
          Button() {
            Text($r('app.string.change_work_directory'))
              .fontSize(19)
              .fontWeight(FontWeight.Bold)
              .padding({ left: 10, right: 10 })
              .width('100%')
              .textAlign(TextAlign.Center)
          }.type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .margin({ top: 15 })
          .onClick(() => {
            console.info('[EtsProcess]process change dir')
            process.chdir('/system')
            this.result = process.cwd().toString()
          })
          Button() {
            Text($r('app.string.kill'))
              .fontSize(19)
              .fontWeight(FontWeight.Bold)
              .padding({ left: 10, right: 10 })
              .width('100%')
              .textAlign(TextAlign.Center)
          }.type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .margin({ top: 15 })
          .onClick(() => {
            console.info('[EtsProcess]send signal')
            var pres = process.getPid
            var result = process.kill(pres, 28)
            if (result === true) {
              this.result = 'succeed'
            } else {
              this.result = 'failed'
            }
          })
          Button() {
            Text($r('app.string.runCmd'))
              .fontSize(19)
              .fontWeight(FontWeight.Bold)
              .padding({ left: 10, right: 10 })
              .width('100%')
              .textAlign(TextAlign.Center)
          }.type(ButtonType.Capsule)
          .margin({ top: 15 })
          .backgroundColor('#0D9FFB')
          .onClick(() => {
            child = process.runCmd('sleep 3;ls')
            this.result = child == null ? 'failed' : 'succeed'
            console.info('[EtsProcess]runCmd=' + this.result)
            var result = child.wait();
            result.then(val => {
              this.result = 'child process run finish' + JSON.stringify(val)
              console.info('[EtsProcess]runCmd result =' + val)
            })
          })
          Button() {
            Text($r('app.string.close_child'))
              .fontSize(19)
              .fontWeight(FontWeight.Bold)
              .padding({ left: 10, right: 10 })
              .width('100%')
              .textAlign(TextAlign.Center)
          }.type(ButtonType.Capsule)
          .margin({ top: 15 })
          .backgroundColor('#0D9FFB')
          .onClick(() => {
            console.info('[EtsProcess]close child process')
            child.close()
            this.result = 'close succeed'
          })
          Button() {
            Text($r('app.string.exit'))
              .fontSize(19)
              .fontWeight(FontWeight.Bold)
              .padding({ left: 10, right: 10 })
              .width('100%')
              .textAlign(TextAlign.Center)
          }.type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .margin({ top: 15 })
          .onClick(() => {
            console.info('[EtsProcess]process exit')
            process.exit(0)
          })
          Text(this.result)
            .width('100%')
            .height(100)
            .backgroundColor('#DFDFDF')
            .fontSize(20)
            .margin({ top: 20 })
            .textAlign(TextAlign.Start)
            .padding(10)
        }.constraintSize({ minHeight: '100%' })
      }
      .width('100%').height('100%')
      .padding(15)
    }
  }
}