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
import prompt from '@ohos.prompt'
import router from '@ohos.router'
import Logger from '../model/Logger'
import MediaUtils from '../model/MediaUtils'
import NextVideo from '../common/NextVideo'
import PlayButton from '../common/PlayButton'
import PlayTitle from '../common/PlayTitle'
import PreVideo from '../common/PreVideo'
import VideoPlayerUtils from '../model/VideoPlayerUtils'
import { getTimeString } from '../model/TimeUtils'

const TAG: string = 'Player'

@Entry
@Component
struct Player {
  private params = <{
    fileId: number,
    displayName: string
  }> router.getParams()
  private currentIndex: number = -1
  private fileAsset: mediaLibrary.FileAsset = undefined
  private fileId: number = this.params.fileId
  private fd: number = undefined
  private intervalId: number = undefined
  private mediaList: Array<mediaLibrary.FileAsset> = []
  private videoPlayer: VideoPlayerUtils = new VideoPlayerUtils()
  private mXComponentController: XComponentController = new XComponentController()
  private surfaceId: number = 0
  @State currentTime: number = 0
  @State displayName: string = this.params.displayName
  @State isShowMenu: boolean = false
  @State @Watch('playStateChange') isPlaying: boolean = false
  @State ratio: number = 1.0

  aboutToAppear() {
    this.surfaceId = this.mXComponentController.getXComponentSurfaceId()
    Logger.info(TAG, `aboutToAppear,surfaceId=${this.surfaceId}`)
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

  async getMediaList() {
    Logger.info(TAG, `aboutToAppear,id=${this.fileId}`)
    this.mediaList = await MediaUtils.getFileAssetsFromType(mediaLibrary.MediaType.VIDEO)
    this.mediaList.forEach((file, index) => {
      Logger.info(TAG, `file.id=${file.id}`)
      if (file.id === this.fileId) {
        this.fileAsset = file
        this.currentIndex = index
      }
    })
  }

  playStateChange() {
    if (this.isPlaying) {
      this.videoPlayer.play()
    } else {
      this.videoPlayer.pause()
    }
  }

  handleBack = () => {
    router.back()
    this.clearVideoPlayer()
  }
  handlePrevClick = () => {
    if (this.currentIndex > 0) {
      this.currentIndex -= 1
      this.resetVideo()
    } else {
      prompt.showToast({ message: '当前视频是第一个', duration: 1000 })
    }
  }
  handleNextClick = () => {
    if (this.currentIndex < this.mediaList.length - 1) {
      this.currentIndex += 1
      this.resetVideo()
    } else {
      prompt.showToast({ message: '当前视频是最后一个', duration: 1000 })
    }
  }

  async resetVideo() {
    await this.fileAsset.close(this.fd)
    this.fileAsset = this.mediaList[this.currentIndex]
    let fdPath = await this.prepareVideo()
    await this.videoPlayer.reset(fdPath)
    this.isPlaying = true
  }

  async prepareVideo() {
    this.ratio = this.fileAsset.width / this.fileAsset.height
    this.mXComponentController.setXComponentSurfaceSize({
      surfaceWidth: this.fileAsset.width,
      surfaceHeight: this.fileAsset.height
    })
    this.surfaceId = this.mXComponentController.getXComponentSurfaceId()
    this.fd = await this.fileAsset.open('Rw')
    return 'fd://' + this.fd
  }

  async playVideo() {
    Logger.info(TAG, 'playVideo')
    await this.getMediaList()
    let fdPath = await this.prepareVideo()
    await this.videoPlayer.initVideoPlayer(fdPath, this.surfaceId)
    this.isPlaying = true
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      if (this.isShowMenu) {
        Column() {
          PlayTitle({ title: this.displayName, handleBack: this.handleBack })
          Row() {
            PreVideo({ handleClick: this.handlePrevClick })
            PlayButton({ isPlaying: $isPlaying })
            NextVideo({ handleClick: this.handleNextClick })
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

  onPageHide() {
    router.back()
    this.clearVideoPlayer()
  }

  clearVideoPlayer() {
    clearInterval(this.intervalId)
    this.videoPlayer.stop()
    this.videoPlayer.release()
    this.fileAsset.close(this.fd)
  }
}