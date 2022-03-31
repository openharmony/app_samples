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

@Component
export struct SmallAnimation {
  @Link mainFlag: boolean
  private point: Point = new Point(0, 0)
  @State item: Item = new Item(0, $r('app.media.money1'), false)

  build() {
    Image(this.item.image)
      .width('20%')
      .height('20%')
      .objectFit(ImageFit.Contain)
      .translate(this.mainFlag ? { x: this.point.x, y: this.point.y } : { x: 0, y: 0 })
      .rotate({ x: 0, y: 0, z: 1, angle: this.item.clicked ? 360 : 90 })
      .scale(this.item.clicked ? { x: 1.25, y: 1.25 } : { x: 1, y: 1 })
      .opacity(this.item.clicked ? 0.6 : 1)
      .onClick(() => {
        this.item.clicked = !this.item.clicked
      })
      .animation(
        {
          delay: 10,
          duration: 300,
          iterations: 1,
          curve: Curve.Smooth,
          playMode: PlayMode.Normal
        }
      )
  }
}