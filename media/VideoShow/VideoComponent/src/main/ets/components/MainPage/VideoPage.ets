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

@Component
export struct VideoPage {
  @State videoSrc: Resource = $rawfile('video_4.mp4')
  @State controls: boolean = false
  @State isFull: boolean = false
  @State isPause: boolean = true
  @State isPlayClick: boolean = true
  @State firstClick: boolean = true
  @State isHidden: boolean = true
  @Link isStart: boolean
  @Consume('playTime') updateTime: number
  detailVideoController: VideoController = new VideoController()

  build() {
    Column() {
      Stack() {
        Video({
          src: this.videoSrc,
          controller: this.detailVideoController,
        })
          .width('100%')
          .backgroundColor(this.isHidden ? '#ffffff' : '#000000')
          .aspectRatio(1.12)
          .controls(this.controls)
          .objectFit(ImageFit.Contain)
          .onUpdate((e) => {
            this.updateTime = e.time
          })
          .onPrepared((e) => {
            console.info('VideoPage_onPrepared:' + e.duration)
          })
          .onClick(() => {
            if (this.isPlayClick) { // 判断play按钮是否用过，没有用过，进入这层
              if (this.firstClick) { // 第一次点击视频开始播放，再次点击进入全屏
                this.detailVideoController.start()
                this.isHidden = !this.isHidden
                this.isStart = true
                this.firstClick = !this.firstClick
              } else {
                router.push({ url: 'pages/FullPage', params: { videoSrc: this.videoSrc, videoTime: this.updateTime } })
              }
            } else {
              router.push({ url: 'pages/FullPage', params: { videoSrc: this.videoSrc, videoTime: this.updateTime } })
            }
          })
          .onFinish(() => {
            this.isHidden = true
          })

        // 空白层预览
        Column() {
          Image($r('app.media.previewImg'))
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
        .aspectRatio(1.12)
        .backgroundColor('#ffffff')
        .visibility(this.isHidden ? Visibility.Visible : Visibility.Hidden)

        // 视频上的play图标
        Column() {
          Image($r('app.media.play'))
            .width(76).height(76)
            .onClick(() => {
              this.detailVideoController.start()
              this.isHidden = !this.isHidden
              this.isStart = true
              this.isPlayClick = false
            })
        }
        .visibility(this.isHidden ? Visibility.Visible : Visibility.Hidden)
      }
      .width('100%')
      .height('100%')
    }
  }
}