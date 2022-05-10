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
import { WifiModel } from '../model/WifiModel'
import { InfoView } from '../component/InfoView'

@Entry
@Component
struct About {
  private wifiModel: WifiModel = new WifiModel()

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .size({ width: 50, height: '100%' })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
        Text($r('app.string.about'))
          .fontColor(Color.White)
          .fontSize(25)
          .layoutWeight(1)
      }
      .width('100%').height('8%')
      .constraintSize({ minHeight: 50 })
      .backgroundColor('#0D9FFB')

      Scroll() {
        Column() {
          InfoView({ infoList: this.wifiModel.getIpInfo() })
          InfoView({ infoList: this.wifiModel.getCountryCode() })
          InfoView({ infoList: this.wifiModel.getFeatureSupport() })
        }
      }
      .layoutWeight(1)
    }
  }
}