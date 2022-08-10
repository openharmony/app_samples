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

@Component
export struct smallVideo {
  @State smallVideoSrc: Resource = $rawfile('video_4.mp4')
  @Link @Watch("onChanged") isHidden: boolean
  @Link isCancel: boolean
  @Consume('playTime') updateTime: number
  smallVideoController: VideoController = new VideoController()

  onChanged(): void {
    if (this.isHidden) {
      this.smallVideoController.setCurrentTime(this.updateTime)
    }
  }

  aboutToAppear() {
    this.smallVideoController.setCurrentTime(this.updateTime)
  }

  build() {
    Column() {
      Stack() {
        Video({
          src: this.smallVideoSrc,
          controller: this.smallVideoController
        })
          .controls(false)
          .autoPlay(true)
          .muted(true)
          .onFinish(() => {
            this.isHidden = false
          })

        // 视频小窗口的右上角X
        Image($r('app.media.s_videoclose'))
          .width(16)
          .height(16)
          .position({ x: '80%', y: '10%' })
          .onClick(() => {
            this.isHidden = false
            this.isCancel = false
          })
      }
    }
    .backgroundColor('#000000')
    .width(160)
    .height(96)
    .margin({ right: '2%' })
    .visibility(this.isHidden ? Visibility.Visible : Visibility.Hidden)
  }
}
