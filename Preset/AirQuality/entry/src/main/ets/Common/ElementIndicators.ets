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

import { AirQualityModel } from '../Model/AirQualityModel'

@Component
export struct ElementIndicators {
  @State airQualityModel: AirQualityModel  = undefined

  @Builder buildElement(name, data) {
    Row() {
      Text(name)
        .height(35)
        .fontSize(30)
        .textAlign(TextAlign.Start)
        .layoutWeight(1)
        .margin({ left: '20%' })

      Text(data)
        .height(35)
        .fontSize(30)
        .textAlign(TextAlign.End)
        .layoutWeight(1)
        .margin({ right: '75%' })
    }
    .margin({ top: 10 })
    .width('100%')
    .height(35)
  }

  build() {
    Column() {
      this.buildElement(this.airQualityModel.co.name, this.airQualityModel.co.data.toString())
      this.buildElement(this.airQualityModel.no2.name, this.airQualityModel.no2.data.toString())
      this.buildElement(this.airQualityModel.pm10.name, this.airQualityModel.pm10.data.toString())
      this.buildElement(this.airQualityModel.pm2p5.name, this.airQualityModel.pm2p5.data.toString())
      this.buildElement(this.airQualityModel.so2.name, this.airQualityModel.so2.data.toString())
    }
  }
}