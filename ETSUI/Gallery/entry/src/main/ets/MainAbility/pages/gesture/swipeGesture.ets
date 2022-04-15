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

@Entry
@Component
struct SwipeGestureSample {
  @State speed: number = 0
  @State mass: number = 2 //质量
  @State friction: number = 0.3 //摩擦系数
  @State Acceleration: number = 0 //加速度
  @State iVelocity: number = 0 //初速度
  @State distances: number = 360
  @State rotateAngle: number = 0
  @State Displacement: number = 360  //距离x
  @State time: number = 0

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Column() {
        Stack() {
          Image('/common/test3.png')
            .width('100%').height('100%')
          Image('/common/test5.jpg')
            .clip(new Rect({ width: this.Displacement, height: '100%' }))
            .width('100%')
            .height('100%')
            .gesture(
            SwipeGesture({ fingers: 1, direction: SwipeDirection.Horizontal })
              .onAction((event: GestureEvent) => {
                this.speed = event.speed
                this.rotateAngle = event.angle
                this.Acceleration = this.friction * 10
                this.distances = (this.speed ^ 2 - this.iVelocity ^ 2) / this.Acceleration * 2
                this.time = this.distances / this.speed * 600
                animateTo(
                  {
                    duration: 200,
                    delay: 400,
                    curve: Curve.EaseInOut,
                    tempo: 0.5,
                    iterations: 1,
                    playMode: PlayMode.Normal
                  }
                  , () => {
                  if (this.rotateAngle < 0) {
                    this.Displacement = this.distances
                  } else {
                    if (this.distances > 360) {
                      this.Displacement = 0
                    } else {
                      this.Displacement = this.distances
                    }
                  }
                })
                //        let t = 100 / this.speed * (200)
                //        animateTo({duration: t}, () => {
                //          if ()
                //          this.distances = '100%'
                //        })
              })
            )
        }
        .width(720)
        .height('40%')

        Text(`${this.Displacement}`).fontSize(20)
        Text(`${this.rotateAngle}`).fontSize(20)
        Text(`${this.speed}`).fontSize(20)
      }
    }
  }
}