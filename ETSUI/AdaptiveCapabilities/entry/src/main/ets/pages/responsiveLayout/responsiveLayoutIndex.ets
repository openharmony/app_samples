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
import router from '@ohos.router';

const responsiveLayout = [
  { title: '媒体查询', uri: "pages/responsiveLayout/mediaQuery/mediaQuery" },
  { title: '栅格布局', uri: "pages/responsiveLayout/gridContainer/gridContainer" },
  { title: '典型场景', uri: "pages/responsiveLayout/typicalScene/typicalSceneIndex" },
]

@Entry
@Component
struct ResponsiveLayout {
  private scroller: Scroller = new Scroller()

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text('响应式布局')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
      }.width('100%').height(100)

      Scroll(this.scroller) {
        Column() {
          List({ space: 5, initialIndex: 1 }) {
            ForEach(responsiveLayout, (item) => {
              ListItem() {
                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }) {
                  Text(item.title).fontSize(20).padding({ left: 20 })
                }
              }
              .backgroundColor('#66CCFF')
              .width('100%')
              .height(80)
              .borderRadius(10)
              .onClick(() => {
                router.push({
                  url: item.uri
                })
              })
            }, item => item.title)
          }
          .listDirection(Axis.Vertical)
          .divider({ strokeWidth: 1, color: Color.White, startMargin: 10 })
          .width('98%')
        }
        .width('100%')
      }
      .padding(10)
      .scrollBar(BarState.Off)
    }.width('100%').height('100%')
  }
}