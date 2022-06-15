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

import usb from '@ohos.usb'
import prompt from '@ohos.prompt'
import Subscriber from '@ohos.commonEvent'
import DeviceCustomDialog from '../common/DeviceCustomDialog'
import CheckEmptyUtils from '../utils/CheckEmptyUtils'
import DeviceAttribute from '../model/DeviceAttribute'
import DeviceList from '../common/DeviceList'
import Logger from '../model/Logger'

const TAG: string = '[Index]'
let isSubscribed: boolean = false

@CustomDialog
struct CustomUSBDeviceInfoDialog {
  private controller: CustomDialogController
  private device?: DeviceAttribute
  onCancel = () => {
    this.controller.close()
  }

  build() {
    Column() {
      DeviceCustomDialog({ device: this.device, onCancel: this.onCancel })
    }
    .width('80%')
    .height('80%')
  }
}

@Entry
@Component
struct Index {
  @State result: string = ''
  @State isListener: boolean = false
  @State isRefreshing: boolean = false
  @State devices: Array<DeviceAttribute> = []
  @State device: DeviceAttribute = new DeviceAttribute()
  private commonEventSubscriber: any = undefined
  private eventTips = {
    ATTACHED: 'usual.event.hardware.usb.action.USB_DEVICE_ATTACHED',
    DETACHED: 'usual.event.hardware.usb.action.USB_DEVICE_DETACHED'
  }
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomUSBDeviceInfoDialog({ device: this.device }),
    cancel: this.existApp,
    autoCancel: true
  })

  existApp() {
    Logger.info(TAG, 'Click the callback in the blank area')
  }

  listenerSwitch(isListener: boolean) {
    if (isListener) {
      this.subUsbListener()
    } else {
      this.unSubscriberListener()
    }
  }

  subUsbListener() {
    Logger.info(TAG, 'usb subUsbListener....')
    if (isSubscribed) {
      Logger.info(TAG, 'usb event already subscribed')
      return
    }
    let commonEventSubscribeInfo = {
      events: [Subscriber.Support.COMMON_EVENT_USB_DEVICE_DETACHED, Subscriber.Support.COMMON_EVENT_USB_DEVICE_ATTACHED]
    }
    let promise = Subscriber.createSubscriber(commonEventSubscribeInfo)
    promise.then((data) => {
      prompt.showToast({ message: '开始监听...', duration: 1500 })
      Logger.info(TAG, 'usb CreateSubscriberCallBack....')
      this.commonEventSubscriber = data
      Subscriber.subscribe(this.commonEventSubscriber, this.SubscriberCallBack.bind(this))
      Logger.info(TAG, 'Subscriber.subscribe sucess')
      isSubscribed = true
    }).catch((err) => {
      Logger.info(TAG, `Subscriber.createSubscriber promise err = ${JSON.stringify(err)}`)
    })
  }

  SubscriberCallBack(err, data) {
    Logger.info(TAG, `SubscriberCallBack  data = ${JSON.stringify(data)}`)
    if (data.event === this.eventTips.ATTACHED) {
      prompt.showToast({ message: 'USB已插入', duration: 1500 })
    } else {
      prompt.showToast({ message: '已移除设备', duration: 1500 })
    }
    this.getDeviceList()
  }

  getDeviceList() {
    this.devices = []
    Logger.info(TAG, `usb getDeviceList...`)
    let usbDevices = usb.getDevices()
    if (CheckEmptyUtils.isEmptyArray(usbDevices)) {
      Logger.info(TAG, `usb getDeviceList is null`)
      this.result = 'device list is empty'
      return
    }
    Logger.info(TAG, `usb getDeviceList : ${JSON.stringify(usbDevices)}`)
    for (let index = 0; index < usbDevices.length; index++) {
      let deviceAttribute = {
        version: usbDevices[index].version,
        serial: usbDevices[index].serial,
        productName: usbDevices[index].productName,
        manufacturerName: usbDevices[index].manufacturerName,
        name: usbDevices[index].name,
        productId: usbDevices[index].productId,
        vendorId: usbDevices[index].vendorId,
        busAddress: usbDevices[index].busNum,
        clazz: usbDevices[index].clazz,
        deviceAddress: usbDevices[index].devAddress
      }
      this.devices.push(deviceAttribute)
    }
    Logger.info(TAG, `usb this.devices : ${JSON.stringify(this.devices)}`)
  }

  unSubscriberListener() {
    if (!isSubscribed || CheckEmptyUtils.isEmpty(this.commonEventSubscriber)) {
      Logger.info(TAG, `usb event not subscribed`)
      return
    }
    prompt.showToast({ message: '取消监听', duration: 1500 })
    Logger.info(TAG, `usb event unsubscribed`)
    Subscriber.unsubscribe(this.commonEventSubscriber, () => {
      Logger.info(TAG, `usb event unsubscribed`)
    })
    isSubscribed = false
  }

  build() {
    Column() {
      Text($r('app.string.MainAbility_label'))
        .height(50)
        .fontSize(25)
        .width('100%')
        .padding({ left: 10 })
        .fontColor(Color.White)
        .textAlign(TextAlign.Start)
        .backgroundColor('#0D9FFB')
        .fontWeight(FontWeight.Bold)

      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
        Text($r('app.string.usb_listener'))
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Toggle({ type: ToggleType.Switch, isOn: this.isListener })
          .selectedColor(0xed6f21)
          .switchPointColor(0xe5ffffff)
          .onChange((isOn: boolean) => {
            Logger.info(TAG, `Component status:${isOn}`)
            this.isListener = !this.isListener
            this.listenerSwitch(this.isListener)
          })
      }.margin({ top: 50 })

      DeviceList({
        isRefreshing: $isRefreshing,
        device: $device,
        devices: $devices,
        getDeviceList: () => {
          this.getDeviceList()
        },
        openDialog: () => {
          this.dialogController.open()
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}