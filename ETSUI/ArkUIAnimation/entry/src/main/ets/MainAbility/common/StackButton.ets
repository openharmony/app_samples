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

import { Item } from '../model/Item'
import { Point, AxisModel } from '../model/AxisModel'
import { SmallAnimation } from '../common/SmallAnimation'

const IMAGE_RESOURCE: Resource[] = [
  $r('app.media.money1'),
  $r('app.media.money2'),
  $r('app.media.money3'),
  $r('app.media.money4'),
  $r('app.media.money5'),
  $r('app.media.money6'),
  $r('app.media.money7'),
  $r('app.media.money8')
]

@Component
export struct StackButton {
  @State mainFlag: boolean = false
  @State imagerArr: Array<Item> = []
  @State @Watch('onQuantityChange') quantity: number = 3
  private axis: AxisModel = new AxisModel(175, this.quantity)

  onQuantityChange() {
    this.imagerArr = []
    for (let i = 0; i < this.quantity; i++) {
      this.imagerArr.push(new Item(i, IMAGE_RESOURCE[i], false))
    }
    this.axis = new AxisModel(175, this.quantity)
  }

  aboutToAppear() {
    this.onQuantityChange()
  }

  add() {
    if (this.quantity >= 3 && this.quantity < 8) {
      this.quantity += 1
    } else if (this.quantity >= 8) {
      this.quantity = 8
    }
  }

  reduce() {
    if (this.quantity > 3 && this.quantity <= 8) {
      this.quantity -= 1
    } else if (this.quantity <= 3) {
      this.quantity = 3
    }
  }

  reset() {
    for (let i = 0; i < this.quantity; i++) {
      if (this.imagerArr[i].clicked) {
        this.imagerArr[i].clicked = false
      }
    }
  }

  animate() {
    animateTo(
      {
        delay: 10,
        tempo: 0.68,
        iterations: 1,
        duration: 500,
        curve: Curve.Smooth,
        playMode: PlayMode.Normal
      }, () => {
      this.mainFlag = !this.mainFlag
    })
  }

  build() {
    Column() {
      Stack() {
        ForEach(this.imagerArr, (item: Item, index: number) => {
          SmallAnimation({ item: item, point: this.axis.points[item.index], mainFlag: $mainFlag })
        }, item => JSON.stringify(item))

        Image(this.mainFlag ? $r('app.media.image1') : $r('app.media.image2'))
          .width('35%')
          .height('35%')
          .objectFit(ImageFit.Contain)
          .scale({ x: this.mainFlag ? 0.75 : 1, y: this.mainFlag ? 0.75 : 1 })
          .onClick(() => {
            this.reset()
            this.animate()
          })
      }
      .rotate({ x: 0, y: 0, z: 1, angle: this.mainFlag ? 360 : 90 })
      .width('100%')
      .height('80%')
      .layoutWeight(1)
      .margin({ top: '8%' })

      Row() {
        Image($r('app.media.add'))
          .objectFit(ImageFit.Contain)
          .width('20%')
          .height('95%')
          .margin({ top: 5, right: '10%' })
          .onClick(() => {
            this.add()
          })
        Image($r('app.media.reduce'))
          .objectFit(ImageFit.Contain)
          .width('20%')
          .height('95%')
          .margin({ top: 5, left: '10%' })
          .onClick(() => {
            this.reduce()
          })
      }
      .height('10%')
    }
  }
}