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

const TAG: string = 'Country'

@Entry
@Component
struct Region {
  private country: string = router.getParams()['currentCountry']
  private localLanguage: string = router.getParams()['language']
  private suggestIds: Array<string> = []
  private countryIds: Array<string> = []
  @State countries: Array<{
    key: string,
    value: string
  }> = []
  @State suggestCounties: Array<{
    key: string,
    value: string
  }> = []

  aboutToAppear() {
    Logger.info(TAG, `this.country = ${this.country}`)
    this.countryIds = i18n.getSystemCountries(this.localLanguage)
    Logger.info(TAG, `systemCountryIds = ${JSON.stringify(this.countryIds)}`)
    this.countryIds.forEach(id => {
      let country = i18n.getDisplayCountry(id, this.localLanguage)
      this.countries.push({ key: country, value: '' })
      if (i18n.isSuggested(this.localLanguage, id)) {
        this.suggestIds.push(id)
        this.suggestCounties.push({ key: country, value: '' })
      }
    })
  }

  setSuggestRegion = (index) => {
    let region = this.suggestIds[index]
    let result = i18n.setSystemRegion(region)
    Logger.info(TAG, `setSystemRegion = ${result}`)
    router.back()
  }
  setRegion = (index) => {
    let region = this.countryIds[index]
    let result = i18n.setSystemRegion(region)
    Logger.info(TAG, `setSystemRegion = ${result}`)
    router.back()
  }

  @Builder
  CurrentCountryView() {
    Row() {
      Text(this.country)
        .fontSize(22)
      Blank()
      Image($r('app.media.check'))
        .width(25).height(50)
        .objectFit(ImageFit.Contain)
    }
    .size({ width: '95%', height: '7%' })
    .padding(10)
    .backgroundColor(Color.White)
    .margin({ top: 10 })
    .border({ color: Color.White, width: 1, radius: 15 })
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.select_region') })
      Scroll() {
        Column() {
          Text($r('app.string.current_region'))
            .fontSize(20).fontColor(Color.Gray)
            .width('95%')
            .margin({ top: 20 })
          this.CurrentCountryView()
          OperationListView({
            title: $r('app.string.suggest_region'),
            operations: this.suggestCounties,
            handleItemClick: this.setSuggestRegion
          })
          OperationListView({
            title: $r('app.string.all_region'),
            operations: this.countries,
            handleItemClick: this.setRegion
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