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

const HomeContents = [
  { title: '基础组件', url: 'pages/component_basis/index' },
  { title: '容器组件', url: 'pages/component_container/index' }
]


@Entry
@Component
struct HomePage {
  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center
    }) {
      List() {
        ForEach(HomeContents, (item) => {
          ListItem() {
            Row() {
              Text(item.title)
                .fontSize(16)
                .padding({ left: 10 })

            }
            .padding({ left: 10 })
            .width('100%')
            .height(55)
            .alignItems(VerticalAlign.Center)
            .backgroundColor(0xfff5deb3)
            .margin({ top: 5, bottom: 5, left: 10 })
            .borderRadius(12)
            .onClick(() => {
              router.push({
                url: item.url
              })
            })
          }
        }, item => item.title)
      }
      .width('100%')
    }
  }
}




