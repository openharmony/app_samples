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
import mediaQuery from '@ohos.mediaquery';

@Entry
@Component
export struct FullPage {
  @State fullParams: object = {}
  @State fullSrc: Resource = $rawfile('video_1.mp4')
  @State isHidden: boolean = false
  @State maxValue: number = 0 // 底部时间条的总时长
  @State nowValue: number = 0 // 底部时间条的当前秒数
  @State playTime: number = 0 // 上个页面传过来的播放时间
  @State isPhone: boolean = false
  portraitFunc = null
  listenerIsPhone = mediaQuery.matchMediaSync('(orientation:landscape)');
  fullVideoController: VideoController = new VideoController()

  onPortrait(mediaQueryResult) {
    this.isPhone = !mediaQueryResult.matches
  }

  aboutToAppear() {
    this.fullParams = router.getParams()
    this.fullSrc = this.fullParams['videoSrc']
    this.playTime = this.fullParams['videoTime']

    this.portraitFunc = this.onPortrait.bind(this) // bind current js instance
    this.listenerIsPhone.on('change', this.portraitFunc)
  }

  changTime(times: any) {
    if (times <= 0) {
      return '00:00';
    } else {
      let mm = Math.floor(times / 60);
      let ss = Math.floor(times % 60);
      return (mm < 10 ? '0' + mm : mm) + ':' + (ss < 10 ? '0' + ss : ss);
    }
  }

  build() {
    Scroll() {
      Column() {
        Stack() {
          Video({
            src: this.fullSrc,
            controller: this.fullVideoController
          })
            .width('100%')
            .height('100%')
            .autoPlay(true)
            .loop(true)
            .controls(false)
            .objectFit(ImageFit.Contain)
            .onPause(() => {
              this.isHidden = true
            })
            .onFullscreenChange((e) => {
              this.isHidden = false
            })
            .onStart(() => {
              this.isHidden = false
              this.fullVideoController.setCurrentTime(this.playTime)
            })
            .onPrepared((e) => {
              console.info('FullPage_onPrepared:' + e.duration)
              this.maxValue = e.duration
            })
            .onUpdate((e) => {
              this.nowValue = e.time
            })
            .onClick(() => {
              this.fullVideoController.pause();
            })

          // 暂停按钮
          Column() {
            Image($r('app.media.play'))
              .width(78).height(78)
              .onClick(() => {
                this.fullVideoController.start()
                this.isHidden = !this.isHidden
              })
          }
          .position({ x: this.isPhone ? '42%' : '47%', y: '45%' })
          .visibility(this.isHidden ? Visibility.Visible : Visibility.Hidden)
        }.width('100%').height('100%')

        // 返回上一页按钮
        Column() {
          Image($r('app.media.back'))
            .width(42).height(42)
            .onClick(() => {
              router.back()
            })
        }
        .position({ x: '5%', y: '5%' })

        // 分享按钮
        Column() {
          Image($r('app.media.share'))
            .width(42).height(42)
        }
        .position({ x: this.isPhone ? '86%' : '95%', y: '5%' })

        // 底部时间条
        Row() {
          Text(this.changTime(this.nowValue.toFixed(0))).fontSize(18).fontColor(Color.White)
          Slider({
            value: this.nowValue,
            min: 0,
            max: this.maxValue,
            style: SliderStyle.OutSet
          })
            .width('75%')
            .blockColor(Color.White)
            .trackColor('#cccccc')
            .selectedColor('#E92F4F')
            .showSteps(false)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.nowValue = value
              this.fullVideoController.setCurrentTime(value)
              console.info('value:' + value + 'mode:' + mode.toString())
            })
          Text(this.changTime(this.maxValue.toFixed(0))).fontSize(18).fontColor(Color.White)
        }
        .padding({ top: 50 })
        .width('100%')
        .position({ x: this.isPhone ? '3%' : '10%', y: '88%' })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#000000')
    }
  }
}