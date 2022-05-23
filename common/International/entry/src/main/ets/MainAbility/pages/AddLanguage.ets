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
import OperationListView from '../view/OperationListView'
import TitleBar from '../view/TitleBar'

const TAG: string = 'AddLanguage'

@Entry
@Component
struct AddLanguage {
  private languageIds: Array<string> = []
  @State languages: Array<{
    key: string,
    value: string
  }> = []
  @State preferredLanguages: Array<{
    key: string,
    value: string
  }> = []

  aboutToAppear() {
    let preferredLanguageIds = i18n.getPreferredLanguageList()
    Logger.info(TAG, `preferredLanguageIds = ${JSON.stringify(preferredLanguageIds)}`)
    preferredLanguageIds.forEach(id => {
      this.preferredLanguages.push(
        { key: i18n.getDisplayLanguage(id, id),
          value: i18n.getDisplayLanguage(id, i18n.getSystemLocale())
        }
      )
    })
    this.languageIds = i18n.getSystemLanguages()
    Logger.info(TAG, `this.languageIds = ${JSON.stringify(this.languageIds)}`)
    this.languageIds.forEach(id => {
      this.languages.push(
        {
          key: i18n.getDisplayLanguage(id, id),
          value: i18n.getDisplayLanguage(id, i18n.getSystemLocale())
        }
      )
    })
  }

  addLanguage = (index) => {
    let language = this.languageIds[index]
    Logger.info(TAG, `addPreferredLanguage = ${language}`)
    i18n.addPreferredLanguage(language)
    router.back()
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.add_language') })
      Scroll() {
        Column() {
          OperationListView({
            title: $r('app.string.added_language'),
            operations: this.preferredLanguages,
            handleItemClick: null
          })
          OperationListView({
            title: $r('app.string.all_language'),
            operations: this.languages,
            handleItemClick: this.addLanguage
          })
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}