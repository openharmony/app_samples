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

@Entry
@Component
struct FullImagePage {
  private imageItem: Resource = router.getParams()['data1'] as Resource
  @State private leftMargin: number = 0
  @State private leftNum: number = 0
  @State private changeDistance: number = 0
  @State private size: number = 0
  @State private startDistance: number = 0
  @State private endDistance: number = 0
  private origSize: number = 300
  private start1x: number = 0
  private start1y: number = 0
  private start2x: number = 0
  private start2y: number = 0
  private end1x: number = 0
  private end1y: number = 0
  private end2x: number = 0
  private end2y: number = 0
  @State private startPos: number = 0
  private endPos: number = 0

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Image(this.imageItem)
        .onClick(() => {
          router.back()
        })
        .animation({ duration: 0 })
        .width(this.origSize + this.changeDistance)
        .objectFit(ImageFit.Contain)
        .margin({ left: this.leftMargin })
        .onTouch((event: TouchEvent) => {
          if (event.touches.length == 2) { // two touch point
            this.leftMargin = 0
            if (event.type == TouchType.Down) {
              this.changeDistance = this.size - this.origSize
              // touch position
              this.start1x = event.touches[0].x
              this.start1y = event.touches[0].y
              this.start2x = event.touches[1].x
              this.start2y = event.touches[1].y
              // start distance
              this.startDistance = calcDistance(this.start1x, this.start2x, this.start1y, this.start2y)
            } else if (event.type == TouchType.Move) {
              // move position
              this.end1x = event.touches[0].x
              this.end1y = event.touches[0].y
              this.end2x = event.touches[1].x
              this.end2y = event.touches[1].y
              // end distance
              this.endDistance = calcDistance(this.end1x, this.end2x, this.end1y, this.end2y)
            } else if (event.type == TouchType.Up) {
              // record changed distance
              this.size = this.changeDistance
            }
            this.changeDistance = (this.endDistance - this.startDistance) + this.size
            this.changeDistance = Math.max(Math.min(this.changeDistance, 200), -150)
          } else if (event.touches.length == 1) { // one touch point
            if (event.type == TouchType.Down) {
              this.startPos = event.touches[0].x
            } else if (event.type == TouchType.Move) {
              this.endPos = event.touches[0].x
              // only scale up pic can be moved
              if (this.changeDistance > 0) {
                this.leftMargin = this.leftNum + (this.endPos - this.startPos) / 2
                this.leftMargin = Math.max(Math.min(this.leftMargin, 200), -100)
              }
            } else if (event.type == TouchType.Up) {
              this.leftNum = this.leftMargin
            }
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}

function calcDistance(x1, y1, x2, y2): number {
  return Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2))
}