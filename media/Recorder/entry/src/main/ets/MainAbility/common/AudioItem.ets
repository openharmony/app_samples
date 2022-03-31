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
import { Record } from '../model/Record'

const TAG = '[Record.AudioItem]'

@Component
export struct AudioItem {
  private record: Record = null
  private index: number = -1
  private clickItem: (record: Record, operate: string) => void
  private checkItem: () => void
  @State translateLeft: number = 0
  @State translateRight: number = -120
  @State imgRes: Resource = $r('app.media.uncheck')
  @Link checkState: boolean
  @Link @Watch('leftSliderChange') leftSliderIndex: number

  leftSliderChange() {
    animateTo({ duration: 500, curve: Curve.Linear }, () => {
      if (this.index !== this.leftSliderIndex) {
        this.translateLeft = 0
        this.translateRight = -120
      } else {
        if (this.translateLeft < 0) {
          this.translateLeft = 0
          this.translateRight = -120
        } else {
          this.translateLeft = -120
          this.translateRight = 0
        }
      }
    })
  }

  aboutToAppear() {
    this.imgRes = this.record.isCheck ? $r('app.media.check') : $r('app.media.uncheck')
  }

  build() {
    Row() {
      Row() {
        Flex({ direction: FlexDirection.Column, alignContent: FlexAlign.Center, justifyContent: FlexAlign.Center }) {
          Text(this.record.fileName)
            .fontSize(22)
            .fontColor(Color.Black)
          Text(this.record.addDate)
            .fontSize(20)
            .fontColor(Color.Gray)
            .margin({ top: 10 })
        }
        .size({ width: '80%', height: '100%' })

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.End }) {
          Text(this.record.duration)
            .fontSize(20)
            .fontColor(Color.Gray)
          if (this.checkState) {
            Image(this.imgRes)
              .size({ width: 20, height: 20 })
              .objectFit(ImageFit.Contain)
              .margin({ left: 5 })
          } else {
            Image($r('app.media.ic_about'))
              .size({ width: 20, height: 20 })
              .objectFit(ImageFit.Contain)
              .margin({ left: 5 })
          }
        }
        .width('20%')
      }
      .layoutWeight(1)
      .padding({ top: 10, bottom: 10, left: 10, right: 10 })
      .margin({ left: 15, top: 15 })
      .backgroundColor('#FFFFFF')
      .borderRadius(20)

      Row() {
        Button() {
          Image($r("app.media.rename_svg"))
            .size({ width: 50, height: 50 })
            .objectFit(ImageFit.Contain)
        }
        .size({ width: 50, height: 50 })
        .type(ButtonType.Circle)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          console.info(`${TAG} rename click`)
          this.clickItem(this.record, 'rename')
          this.leftSliderIndex = -1
        })

        Button() {
          Image($r('app.media.delete_fill'))
            .objectFit(ImageFit.Contain)
            .size({ width: 30, height: 30 })
        }
        .type(ButtonType.Circle)
        .size({ width: 50, height: 50 })
        .backgroundColor('#FF0000')
        .margin({ left: 5 })
        .onClick(() => {
          console.info(`${TAG} delete click`)
          this.clickItem(this.record, 'delete')
          this.leftSliderIndex = -1
        })
      }
      .width(120)
      .padding({ right: 10 })
      .margin({ left: 15, right: 15 })
    }
    .height('15%')
    .constraintSize({ minHeight: 100 })
    .margin({ left: this.translateLeft, right: this.translateRight })
    .gesture(
    GestureGroup(GestureMode.Parallel,
    LongPressGesture({ repeat: true })
      .onAction(() => {
        if (!this.checkState && this.translateLeft === 0) {
          this.checkState = true
        }
      }),
    PanGesture({ fingers: 1, direction: PanDirection.Left, distance: 20 })
      .onActionEnd(() => {
        console.info(`${TAG} swipe left`)
        if (!this.checkState) {
          this.leftSliderIndex = this.index
        }
      }))
    )
    .onClick(() => {
      console.info(`${TAG} cilck,checkState=${this.checkState}, isSwipeLeft=${this.index == this.leftSliderIndex}`)
      if (this.checkState) {
        this.record.isCheck = !this.record.isCheck
        this.checkItem()
        return
      }
      if (this.index === this.leftSliderIndex) {
        this.leftSliderIndex = -1
        return
      }
      this.leftSliderIndex = -1
      this.clickItem(this.record, 'play')
    })
  }
}