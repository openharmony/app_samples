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
import display from '@ohos.display'
import hardware_deviceManager from '@ohos.distributedHardware.deviceManager'
import KvStoreModel from '../model/KvStoreModel'
import Logger from '../model/Logger'
import mediaQuery from '@ohos.mediaquery'
import PlayerModel from '../model/PlayerModel'
import { RemoteDeviceModel } from '../model/RemoteDeviceModel'
import { DeviceDialog } from '../common/DeviceDialog'

const TAG: string = 'Index'
const DESIGN_WIDTH: number = 720.0
const SYSTEM_UI_HEIGHT: number = 134
const DESIGN_RATIO: number = 16 / 9
const ONE_HUNDRED: number = 100
const ONE_THOUSAND: number = 1000
const SIXTY: number = 60
const REMOTE_ABILITY_STARTED: string = 'remoteAbilityStarted'

@Entry
@Component
struct Index {
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')
  @State isLand: boolean = false
  @State currentTimeText: string = ''
  @State currentProgress: number = 0
  @State totalMs: number = 0
  @State riscale: number = 1
  @State risw: number = 720
  @State rish: number = 1280
  @State isSwitching: boolean = false
  @State deviceLists: Array<hardware_deviceManager.DeviceInfo> = []
  @State isDialogShowing: boolean = false
  @State isDistributed: boolean = false
  @State title: string = ''
  @State totalTimeText: string = '00:00'
  @State albumSrc: Resource = $r('app.media.album')
  @State selectedIndex: number = 0
  @State imageArrays: Array<Resource> = [$r('app.media.ic_hop'), $r('app.media.ic_play_previous'), $r('app.media.ic_play'), $r('app.media.ic_play_next')]
  private dialogController: CustomDialogController = null
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()
  onLand = (mediaQueryResult) => {
    Logger.info(TAG, `onLand: mediaQueryResult.matches= ${mediaQueryResult.matches}`)
    if (mediaQueryResult.matches) {
      this.isLand = true
    } else {
      this.isLand = false
    }
  }

  showDialog() {
    this.remoteDeviceModel.registerDeviceListCallback(() => {
      Logger.info(TAG, 'registerDeviceListCallback, callback entered')
      this.deviceLists = []
      this.deviceLists.push({
        deviceId: '0',
        deviceName: '本机',
        deviceType: 0,
        networkId: ''
      })
      let deviceTempList = this.remoteDeviceModel.discoverLists.length > 0 ? this.remoteDeviceModel.discoverLists : this.remoteDeviceModel.deviceLists
      for (let i = 0; i < deviceTempList.length; i++) {
        Logger.info(TAG, `device ${i}/${deviceTempList.length} deviceId= ${deviceTempList[i].deviceId},
         deviceName= ${deviceTempList[i].deviceName}, deviceType= ${deviceTempList[i].deviceType}`)
        this.deviceLists.push(deviceTempList[i])
        Logger.info(TAG, 'deviceLists push end')
      }
      Logger.info(TAG, 'CustomDialogController start')
      if (this.dialogController !== null) {
        this.dialogController.close()
        this.dialogController = null
      }
      this.dialogController = new CustomDialogController({
        builder: DeviceDialog({
          deviceLists: this.deviceLists,
          selectedIndex: this.selectedIndex,
          selectedIndexChange: this.selectedIndexChange
        }),
        autoCancel: true
      })
      this.dialogController.open()
      Logger.info(TAG, 'CustomDialogController end')
    })
  }

  onBackPress() {
    if (this.isDialogShowing === true) {
      this.dismissDialog()
      return true
    }
    return false
  }

  dismissDialog() {
    this.dialogController.close()
    this.remoteDeviceModel.unregisterDeviceListCallback()
    this.isDialogShowing = false
  }

  startAbilityContinuation(deviceId) {
    this.dialogController.close()
    let params
    Logger.info(TAG, `startAbilityContinuation PlayerModel.index= ${PlayerModel.index}/${PlayerModel.playlist.audioFiles.length}`)
    if (PlayerModel.index >= 0 && PlayerModel.index <= PlayerModel.playlist.audioFiles.length) {
      params = {
        uri: PlayerModel.playlist.audioFiles[PlayerModel.index].fileUri,
        seekTo: PlayerModel.getCurrentMs(),
        isPlaying: PlayerModel.isPlaying
      }
    } else {
      params = {
        uri: '',
        seekTo: 0,
        isPlaying: false
      }
    }
    Logger.info(TAG, `globalThis.abilityConText.startAbility deviceId= ${deviceId}`)
    let wantValue = {
      bundleName: 'ohos.samples.etsdistributedmusicplayer',
      abilityName: 'MainAbility',
      deviceId: deviceId,
      parameters: params
    }
    let timerId = setTimeout(() => {
      Logger.info(TAG, 'onMessageReceiveTimeout, terminateSelf')
      globalThis.abilityConText.terminateSelf((error) => {
        Logger.info(TAG, `terminateSelf finished, error= ${error}`)
      })
    }, 3000)

    KvStoreModel.setOnMessageReceivedListener(REMOTE_ABILITY_STARTED, () => {
      Logger.info(TAG, 'OnMessageReceived, terminateSelf')
      clearTimeout(timerId)
      globalThis.abilityConText.terminateSelf((error) => {
        Logger.info(TAG, `terminateSelf finished, error= ${error}`)
      })
    })
    Logger.info(TAG, `globalThis.abilityConText.startAbility start`)
    globalThis.abilityConText.startAbility(wantValue).then((data) => {
      Logger.info(TAG, `globalThis.abilityConText.startAbility finished ${JSON.stringify(data)}`)
    })
    this.clearSelectState()
    Logger.info(TAG, `globalThis.abilityConText.startAbility want= ${JSON.stringify(wantValue)}`)
    Logger.info(TAG, 'globalThis.abilityConText.startAbility end')
  }

  selectedIndexChange = (selectedIndex) => {
    if (selectedIndex === 0) {
      globalThis.abilityConText.startAbility({ bundleName: 'ohos.samples.etsdistributedmusicplayer',
        abilityName: 'MainAbility',
        deviceId: this.deviceLists[selectedIndex].deviceId,
        parameters: {
          isFA: 'EXIT'
        }
      }).then((data) => {
        Logger.info(TAG, `startAbility finished ${JSON.stringify(data)}`)
      })
      this.isDistributed = false
      this.selectedIndex = 0
      this.dialogController.close()
      this.deviceLists = []
      return
    }
    this.selectedIndex = selectedIndex
    this.selectDevice()
  }

  selectDevice() {
    Logger.info(TAG, 'start ability ......')
    if (this.remoteDeviceModel === null || this.remoteDeviceModel.discoverLists.length <= 0) {
      Logger.info(TAG, `start ability device:${JSON.stringify(this.deviceLists)}`)
      this.startAbilityContinuation(this.deviceLists[this.selectedIndex].deviceId)
      this.clearSelectState()
      return
    }
    Logger.info(TAG, 'start ability, needAuth')
    this.remoteDeviceModel.authDevice(this.deviceLists[this.selectedIndex], (device) => {
      Logger.info(TAG, 'auth and online finished')
      this.startAbilityContinuation(device.deviceId)
    })
    Logger.info(TAG, 'start ability2 ......')
    this.clearSelectState()
  }

  clearSelectState() {
    this.deviceLists = []
    this.dialogController.close()
    this.dialogController = null
  }

  getShownTimer(ms) {
    let seconds = Math.floor(ms / ONE_THOUSAND)
    let sec = seconds % SIXTY
    let minStr: string
    let secStr: string
    let min = (seconds - sec) / SIXTY
    sec < 10 ? secStr = '0' + sec : '' + sec
    min < 10 ? minStr = '0' + min : '' + min
    return minStr + ':' + secStr
  }

  refreshSongInfo(index) {
    Logger.info(TAG, `refreshSongInfo ${index}/${PlayerModel.playlist.audioFiles.length}`)
    if (index >= PlayerModel.playlist.audioFiles.length) {
      Logger.warn(TAG, 'refreshSongInfo ignored')
      return
    }
    // update song title
    this.title = PlayerModel.playlist.audioFiles[index].name
    this.albumSrc = (index % 2 === 0) ? $r('app.media.album') : $r('app.media.album2')

    // update duration
    this.totalMs = PlayerModel.getDuration()
    this.totalTimeText = this.getShownTimer(this.totalMs)
    this.currentTimeText = this.getShownTimer(PlayerModel.getCurrentMs())
    this.currentProgress = Math.floor(PlayerModel.getCurrentMs() / this.totalMs * ONE_HUNDRED)

    Logger.info(TAG, `refreshSongInfo this.title= ${this.title}, this.totalMs=
            ${this.totalMs}, this.totalTimeText= ${this.totalTimeText},this.currentTimeText= ${this.currentTimeText}`)
  }

  onPreviousClick() {
    if (this.isSwitching) {
      Logger.info(TAG, 'onPreviousClick ignored, isSwitching')
      return
    }
    Logger.info(TAG, 'onPreviousClick')
    PlayerModel.index--
    if (PlayerModel.index < 0 && PlayerModel.playlist.audioFiles.length >= 1) {
      PlayerModel.index = PlayerModel.playlist.audioFiles.length - 1
    }
    this.currentProgress = 0
    this.isSwitching = true

    PlayerModel.preLoad(PlayerModel.index, () => {
      this.refreshSongInfo(PlayerModel.index)
      PlayerModel.play(0, true)
      if (PlayerModel.isPlaying) {
        this.imageArrays[2] = $r('app.media.ic_pause')
      }
      this.isSwitching = false
    })
  }

  onNextClick() {
    if (this.isSwitching) {
      Logger.info(TAG, 'onNextClick ignored, isSwitching')
      return
    }
    Logger.info(TAG, 'onNextClick')
    PlayerModel.index++
    if (PlayerModel.index >= PlayerModel.playlist.audioFiles.length) {
      PlayerModel.index = 0
    }
    this.currentProgress = 0
    this.isSwitching = true
    PlayerModel.preLoad(PlayerModel.index, () => {
      this.refreshSongInfo(PlayerModel.index)
      PlayerModel.play(0, true)
      if (PlayerModel.isPlaying) {
        this.imageArrays[2] = $r('app.media.ic_pause')
      }
      this.isSwitching = false
    })
  }

  onPlayClick() {
    if (this.isSwitching) {
      Logger.info(TAG, 'onPlayClick ignored, isSwitching')
      return
    }
    Logger.info(TAG, `onPlayClick isPlaying= ${PlayerModel.isPlaying}`)
    if (PlayerModel.isPlaying) {
      PlayerModel.pause()
      this.imageArrays[2] = $r('app.media.ic_play')
    } else {
      PlayerModel.preLoad(0, () => {
        PlayerModel.play(-1, true)
        this.imageArrays[2] = $r('app.media.ic_pause')
      })
    }
  }

  restoreFromWant() {
    Logger.info(TAG, 'restoreFromWant')
    let status = globalThis.abilityWant.parameters
    if (status !== null && status.uri !== null) {
      KvStoreModel.broadcastMessage(REMOTE_ABILITY_STARTED)
      Logger.info(TAG, 'restorePlayingStatus')
      PlayerModel.restorePlayingStatus(status, (index) => {
        Logger.info(TAG, `restorePlayingStatus finished, index= ${index}`)
        if (index >= 0) {
          this.refreshSongInfo(index)
        } else {
          PlayerModel.preLoad(0, () => {
            this.refreshSongInfo(0)
          })
        }
      })
    } else {
      PlayerModel.preLoad(0, () => {
        this.refreshSongInfo(0)
      })
    }
  }

  aboutToAppear() {
    Logger.info(TAG, `begin`)
    Logger.info(TAG, 'grantPermission')
    let requestCode = 666
    globalThis.abilityConText.requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'], requestCode, function (result) {
      Logger.info(TAG, `grantPermission,requestPermissionsFromUser,result= ${result}`)
    })
    display.getDefaultDisplay().then((dis) => {
      Logger.info(TAG, `getDefaultDisplay dis= ${JSON.stringify(dis)}`)
      let proportion = DESIGN_WIDTH / dis.width
      let screenWidth = DESIGN_WIDTH
      let screenHeight = (dis.height - SYSTEM_UI_HEIGHT) * proportion
      this.riscale = (screenHeight / screenWidth) / DESIGN_RATIO
      if (this.riscale < 1) {
        // The screen ratio is shorter than design ratio
        this.risw = screenWidth * this.riscale
        this.rish = screenHeight
      } else {
        // The screen ratio is longer than design ratio
        this.risw = screenWidth
        this.rish = screenHeight / this.riscale
      }
      Logger.info(TAG, `proportion=${proportion} , screenWidth= ${screenWidth},
      screenHeight= ${screenHeight} , riscale= ${this.riscale} , risw= ${this.risw} , rish= ${this.rish}`)
    })
    Logger.info(TAG, 'getDefaultDisplay end')
    this.currentTimeText = this.getShownTimer(0)
    PlayerModel.setOnStatusChangedListener((isPlaying) => {
      Logger.info(TAG, `on player status changed, isPlaying= ${isPlaying} refresh ui`)
      PlayerModel.setOnPlayingProgressListener((currentTimeMs) => {
        this.currentTimeText = this.getShownTimer(currentTimeMs)
        this.currentProgress = Math.floor(currentTimeMs / this.totalMs * ONE_HUNDRED)
      })
      if (isPlaying) {
        this.imageArrays[2] = $r('app.media.ic_pause')
      } else {
        this.imageArrays[2] = $r('app.media.ic_play')
      }
    })

    PlayerModel.getPlaylist(() => {
      Logger.info(TAG, 'on playlist generated, refresh ui')
      this.restoreFromWant()
    })
  }

  build() {
    Column() {
      Text(this.title)
        .width('100%')
        .fontSize(30)
        .margin({ top: '10%' })
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
      Image(this.albumSrc)
        .width(this.isLand ? '60%' : '80%')
        .height(this.isLand ? '50%' : '35%')
        .objectFit(ImageFit.Contain)
        .margin({ top: 20, left: 40, right: 40 })
      Row() {
        Text(this.currentTimeText)
          .fontSize(20)
          .fontColor(Color.White)
        Blank()
        Text(this.totalTimeText)
          .fontSize(20)
          .fontColor(Color.White)
      }
      .width('90%')
      .margin({ top: '10%' })

      Slider({ value: this.currentProgress })
        .width('80%')
        .selectedColor('#ff0c4ae7')
        .onChange((value: number, mode: SliderChangeMode) => {
          this.currentProgress = value
          if (isNaN(this.totalMs)) {
            this.currentProgress = 0
            Logger.info(TAG, `setProgress ignored, totalMs= ${this.totalMs}`)
            return
          }
          var currentMs = this.currentProgress / ONE_HUNDRED * this.totalMs
          this.currentTimeText = this.getShownTimer(currentMs)
          if (mode === SliderChangeMode.End || mode === SliderChangeMode.Click) {
            Logger.info(TAG, `player.seek= ${currentMs}`)
            PlayerModel.seek(currentMs)
          }
        })

      Flex({
        direction: FlexDirection.Row,
        alignContent: FlexAlign.SpaceAround,
        justifyContent: FlexAlign.SpaceEvenly
      }) {
        ForEach(this.imageArrays, (item, index) => {
          Column() {
            Image(item)
              .size({ width: 72, height: 72 })
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                switch (index) {
                  case 0:
                    this.showDialog()
                    break
                  case 1:
                    this.onPreviousClick()
                    break
                  case 2:
                    this.onPlayClick()
                    break
                  case 3:
                    this.onNextClick()
                    break
                  default:
                    break
                }
              })
          }
          .width(100)
          .height(100)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        })
      }
      .width('100%')
      .margin({ top: '10%' })
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg_blurry'))
    .backgroundImageSize({ width: '100%', height: '100%' })
  }
}