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
import i18n from '@ohos.i18n'
import router from '@ohos.router'
import Logger from '../model/Logger'

const TAG: string = 'EditPreferred'

@Entry
@Component
struct EditPreferred {
  private localLanguage: string = router.getParams()['language']
  private deletePreferredLanguages: Array<number> = []
  @State preferredLanguages: Array<[string, string]> = []

  aboutToAppear() {
    this.preferredLanguages = []
    let preferredLanguageIds = i18n.getPreferredLanguageList()
    Logger.info(TAG, `this.preferredLanguageIds = ${JSON.stringify(preferredLanguageIds)}`)
    preferredLanguageIds.forEach(id => {
      this.preferredLanguages.push([
        i18n.getDisplayLanguage(id, id),
        i18n.getDisplayLanguage(id, this.localLanguage)
      ])
    })
  }

  @Builder
  PreferredItem(preferred, index) {
    if (index !== 0) {
      Divider()
        .color(Color.Gray)
        .width('100%')
        .strokeWidth(1)
        .margin({ top: 10, bottom: 10 })
    }
    Row() {
      Column() {
        Text(preferred[0])
          .fontColor(preferred[0] === preferred[1] ? Color.Blue : Color.Black)
          .fontSize(22)
          .margin({ top: 10, bottom: 10 })
        if (preferred[0] !== preferred[1]) {
          Text(preferred[1])
            .fontColor(Color.Gray)
            .fontSize(22)
            .margin({ top: 10, bottom: 10 })
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      if (preferred[0] !== preferred[1]) {
        Image($r('app.media.delete'))
          .size({ width: 40, height: 40 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.deletePreferredLanguages.push(index)
            this.preferredLanguages.splice(index, 1)
          })
      }
    }
  }

  @Builder
  PreferredView() {
    Column() {
      ForEach(this.preferredLanguages, (item, index) => {
        this.PreferredItem(item, index)
      }, item => item[1])
    }
    .width('95%')
    .padding(10)
    .margin({ top: 20, bottom: 10 })
    .backgroundColor(Color.White)
    .border({ color: Color.White, width: 1, radius: 15 })
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(60).height('100%')
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
        Text($r('app.string.edit_language'))
          .fontSize(30)
          .layoutWeight(1)
        Blank()
        Image($r('app.media.check'))
          .width(60).height('100%')
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.deletePreferredLanguages.forEach((item: number) => {
              i18n.removePreferredLanguage(item)
            })
            router.back()
          })
      }
      .width('100%')
      .height('8%')
      .constraintSize({ minHeight: 70 })
      .padding({ left: 16, right: 16 })
      .backgroundColor('#F5F5F5')

      Scroll() {
        this.PreferredView()
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}