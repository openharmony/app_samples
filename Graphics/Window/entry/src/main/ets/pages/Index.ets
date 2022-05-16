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

@Entry
@Component
struct Index {
  @State isPlaying: boolean = false
  videoController: VideoController = new VideoController()

  build() {
    Column() {
      Row() {
        Text($r('app.string.entry_MainAbility'))
          .fontSize(20)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
      }
      .height('6%')
      .width('100%')
      .padding({ left: 15 })
      .backgroundColor('#0D9FFB')
      .constraintSize({ minHeight: 50 })

      Video({
        src: $r('app.media.movie'),
        currentProgressRate: PlaybackSpeed.Speed_Forward_1_00_X,
        controller: this.videoController
      })
        .width('95%')
        .height('90%')
        .margin(5)
        .loop(false)
        .muted(false)
        .autoPlay(false)
        .controls(true)
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          if (this.isPlaying) {
            this.videoController.pause()
          } else {
            this.videoController.start()
          }
        })
        .onStart(() => {
          this.isPlaying = true
        })
        .onPause(() => {
          this.isPlaying = false
        })
    }
    .width('100%')
    .height('100%')
  }
}