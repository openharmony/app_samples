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

@CustomDialog
export struct ActionSheetDialog {
  private controller: CustomDialogController
  private title: string = ''
  private sheets = []
  private action: (key: string) => void

  build() {
    Column() {
      Text(this.title)
        .width('100%')
        .fontSize(18)
        .fontColor(Color.Black)
        .textAlign(TextAlign.Center)
        .margin({ top: 10, bottom: 10 })
      List(){
        ForEach(this.sheets, item => {
          ListItem(){
            Row(){
              Text('key:')
                .fontSize(18)
                .fontColor(Color.Gray)
              Text(item)
                .fontSize(18)
                .fontColor(Color.Gray)
            }
            .width('100%')
            .margin(10)
          }
          .width('100%')
          .onClick(() => {
            this.controller.close()
            this.action(item)
          })
        })
      }
      .width('100%')
      .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 5, endMargin: 5 })
    }
    .width('80%')
  }
}