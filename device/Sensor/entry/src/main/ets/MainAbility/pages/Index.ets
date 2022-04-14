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

const TAG = '[sensor]'

@Entry
@Component
struct Index {
  @State angle: number = 0
  @State calibration: number = 0
  @State angleTest: string = '0°'

  aboutToAppear() {
    sensor.on(sensor.SensorType.SENSOR_TYPE_ID_ORIENTATION, function(data){
      console.info(`${TAG} component: on`)
      console.info(`${TAG} X-coordinate component: ${data.beta}`)
      console.info(`${TAG} Y-coordinate component: ${data.gamma}`)
      console.info(`${TAG} Z-coordinate component: ${data.alpha}`)
      this.calibration = Math.round(data.alpha)
      this.angle = -(this.calibration - 135)
      if ((this.calibration - 90) < 0) {
        this.angleTest = (270 + this.calibration) + '°'
      } else {
        this.angleTest = (this.calibration - 90) + '°'
      }
    }.bind(this), { interval: 10000000 })
  }

  build() {
    Column() {
      Column() {
        Text('北')
          .fontSize(20)
          .margin({ left: '60%' })

        Image($r('app.media.compass'))
          .objectFit(ImageFit.Auto)
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            angle: this.angle
          })
          .size({ width: '40%', height: '70%' })
      }
      .width('100%')
      .margin({ top: '10%' })

      Text(this.angleTest)
        .fontSize(30)
    }
  }
}