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

let basicList = [
  { title: 'RenderingContext', url: 'pages/RenderingContext' },
  { title: 'RenderingContext1', url: 'pages/RenderingContext1' },
  { title: 'RenderingContext2', url: 'pages/RenderingContext2' },
  { title: 'TransformExample', url: 'pages/TransformExample' },
  { title: 'ShadowOffset', url: 'pages/ShadowOffsetExample' },
  { title: 'path2D', url: 'pages/PathExample' },
  { title: 'ImageBitmap', url: 'pages/BitmapExample' },
  { title: 'CanvasGradient', url: 'pages/GradientExample' }
]

@Entry
@Component
struct Index {
  private controller: TabsController = new TabsController()
  @State isShow: boolean = false
  @State subassemblyName: string = '' //组件名
  @State selectItem: string = '' //选择验证项
  build() {
    Column() {
      List({ space: 6, initialIndex: 0 }) {
        ForEach(basicList, (item) => {
          ListItem() {
            Text(item.title).fontSize(18)
          }.backgroundColor(Color.Orange)
          .width("100%")
          .height(50)
          .onClick(() => {
            router.push({
              url: item.url
            })
          })
        }, item => item.title)
      }
    }.width('100%')
    .height('100%')
    .padding({ left: '5%', right: '5%' })
    .justifyContent(FlexAlign.Center)
  }
}



