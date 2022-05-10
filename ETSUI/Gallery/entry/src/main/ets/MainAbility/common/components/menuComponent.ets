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

//  使用示例：基础组件marquee组件
import router from '@ohos.router';
import { GetColor } from './getColor'

@Component
export struct MenuComponent {
  title: string
  @Link items: any
  @Link transferParameters: any
  @State arrMenu: any = []

  private aboutToAppear() {
    for (let i = 0;i < this.transferParameters.length; i++) {
      this.arrMenu.push(
        {
          value: `${this.transferParameters[i]}`,
          action: () => {
            this.items = this.transferParameters[i]
            console.log(this.transferParameters[i])
          }
        }
      )
    }
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Text(this.title)
        .fontColor('#182431')
        .fontSize('16fp')
        .fontWeight(FontWeight.Medium)
        .opacity(0.5)
      Column() {
        Text(`${this.items}`)
          .fontColor('#182431')
          .fontSize('16fp')
          .fontWeight(FontWeight.Medium)
          .width('50%')
          .textAlign(TextAlign.End)
      }
      .bindMenu(this.arrMenu)
    }
    .width('100%')
    .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
    .borderRadius(24)
    .backgroundColor('#FFFFFF')
    .margin({ top: 8 })
  }
}