/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import Prompt from '@system.prompt';
import {Good, addGood} from '../model/product'

@Component
export struct Goods {
  private good: Good
  @State background: Color = Color.White
  @Link cartNum: number

  build() {
    Column() {
      Image(this.good.img).height('55%').objectFit(ImageFit.ScaleDown)
      Column() {
        Text(this.good.name).fontSize(20).fontColor(Color.Blue)
        Text('￥' + this.good.price).fontSize(25).fontColor(Color.Red)
      }

      Row() {
        Image($r('app.media.buycart')).width(20).height(20)
        Text($r("app.string.insertCart")).fontSize(18).margin({ left: 3 })
      }.margin({ top: 3 })
      .backgroundColor(this.background)
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down) {
          this.background = Color.Gray
        }
        else if (event.type === TouchType.Up) {
          this.background = Color.White
        }
      })
      .onClick(() => {
        if (this.cartNum >= 5) {
          Prompt.showToast({ message: '购物车已满' })
        } else {
          this.cartNum++
          addGood(this.good)
        }
      })
    }
    .width('100%')
    .height(200)
    .borderRadius(10)
    .padding(10)
  }
}