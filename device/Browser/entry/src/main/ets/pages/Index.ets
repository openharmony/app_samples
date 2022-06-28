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
import mediaquery from '@ohos.mediaquery'
import parameter from '@ohos.systemparameter'
import { TabletTitle, BrowserTabs, WebTab } from '../common/TitleBar'
import { PhoneLayout } from '../common/PhoneLayout'
import { Browser, LoadingStatus } from '../model/Browser'
import Logger from '../model/Logger'

const TAG = '[index]'

@Entry
@Component
struct Index {
  @State isPhone: boolean= false
  @State browser: Browser= new Browser()
  private isInit: Boolean= false
  listener= mediaquery.matchMediaSync('(orientation:landscape)')

  build() {
    Flex({ direction: FlexDirection.Column }) {
      if (!this.isPhone) {
        TabletTitle({ browser: $browser })
        Progress({ value: this.browser.progress, total: 100 })
          .color('#0000ff')
          .visibility(this.browser.hideProgress ? Visibility.None : Visibility.Visible)
        BrowserTabs({ browser: $browser })
        Divider().color('#c6c6c6').width('100%').flexShrink(0)
        WebTab({ browser: $browser, isPhone: $isPhone })
      } else {
        PhoneLayout({ browser: $browser })
      }
    }
  }

  aboutToAppear() {
    try {
      let deviceType = parameter.getSync("const.build.characteristics")
      if (deviceType === 'phone') {
        this.isPhone = true
      }
    } catch (e) {
      Logger.info(TAG, `getSync unexpected error: ${e}`)
    }
  }

  orientationCallback(result) {
    if (!this.isInit) {
      if (result.matches) {
        this.isPhone = false
      } else {
        this.isPhone = true
      }
      this.isInit = true
    }
    Logger.info(TAG, `orientationCallback end,isPhone=${this.isPhone}`)
  }

  onBackPress(): boolean{
    Logger.info(TAG, `enter onBackPress`)
    if (this.browser.webControllerArray[this.browser.tabArrayIndex].controller.accessBackward() ||
    this.browser.loadingStatus === LoadingStatus.LOADING) {
      this.browser.webControllerArray[this.browser.tabArrayIndex].controller.backward()
      return true
    }
    return false
  }

  onDeviceChange() {
    this.browser = new Browser()
  }
}