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

const atomicLayoutCapability = [
  { title: '拉伸能力1', uri: "pages/atomicLayoutCapability/flexibleCapability/flexibleCapability1" },
  { title: '拉伸能力2', uri: "pages/atomicLayoutCapability/flexibleCapability/flexibleCapability2" },
  { title: '缩放能力', uri: "pages/atomicLayoutCapability/scaleCapability/scaleCapability" },
  { title: '隐藏能力', uri: "pages/atomicLayoutCapability/hiddenCapability/hiddenCapability" },
  { title: '折行能力', uri: "pages/atomicLayoutCapability/wrapCapability/wrapCapability" },
  { title: '均分能力', uri: "pages/atomicLayoutCapability/equipartitionCapability/equipartitionCapability" },
  { title: '占比能力', uri: "pages/atomicLayoutCapability/proportionCapability/proportionCapability" },
  { title: '延伸能力1', uri: "pages/atomicLayoutCapability/extensionCapability/extensionCapability1" },
  { title: '延伸能力2', uri: "pages/atomicLayoutCapability/extensionCapability/extensionCapability2" },
]

@Entry
@Component
struct AtomicLayoutCapabilityIndex {
  private scroller: Scroller = new Scroller()

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text('原子布局能力')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
      }.width('100%').height(100)

      Scroll(this.scroller) {
        Column() {
          List({ space: 5, initialIndex: 1 }) {
            ForEach(atomicLayoutCapability, (item) => {
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