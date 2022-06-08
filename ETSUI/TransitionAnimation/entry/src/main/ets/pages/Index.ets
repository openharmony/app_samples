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
import TitleBar from '../common/TitleBar'

@Entry
@Component
struct Index {
  @Builder
  ButtonItem(text: Resource | string, pageUrl: string) {
    Button({ type: ButtonType.Capsule }) {
      Text(text)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black)
        .width('90%')
        .textAlign(TextAlign.Center)
    }
    .width('80%')
    .layoutWeight(1)
    .margin('5%')
    .backgroundColor('#F0FFF0')
    .onClick(() => {
      router.push({ url: pageUrl })
    })
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar()
      this.ButtonItem($r('app.string.page_transition_bottom'), 'pages/page/BottomTransition')
      this.ButtonItem($r('app.string.page_transition_custom_first'), 'pages/page/CustomTransition')
      this.ButtonItem($r('app.string.page_transition_custom_second'), 'pages/page/CustomTransition2')
      this.ButtonItem($r('app.string.component_transition'), 'pages/ComponentTransition')
      this.ButtonItem($r('app.string.share_transition'), 'pages/share/ShareItem')
    }
    .width('100%')
    .height('100%')
    .padding({ bottom: 20 })
  }
}