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
import mediaLibrary from '@ohos.multimedia.mediaLibrary'

@CustomDialog
export default struct ImagePicker {
  private imageDatas: Array<mediaLibrary.FileAsset> = []
  private selected: number = 0
  public controller: CustomDialogController
  @Link index: number

  aboutToAppear() {
    this.selected = this.index
  }

  build() {
    Column() {
      List({ space: 5 }) {
        ForEach(this.imageDatas, (item, index) => {
          ListItem() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image(item.uri).width(180).height(150).margin({ left: 2, right: 2, top: 5, bottom: 5 })
              Radio({ value: 'Radio3', group: 'radioGroup' }).checked(index === this.index ? true : false)
                .onChange(() => {
                  this.selected = index
                })
            }
          }
        })
      }
      .width('95%')
      .height(160)
      .listDirection(Axis.Horizontal)

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.cancel'))
          .onClick(() => {
            this.controller.close()
          })
        Button($r('app.string.conform'))
          .onClick(() => {
            this.index = this.selected
          })
      }
      .margin({ bottom: 10 })
    }
    .width('100%')
  }
}