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

import sensor from '@ohos.sensor'
import geolocation from '@ohos.geolocation'
import Logger from '../model/Logger'

const TAG: string = '[Geolocation]'

@Component
export struct Geolocation {
  @State angle: number = 0
  @State latitude: number = 0
  @State longitude: number = 0
  @State flag: boolean = false
  @State cityInfo: Resource = undefined

  @Builder info(text: Resource, value: number) {
    Row() {
      Text(text)
        .margin(10)
        .fontSize(20)

      Text(`${value}`)
        .margin(10)
        .fontSize(20)
    }
    .visibility(this.flag ? Visibility.Visible : Visibility.Hidden)
    .margin(10)
  }

  aboutToAppear() {
    sensor.on(sensor.SensorType.SENSOR_TYPE_ID_ORIENTATION, function(data){
      this.calibration = Math.round(data.alpha)
      this.angle = -(this.calibration - 135)
    }.bind(this), { interval: 10000000 })
  }

  getLocation() {
    let locationChange = (location) => {
      this.cityInfo = $r('app.string.location')
      this.latitude = location.latitude
      this.longitude = location.longitude
    }
    let requestInfo: geolocation.LocationRequest = {
      priority: 0x203,
      scenario: 0x300,
      timeInterval: 0,
      distanceInterval: 100,
      maxAccuracy: 100
    }
    geolocation.on('locationChange', requestInfo, locationChange)
  }

  async requestLocation() {
    let locationService = await geolocation.isLocationEnabled()
    Logger.info(TAG, `locationService is ${locationService}`)
    if (locationService === true) {
      this.getLocation()
    } else {
      let requestLocationService = await geolocation.requestEnableLocation()
      Logger.info(TAG, `requestLocationService is ${requestLocationService}`)
      if (requestLocationService === true) {
        this.getLocation()
      } else {
        this.cityInfo = $r('app.string.request')
      }
    }
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Image($r('app.media.compass'))
          .objectFit(ImageFit.Contain)
          .width('80%')
          .height('65%')
          .margin(10)
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            angle: this.angle
          })
      }
      .width('100%')
      .height('50%')
      .margin(10)

      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Button($r('app.string.start'))
          .margin(10)
          .fontSize(20)
          .onClick(async () => {
            this.flag = true
            await this.requestLocation()
            console.log('on')
          })

        Button($r('app.string.stop'))
          .margin(10)
          .fontSize(20)
          .onClick(() => {
            this.flag = false
            this.cityInfo = undefined
            geolocation.off('locationChange')
          })
      }
      .width('100%')
      .margin(10)

      Text(this.cityInfo)
        .margin(10)
        .fontSize(18)
        .visibility(this.flag ? Visibility.Visible : Visibility.None)

      this.info($r('app.string.latitude'), this.latitude)
      this.info($r('app.string.longitude'), this.longitude)
    }
    .width('100%')
    .height('100%')
  }
}