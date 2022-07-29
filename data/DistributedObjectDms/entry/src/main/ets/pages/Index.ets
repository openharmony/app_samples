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

import prompt from '@ohos.prompt'
import window from '@ohos.window'
import display from '@ohos.display'
import deviceManager from '@ohos.distributedHardware.deviceManager'
import Logger from '../data/Logger'
import DataModel from '../data/DataModel'
import RemoteDeviceModel from '../data/RemoteDeviceModel'
import { distributedDataModel } from '../data/DistributedDataModel'
import { dmsConst } from '../data/DmsConst'
import TitleBar from '../component/TitleBar'

const TAG: string = 'Index'

@Entry
@Component
struct Index {
  @State documents: Array<DataModel> = []
  @State screenWidth: number = 0
  @State screenHeight: number = 0
  @State imageTranslate: number = 195 // 动画在中间
  @State duration: number = dmsConst.CONVERT_MILLISECOND
  @State status: Array<boolean> = new Array()
  @State @Watch('changeDevices') devices: Array<deviceManager.DeviceInfo> = []
  @State remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()
  @State isStart: boolean = false
  @State isShowDialog: boolean = true
  @State dialogShow: boolean = false
  @State deviceText: string = ''
  @State screenSizeText: string = ''
  @State offlineText: string = ''
  @State onlineText: string = ''
  @State allCompleteText: string = ''
  private deviceTag: number = 0
  private deleteDevices: Array<deviceManager.DeviceInfo> = []
  private countCallBack: number = 0
  private tempDocuments: Array<DataModel> = []

  @Builder statusBuild(resource: Resource) {
    Image(resource)
      .width(15)
      .height(15)
      .margin({ right: 40 })
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
      TitleBar({
        devices: $devices,
        remoteDeviceModel: $remoteDeviceModel,
        dialogShow: $dialogShow,
        isStart: this.isStart
      })

      Image($r('app.media.people'))
        .width(80)
        .height(80)
        .margin({ top: 50, bottom: 20 })
        .translate({ x: this.imageTranslate })

      Text($r('app.string.MainAbility_label'))
        .fontSize(20)
        .fontColor('#D7D6D6')
        .alignSelf(ItemAlign.Center)

      Scroll() {
        Column() {
          ForEach(this.devices, (item, index) => {
            Row() {
              Column() {
                if (this.devices.length >= index + dmsConst.ONE) {
                  Text(`${index}${this.deviceText}${this.devices[index].deviceId}`)
                    .fontSize(18)
                    .fontWeight(500)
                }
                if (index === 0) {
                  Text(`${this.screenSizeText}${fp2px(this.screenWidth)} * ${this.screenHeight}`)
                    .fontSize(17)
                }
                if (index !== 0 && this.documents.length >= index && this.documents[index-dmsConst.ONE]) {
                  Text(`${this.screenSizeText}${this.documents[index-dmsConst.ONE].screenSize}`)
                    .fontSize(17)
                }
              }
              .width('85%')
              .margin({ left: 20 })
              .alignItems(HorizontalAlign.Start)

              Blank()
              Column() {
                if (this.status.length > index && !this.status[index]) {
                  this.statusBuild($r('app.media.red'))
                } else {
                  this.statusBuild($r('app.media.green'))
                }
              }
              .width('10%')
            }
            .width('100%')
            .constraintSize({ minHeight: 120 })
            .alignSelf(ItemAlign.Start)
            .backgroundColor('#F6F8F8')
            .borderRadius(40)
            .margin({ top: 20 })
          }, item => item.deviceId)
        }
        .width('100%')
      }
      .constraintSize({ maxHeight: '53%' })
      .margin({ top: 10 })

      if (!this.isStart) {
        Button() {
          Text($r('app.string.start'))
            .fontSize(30)
            .fontColor(Color.White)
        }
        .width('40%')
        .height(60)
        .margin({ top: 100 })
        .backgroundColor('#0D9EFA')
        .alignSelf(ItemAlign.Center)
        .onClick(() => {
          Logger.info(TAG, `onClick start devices: ${JSON.stringify(this.devices)}`)
          this.registerDevice()
          this.isStart = true
          Logger.info(TAG, 'onClick end')
        })
      }
    }
    .width('100%')
    .height('100%')
  }

  async convertResourceToString(resource: Resource) {
    Logger.info(TAG, `result = ${JSON.stringify(await globalThis.abilityContext.resourceManager.getString(resource))}`)
    return await globalThis.abilityContext.resourceManager.getString(resource)
  }

  changeDevices() {
    this.status = this.devices.map(() => {
      return false
    })
  }

  dataChangeCallback = () => {
    this.countCallBack++
    Logger.info(TAG, `this.countCallBack = ${this.countCallBack}`)
    if (this.countCallBack % dmsConst.TWO === dmsConst.ONE) {
      return
    }
    Logger.info(TAG, `dataChangeCallback distributedObject = ${JSON.stringify(distributedDataModel.distributedObject)}`)
    this.tempDocuments = distributedDataModel.distributedObject.documents
    if (this.tempDocuments.length > 0) {
      this.documents.push(this.tempDocuments[dmsConst.ZERO])
    }
    if (this.status.length > this.deviceTag) {
      this.status[this.deviceTag] = true
    }
    Logger.info(TAG, `dataChangeCallback this.deviceTag = ${this.deviceTag}`)
    if (this.deviceTag < this.devices.length - dmsConst.ONE) {
      this.startAbility(this.devices[++this.deviceTag].deviceId)
    } else if (this.deviceTag === (this.devices.length - dmsConst.ONE) && this.isShowDialog) {
      prompt.showToast({ message: this.allCompleteText })
      this.isShowDialog = false
      this.isStart = false
    }
    Logger.info(TAG, `dataChangeCallback end`)
  }

  async aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear start')
    await globalThis.abilityContext.requestPermissionsFromUser([dmsConst.PERMISSION_NAME], dmsConst.REQUEST_CODE)
    this.deviceText = await this.convertResourceToString($r('app.string.device_id'))
    this.screenSizeText = await this.convertResourceToString($r('app.string.record_screen_size'))
    this.offlineText = await this.convertResourceToString($r('app.string.offline'))
    this.onlineText = await this.convertResourceToString($r('app.string.online'))
    this.allCompleteText = await this.convertResourceToString($r('app.string.all_device_complete'))
    await this.onInit()
    if (globalThis.isFA === 'isFA') {
      this.imageTranslate = 0
      this.isStart = true
      Logger.info(TAG, `aboutToAppear setTimeout ${this.duration} ${this.screenWidth}`)
      animateTo({ duration: this.duration, curve: Curve.Linear, onFinish: () => {
        this.add(globalThis.deviceId, `${fp2px(this.screenWidth)} * ${this.screenHeight}`)
      } }, () => {
        Logger.info(TAG, 'setTimeout translates')
        this.imageTranslate = this.screenWidth
        Logger.info(TAG, `setTimeout translates = ${this.imageTranslate}`)
      })
    }
    Logger.info(TAG, 'aboutToAppear end')
  }

  async onInit() {
    await this.setFullScreen()
    distributedDataModel.onChangeCallback(this.dataChangeCallback)
    distributedDataModel.onStatusCallback((sessionId, networkId, status) => {
      Logger.info(TAG, `onStatusCallback ${sessionId} ${networkId} ${status}`)
      if (status === 'online') {
        prompt.showToast({ message: `${networkId}${this.onlineText}` })
      } else if (status === 'offline') {
        prompt.showToast({ message: `${networkId}${this.offlineText}` })
      }
    })
  }

  aboutToDisappear() {
    distributedDataModel.clearCallback()
    this.deviceTag = 0
    this.countCallBack = 0
  }

  /**
   * 分布式对象添加数据
   *
   * @param deviceId 设备id
   * @param screenSize 本机屏幕大小
   */
  async add(deviceId: string, screenSize: string) {
    Logger.info(TAG, `add start`)
    distributedDataModel.add(deviceId, screenSize, await this.convertResourceToString($r('app.string.already_complete')))
  }


  /**
   * 设置全屏,屏幕长亮
   */
  async setFullScreen() {
    Logger.info(TAG, `setFullScreen start`)
    try {
      let defaultDisplay = await  display.getDefaultDisplay()
      Logger.info(TAG, `setFullScreen densityDPI = ${defaultDisplay.densityDPI}`)
      this.screenWidth = px2fp(defaultDisplay.width)
      this.screenHeight = defaultDisplay.height
      this.duration = this.screenWidth / dmsConst.PLAY_SPEED * dmsConst.CONVERT_MILLISECOND // 匀速播放时长
      Logger.info(TAG, `setFullScreen width = ${this.width}`)
      const topWindow = await window.getTopWindow(globalThis.abilityContext)
      await topWindow.setFullScreen(true)
      await topWindow.setKeepScreenOn(true)
    } catch (err) {
      Logger.error(TAG, `setFullScreen fail , code = ${err.code}`)
    }
  }

  /**
   * 注册设备
   */
  registerDevice() {
    Logger.info(TAG, `registerDevice startAbility devices = ${JSON.stringify(this.devices)}`)
    if (this.status.length > this.deviceTag) {
      this.status[this.deviceTag] = true
    }
    if (this.devices.length > this.deviceTag + dmsConst.ONE) {
      this.startAbility(this.devices[++this.deviceTag].deviceId)
    }
    Logger.info(TAG, 'registerDevice startAbility end')
  }

  /**
   * 启动远程设备
   *
   * @param deviceId 设备id
   */
  async startAbility(deviceId) {
    Logger.info(TAG, `startAbility deviceId: ${deviceId}`)
    await globalThis.abilityContext.startAbility({
      bundleName: dmsConst.BUNDLE_NAME,
      abilityName: dmsConst.ABILITY_NAME,
      deviceId: deviceId,
      parameters: {
        isFA: 'isFA'
      }
    }).then((data) => {
      Logger.info(TAG, `start ability finished data = ${JSON.stringify(data)}`)
    })
  }
}