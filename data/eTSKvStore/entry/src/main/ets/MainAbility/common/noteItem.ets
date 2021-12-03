/*
 * Copyright (c) 2020 Huawei Device Co., Ltd.
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
import {NoteModel} from '../model/noteDataModel'

@Component
export struct NoteListItem {
  private note: NoteModel = null
  private deleteNoteCallBack = null

  build() {
    Column() {
      if (this.note.title === '' && this.note.content === '') {
        Image($r('app.media.add'))
          .objectFit(ImageFit.Contain)
          .width(50).height('100%')
      } else {
        Stack({ alignContent: Alignment.TopEnd }) {
          Column() {
            Text(this.note.title)
              .fontColor(Color.Black)
              .fontSize(20)
              .height('50%')
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 20 })
            Text(this.note.content)
              .fontColor(Color.Gray)
              .fontSize(18)
              .width('100%')
              .textAlign(TextAlign.Center)
          }
          .width('100%').height('100%')

          Image($r('app.media.delete'))
            .width('30%')
            .height('30%')
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              this.deleteNoteCallBack(this.note)
            })
        }
      }
    }
    .width('100%')
    .height(120)
    .backgroundColor('#DFDFF5')
    .border({ width: 5, color: '#F5F5F5', radius: 10 })
  }
}