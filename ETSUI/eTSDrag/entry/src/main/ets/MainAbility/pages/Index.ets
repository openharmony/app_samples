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

import  HiLog  from '../model/HiLogUtil.ets'
import { Icon, iconInit } from '../model/IconData.ets'

const TAG = '[Index]'

@Extend(Image) function preferFancy (imageFit: ImageFit, padding: Padding) {
  .width(70)
  .height(70)
  .objectFit(imageFit)
  .padding(padding)
}

@Entry
@Component
struct Index {
  @State desktopDragging: boolean = false
  @State dockDragging: boolean = false
  @State select: number = 0
  @State insert: number = 0
  @State desktopIcons: Array<Icon> = iconInit().slice(4);
  @State dockIcons: Array<Icon> = iconInit().slice(0, 4);
  @State movingIcon: Icon = { icon: $r('app.media.icon'), name: '' }
  @State hanlePopup: boolean[] = [false, false, false, false]

  onDesktopIconDragStart(extraParams: string) {
    HiLog.info(TAG, `bool-onStart:extraParams = ${JSON.stringify(extraParams)}`)
    let jsonString = JSON.parse(extraParams)
    this.desktopDragging = true
    this.select = jsonString.selectedIndex
    this.movingIcon = this.desktopIcons[this.select]
    return this.pixelMapBuilder()
  }

  onDesktopIconDragDrop(extraParams: string) {
    HiLog.info(TAG, `bool-onDrop:extraParams = ${JSON.stringify(extraParams)}`)
    let jsonString = JSON.parse(extraParams)
    this.insert = jsonString.insertIndex
    if (this.desktopDragging) {
      this.desktopIcons.splice(this.select, 1)
      this.desktopIcons.splice(this.insert, 0, this.movingIcon)
      this.dockDragging = false
      this.desktopDragging = false
    }
  }

  onDockIconDragStart(extraParams: string) {
    HiLog.info(TAG, `boolBottom-onStart:extraParams = ${JSON.stringify(extraParams)}`)
    let jsonString = JSON.parse(extraParams)
    this.dockDragging = true
    this.select = jsonString.selectedIndex
    this.movingIcon = this.dockIcons[this.select]
    return this.pixelMapBuilder()
  }

  onDockIconDragDrop(extraParams: string) {
    HiLog.info(TAG, `boolBottom-onDrop:extraParams = ${JSON.stringify(extraParams)}`)
    let jsonString = JSON.parse(extraParams)
    this.insert = jsonString.insertIndex
    if (this.dockDragging) {
      this.dockIcons.splice(this.select, 1)
      this.dockIcons.splice(this.insert, 0, this.movingIcon)
      this.dockDragging = false
      this.desktopDragging = false
    }
    if (this.desktopDragging) {
      this.desktopIcons.splice(this.select, 1)
      this.dockIcons.splice(this.insert, 0, this.movingIcon)
      this.desktopDragging = false
      this.dockDragging = false
    }
  }

  @Builder pixelMapBuilder() {
    Column() {
      Text(this.movingIcon.name)
        .width('50%')
        .height(60)
        .fontSize(16)
        .borderRadius(10)
        .textAlign(TextAlign.Center)
        .backgroundColor(Color.Yellow)
    }
  }

  build() {
    Column() {
      Text($r('app.string.mouseDrag'))
        .width('100%')
        .height(50)
        .padding(10)
        .fontSize(25)
        .fontColor(Color.White)
        .backgroundColor('#0D9FFB')
        .fontWeight(FontWeight.Bold)

      List() {
        ForEach(this.desktopIcons, item => {
          ListItem() {
            Column() {
              Image(item.icon).layoutWeight(1).preferFancy(ImageFit.Fill, 0)
              Text(item.name).fontSize(15).height(30).fontWeight(FontWeight.Bold)
            }
            .height(100)
            .margin(5)
            .width('20%')
          }
          .onDragStart((event: DragEvent, extraParams: string) => {
            this.onDesktopIconDragStart(extraParams)
          })
        }, item => item.name)
      }
      .width('90%')
      .layoutWeight(1)
      .borderRadius(30)
      .align(Alignment.Start)
      .listDirection(Axis.Horizontal)
      .margin({ left: 10, right: 10 })
      .onDrop((event: DragEvent, extraParams: string) => {
        this.onDesktopIconDragDrop(extraParams)
      })

      List() {
        ForEach(this.dockIcons, (item, index) => {
          ListItem() {
            Image(item.icon)
              .margin({ left: '10%', right: '10%' })
              .preferFancy(ImageFit.ScaleDown, 2)
              .height('100%')
              .bindMenu([
                {
                  value: $r('app.string.remove'),
                  action: () => {
                    this.dockIcons.splice(index, 1)
                    this.desktopIcons.push(item)
                    let list = this.desktopIcons
                    this.desktopIcons = []
                    this.desktopIcons = list
                  }
                }
              ])
          }

          .onDragStart((event: DragEvent, extraParams: string) => {
            this.onDockIconDragStart(extraParams)
          })
        }, item => JSON.stringify(item))
      }
      .width('90%')
      .height(90)
      .borderRadius(30)
      .backgroundColor('#f8dddd')
      .listDirection(Axis.Horizontal)
      .margin({ bottom: 10, left: 10, right: 10 })
      .onDrop((event: DragEvent, extraParams: string) => {
        this.onDockIconDragDrop(extraParams)
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#e5e5e5')
  }
}