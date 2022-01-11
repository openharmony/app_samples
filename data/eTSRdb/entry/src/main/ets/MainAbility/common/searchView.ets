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

@Component
export struct SearchView {
  private searchName: string = ''
  private queryByNameCallback = null
  private queryByAgeCallback = null
  private queryByPhoneCallback = null

  build() {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.End }) {
          TextInput({ placeholder: 'input name' })
            .layoutWeight(1)
            .type(InputType.Normal)
            .placeholderColor(Color.Gray)
            .fontSize(19)
            .margin({ left: 15, right: 15 })
            .onChange((value: string) => {
              this.searchName = value
            })
          Image($r("app.media.search_gray"))
            .objectFit(ImageFit.Contain)
            .height(35)
            .width(35)
            .margin({ right: 20 })
        }
        .height(50).layoutWeight(1)

        Button() {
          Text($r('app.string.query_by_name'))
            .fontColor(Color.White)
            .fontSize(19)
            .width(140)
            .textAlign(TextAlign.Center)
        }
        .type(ButtonType.Capsule)
        .backgroundColor('#0D9FFB')
        .margin({ right: 10 })
        .onClick(() => {
          console.info('[Rdb.SearchView] query name=' + this.searchName)
          this.queryByNameCallback(this.searchName)
        })
      }

      Row() {
        Text($r('app.string.query_by_age_tip'))
          .layoutWeight(1)
          .fontColor(Color.Black)
          .fontSize(19)
          .margin({ left: 15 })
        Button() {
          Text($r('app.string.query_by_age'))
            .fontColor(Color.White)
            .fontSize(19)
            .width(140)
            .textAlign(TextAlign.Center)
        }
        .type(ButtonType.Capsule)
        .backgroundColor('#0D9FFB')
        .margin({ right: 25 })
        .onClick(() => {
          this.queryByAgeCallback()
        })
      }
      .width('100%')
      .margin({ top: 5 })

      Row() {
        Text($r('app.string.query_by_phone_tip'))
          .layoutWeight(1)
          .fontColor(Color.Black)
          .fontSize(19)
          .margin({ left: 15 })
        Button() {
          Text($r('app.string.query_by_phone'))
            .fontColor(Color.White)
            .fontSize(19)
            .width(140)
            .textAlign(TextAlign.Center)
        }
        .type(ButtonType.Capsule)
        .backgroundColor('#0D9FFB')
        .margin({ right: 25 })
        .onClick(() => {
          this.queryByPhoneCallback()
        })
      }
      .width('100%')
      .margin({ top: 5 })
    }
  }
}