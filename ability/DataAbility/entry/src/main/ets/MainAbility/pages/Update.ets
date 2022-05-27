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
import router from '@ohos.router'
import prompt from '@ohos.prompt'
import dataAbility from '@ohos.data.dataAbility'
import { BASE_URI, DA_HELPER } from '../model/DaHelperConst'
import { BookModel } from '../model/BookDataModel'

const TAG = 'DataAbility.Update'

@Entry
@Component
struct Update {
  private book: BookModel = <BookModel> router.getParams()['book']

  aboutToAppear() {
    console.info(TAG + ' aboutToAppear')
  }

  updateBook = () => {
    let predicates = new dataAbility.DataAbilityPredicates()
    predicates.equalTo('id', this.book.id)
    let valuesBucket = {
      'name': this.book.name,
      'introduction': this.book.introduction
    }
    DA_HELPER.update(BASE_URI, valuesBucket, predicates, (err, num) => {
      console.info(TAG + ' update book num=' + num)
      router.back()
    })
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(40).height(40)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
        Text($r('app.string.title'))
          .fontColor(Color.White)
          .fontSize(20)
          .layoutWeight(1)
        Image($r('app.media.submit'))
          .width(50).height(50)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            console.info(TAG + ' update onClick,title=' + this.book.name)
            if (this.book.name === '' || this.book.introduction === '') {
              prompt.showToast({ message: 'Please input name or introduction' })
              return
            }
            this.updateBook()
          })
      }
      .height(50).width('100%')
      .backgroundColor('#0D9FFB')
      .padding({ left: 10, right: 10 })

      Scroll() {
        Column() {
          Image($r('app.media.book'))
            .width(120).height(150)
            .objectFit(ImageFit.Fill)
            .margin(5)
          Text($r('app.string.book_name'))
            .fontWeight(FontWeight.Bold)
            .fontSize(22)
            .width('100%')
            .margin({ top: 20 })
            .fontColor(Color.Black)
          TextInput({ placeholder: 'input name', text: this.book.name })
            .type(InputType.Normal)
            .placeholderColor(Color.Gray)
            .fontSize(19)
            .margin({ top: 10 })
            .onChange((value: string) => {
              this.book.name = value
            })

          Text($r('app.string.book_intro'))
            .fontWeight(FontWeight.Bold)
            .fontSize(22)
            .width('100%')
            .fontColor(Color.Black)
            .margin({ top: 20 })
          TextInput({ placeholder: 'input introduction', text: this.book.introduction })
            .type(InputType.Normal)
            .placeholderColor(Color.Gray)
            .fontSize(19)
            .margin({ right: 10, top: 10 })
            .onChange((value: string) => {
              this.book.introduction = value
            })
        }
        .width('100%')
        .constraintSize({ minHeight: '100%' })
        .padding(15)
      }.height('100%')
    }
  }
}