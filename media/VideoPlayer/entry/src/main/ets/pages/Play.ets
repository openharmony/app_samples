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
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import router from '@ohos.router'
import MediaUtils from '../model/MediaUtils'
import Logger from '../model/Logger'
import PlayButton from '../common/PlayButton'
import PlayTitle from '../common/PlayTitle'
import VideoPlayerUtils from '../model/VideoPlayerUtils'
import { getTimeString } from '../model/TimeUtils'

const TAG: string = 'Play'

@Entry
@Component
struct Play {
  private fileId: number = -1
  private fileAsset: mediaLibrary.FileAsset = undefined
  private fd: number = undefined
  private intervalId: number = undefined
  private mXComponentController: XComponentController = new XComponentController()
  private videoPlayer: VideoPlayerUtils = new VideoPlayerUtils()
  private surfaceId: number = 0
  @State currentTime: number = 0
  @State displayName: string = ''
  @State isShowMenu: boolean = false
  @State @Watch('playStateChange') isPlaying: boolean = false
  @State ratio: number = 1.0

  aboutToAppear() {
    let want = globalThis.abilityWant
    this.fileId = want.parameters.fileId
    Logger.info(TAG, `aboutToAppear, fileId =${this.fileId}`)
    this.surfaceId = this.mXComponentController.getXComponentSurfaceId()
    this.videoPlayer.setFinishCallBack(() => {
      this.isPlaying = false
      this.currentTime = 0
    })
    this.intervalId = setInterval(() => {
      if (this.isPlaying) {
        this.currentTime = this.videoPlayer.getCurrentTime()
      }
    }, 1000)
  }

  async playVideo() {
    Logger.info(TAG, 'playVideo')
    await globalThis.abilityContext.requestPermissionsFromUser(['ohos.permission.READ_MEDIA'])
    this.fileAsset = await MediaUtils.queryFile(this.fileId)
    this.displayName = this.fileAsset.displayName
    this.ratio = this.fileAsset.width / this.fileAsset.height
    this.mXComponentController.setXComponentSurfaceSize({
      surfaceWidth: this.fileAsset.width,
      surfaceHeight: this.fileAsset.height
    })
    this.surfaceId = this.mXComponentController.getXComponentSurfaceId()
    Logger.info(TAG, `onLoad,surfaceId =${this.surfaceId}`)
    this.fd = await this.fileAsset.open('Rw')
    let fdPath = 'fd://' + this.fd
    await this.videoPlayer.initVideoPlayer(fdPath, this.surfaceId)
    this.isPlaying = true
  }

  playStateChange() {
    if (this.isPlaying) {
      this.videoPlayer.play()
      Logger.info(TAG, 'play')
    } else {
      this.videoPlayer.pause()
      Logger.info(TAG, 'pause')
    }
  }

  handleBack = () => {
    router.back()
    this.clearVideoPlayer()
  }

  build() {
    Row() {
      Stack({ alignContent: Alignment.Center }) {
        if (this.isShowMenu) {
          Column() {
            PlayTitle({ title: this.displayName, handleBack: this.handleBack })
            Row() {
              PlayButton({ isPlaying: $isPlaying })
            }
            .margin({ top: '40%' })

            Blank()
            Row() {
              Text(getTimeString(this.currentTime))
                .fontSize(25)
                .fontColor(Color.White)
              Blank()
              Text(this.fileAsset ? getTimeString(this.fileAsset.duration) : '00:00')
                .fontSize(25)
                .fontColor(Color.White)
            }
            .width('95%')

            Slider({ value: this.fileAsset ? this.currentTime / this.fileAsset.duration * 100 : 0 })
              .width('92%')
              .selectedColor(Color.White)
              .onChange((value: number) => {
                Logger.info(TAG, 'seek time change')
                this.currentTime = this.fileAsset.duration * value / 100
                this.videoPlayer.seek(this.currentTime)
              })
          }
          .height('100%')
          .zIndex(2)
        }
        Row() {
          XComponent({
            id: 'componentId',
            type: 'surface',
            controller: this.mXComponentController
          })
            .onLoad(() => {
              Logger.info(TAG, 'onLoad is called')
              this.playVideo()
            })
            .width('100%')
            .aspectRatio(this.ratio)
        }
        .height('100%')
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
      .onClick(() => {
        this.isShowMenu = !this.isShowMenu
      })
    }
    .height('100%')
  }

  onPageHide() {
    this.isPlaying = false
    this.clearVideoPlayer()
  }

  clearVideoPlayer() {
    clearInterval(this.intervalId)
    this.videoPlayer.stop()
    this.videoPlayer.release()
    this.fileAsset.close(this.fd)
  }
}