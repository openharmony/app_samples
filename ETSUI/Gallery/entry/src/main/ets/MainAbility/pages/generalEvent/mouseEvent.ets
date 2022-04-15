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

import { NavigationBar } from "../../common/components/navigationBar"
import prompt from '@system.prompt';

@Entry
@Component
struct MouseEventSample {
  @State visible: Visibility = Visibility.Hidden
  @State rowBackgroundColor: Color = Color.Grey
  private data: any[] = [
    {
      url: '/common/ic_public_help.png',
      content: '点此查找更多帮助'
    },
    {
      url: 'common/ic_public_comments.png',
      content: '评论'
    },
    {
      url: '/common/ic_public_fail.png',
      content: '举报'
    },
    {
      url: '/common/ic_public_backtotop.png',
      content: '回到顶部'
    }]

  build() {
    Column() {
      NavigationBar({ title: '鼠标事件' })
      Column({ space: 5 }) {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
          ForEach(this.data, (item, index) => {
            Rows({ data: item })
          })
        }
        .width('100%')
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })
      .backgroundColor('#F2D2C3')
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%' })

  }

  pageTransition() {
    PageTransitionEnter({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)

    PageTransitionExit({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)
  }
}

@Component
struct Rows {
  @State visible: Visibility = Visibility.Hidden
  @State rowBackgroundColor: string = '#FFFFFF'
  private data: {
    url: string,
    content: string
  }

  build() {
    Row() {
      Row() {
        Image(this.data.url)
      }
      .width(80)
      .height(80)
      .borderRadius(10)
      .margin({ top: 40, bottom: 20 })
      .backgroundColor(this.rowBackgroundColor)
      .onHover((isHover: boolean) => {
        if (isHover) {
          this.visible = Visibility.Visible
        } else {
          this.visible = Visibility.Hidden
        }
      })

      Text(this.data.content)
        .width(120)
        .height(50)
        .textAlign(TextAlign.Center)
        .border({ width: 1, color: Color.Grey, style: BorderStyle.Solid, radius: 10 })
        .backgroundColor('#4D4D4D')
        .opacity(0.95)
        .fontColor('#FFFFFF')
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .position({ x: -20, y: 130 })
        .visibility(this.visible)
      Polyline({ width: 20, height: 20 }).points([[10, 0], [0, 10], [20, 10]])
        .position({ x: 30, y: 121 })
        .visibility(this.visible)
    }
  }
}