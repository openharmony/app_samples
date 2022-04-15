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
struct DragEventSample {
  @State blockArr: string[] = []
  @State text: string = ''
  @State imgSrc:string[] = ['/common/focus04.jpg','/common/focus03.jpg','/common/focus02.jpg']
  @State bool: boolean = false
  @State bool1: boolean = false
  @State select: number = 0
  @State AVisible:Visibility = Visibility.Visible
  @State BVisible:Visibility = Visibility.Visible
  @State CVisible:Visibility = Visibility.Visible

  @Builder pixelMapBuilder() {
    Column() {
      Image('')
        .width(200)
        .height(100)
        .borderRadius(10)
        .backgroundColor(Color.Orange)
    }
  }

  build() {
    Column() {
      NavigationBar({ title: '拖拽事件' })
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
        Image(this.imgSrc[0])
          .width(200)
          .height(100)
          .backgroundColor(Color.Orange)
          .visibility(this.AVisible)
          .onDragStart(() => {
            this.bool = true
            this.AVisible = Visibility.Hidden
            return this.pixelMapBuilder
          })
        Image(this.imgSrc[1])
          .width(200)
          .height(100)
          .backgroundColor(Color.Orange)
          .visibility(this.BVisible)
          .onDragStart(() => {
            this.bool = true
            this.BVisible = Visibility.Hidden
            return this.pixelMapBuilder
          })
        Image(this.imgSrc[2])
          .width(200)
          .height(100)
          .backgroundColor(Color.Orange)
          .visibility(this.CVisible)
          .onDragStart(() => {
            this.bool = true
            this.CVisible = Visibility.Hidden
            return this.pixelMapBuilder
          })
      }
      .margin({ bottom: 20 })

      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.blockArr, (item, index) => {
          ListItem() {
            Image(this.imgSrc[index]+item)
              .width(200)
              .height(100)
          }
          .onDragStart((event: DragEvent, extraParams: string) => {
            console.log('ListItem onDragStarts, ' + extraParams)
            var jsonString = JSON.parse(extraParams)
            this.bool1 = true
            this.text = this.blockArr[jsonString.selectedIndex]
            this.select = jsonString.selectedIndex
            return this.pixelMapBuilder
          })
        }, item => item)
      }
      .width('100%')
      .height(420)
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .margin({ bottom: 24 })
      .backgroundColor('#FFFFFF')
      .editMode(true)
      .border({ width: 1 })
      .onDrop((event: DragEvent, extraParams: string) => {
        var jsonString = JSON.parse(extraParams)
        if (this.bool) {
          this.blockArr.splice(jsonString.insertIndex, 0, this.text)
          this.bool = false
        } else if (this.bool1) {
          this.blockArr.splice(jsonString.selectedIndex, 1)
          this.blockArr.splice(jsonString.insertIndex, 0, this.text)
          this.bool = false
          this.bool1 = false
        }
      })
    }
    .height('100%')
    .padding({ left: '3%', right: '3%' })
    .backgroundColor('#F1F3F5')
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


