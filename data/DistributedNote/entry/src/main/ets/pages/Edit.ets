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
import TitleBar from '../common/TitleBar'

@Entry
@Component
struct Edit {
  @State note: Note = router.getParams()['note']
  private isAdd: boolean = router.getParams()['isAdd']
  private index: number = 0
  @State imageShow: boolean = false

  aboutToAppear() {
    if (!this.isAdd) {
      this.index = router.getParams()['index']
    }
  }

  build() {
    Column() {
      TitleBar({ title: this.note.title === '' ? $r('app.string.add_note') : this.note.title })
      Column() {
        Row() {
          Image(this.note.mark >= 0 ? MARKS[this.note.mark] : $r('app.media.mark'))
            .width(30)
            .aspectRatio(1)
            .margin({ left: 16, top: 16 })
            .objectFit(ImageFit.Contain)
            .alignSelf(ItemAlign.Start)
          Select([{ value: '   ', icon: MARKS[0] },
                  { value: '   ', icon: MARKS[1] },
                  { value: '   ', icon: MARKS[2] },
                  { value: '   ', icon: MARKS[3] },
                  { value: '   ', icon: MARKS[4] }])
            .selected(this.note.mark)
            .margin({ top: 5 })
            .onSelect((index: number) => {
              this.note.mark = index
            })
        }
        .width('100%')

        TextInput({ placeholder: 'input the title', text: this.note.title })
          .placeholderColor(Color.Gray)
          .fontSize(30)
          .margin({ left: 15, right: 15, top: 15 })
          .height(60)
          .backgroundColor(Color.White)
          .onChange((value: string) => {
            this.note.title = value
          })
        TextArea({ placeholder: 'input the content', text: this.note.content })
          .placeholderColor(Color.Gray)
          .backgroundColor(Color.White)
          .fontSize(30)
          .height('35%')
          .margin({ left: 16, right: 16, top: 16 })
          .textAlign(TextAlign.Start)
          .onChange((value: string) => {
            this.note.content = value
          })

        Button() {
          Text($r('app.string.save'))
            .fontColor(Color.White)
            .fontSize(17)
        }
        .backgroundColor('#0D9FFB')
        .height(50)
        .width(200)
        .margin({ top: 20 })
        .onClick(() => {
          if (!this.isAdd) {
            let index = router.getParams()['index']
            globalThis.objectModel.update(index, this.note.title, this.note.content, this.note.mark)
          } else {
            globalThis.objectModel.add(this.note.title, this.note.content, this.note.mark)
          }
          router.back()
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}