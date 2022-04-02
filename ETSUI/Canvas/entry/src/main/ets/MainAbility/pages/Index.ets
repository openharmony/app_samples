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

import router from '@system.router';

let basicList = [
  { title: 'RenderingContext', uri: 'pages/RenderingContext' },
  { title: 'RenderingContext1', uri: 'pages/RenderingContext1' },
  { title: 'RenderingContext2', uri: 'pages/RenderingContext2' },
  { title: 'TransformExample', uri: 'pages/TransformExample' },
  { title: 'ShadowOffset', uri: 'pages/ShadowOffsetExample' },
  { title: 'path2D', uri: 'pages/PathExample' },
  { title: 'ImageBitmap', uri: 'pages/BitmapExample' },
  { title: 'CanvasGradient', uri: 'pages/GradientExample' }
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
              uri: item.uri
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



