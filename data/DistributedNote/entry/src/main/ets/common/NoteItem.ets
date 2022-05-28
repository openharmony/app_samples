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
import { MARKS } from '../model/Const'
import Note from '../model/Note'

@Component
export default struct NoteItem {
  @State note: Note | undefined = undefined
  private index: number = 0

  build() {
    Row() {
      Image(this.note.mark >= 0 ? MARKS[this.note.mark] : $r('app.media.note'))
        .size({ width: 30, height: 30 })
        .objectFit(ImageFit.Contain)
      Column() {
        Text(this.note.title)
          .fontColor(Color.Black)
          .fontSize(30)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.note.content)
          .fontColor(Color.Gray)
          .margin({ top: 10 })
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 20 })
    }
    .padding(16)
    .width('100%')
    .borderRadius(16)
    .backgroundColor(Color.White)
    .onClick(() => {
      router.push({
        url: 'pages/Edit',
        params: {
          index: this.index,
          note: this.note,
          isAdd: false
        }
      })
    })
  }
}
