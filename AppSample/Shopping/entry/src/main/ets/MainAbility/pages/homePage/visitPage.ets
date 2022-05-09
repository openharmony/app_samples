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

import { FindPage } from './find'

@Component
export struct VisitPage {
  controller: TabsController = new TabsController()
  @State bgColor: string = '#dfe5e3'
  @State width: number = 400
  @Prop ratio: number

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        Image('/resources/icon/camera.png')
          .width(30 * this.ratio)
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
        Text('关注')
          .fontSize(15 * this.ratio)
        Text('发现')
          .fontSize(15 * this.ratio)
        Image('/resources/homeImg/tabIcon/user.png')
          .width(30 * this.ratio)
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
          .border({ radius: 15 * this.ratio })
      }
      .padding({ top: 10 })
      .backgroundColor(this.bgColor)

      Tabs({ controller: this.controller, index: 1 }) {
        TabContent() {

        }

        TabContent() {
          FindPage({ bgColor: $bgColor, ratio: $ratio })
        }
      }
      .barWidth(0)
      .barHeight(0)
      .backgroundColor(this.bgColor)
      .scrollable(false)
    }
    .backgroundColor('#dfe5e3')
    .margin({ bottom: 35 })
  }
}