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
import bluetooth from '@ohos.bluetooth'
import multimedia_mediaLibrary from '@ohos.multimedia.mediaLibrary'
import logger from '../Model/Logger'
import { TitleBar } from '../Commom/TitleBar'
import { PinDialog } from '../Commom/PinDialog'

const TAG: string = 'Index'
const TIME: number = 0 // 设备可被发现的持续时间

@Entry
@Component
struct Index {
  @State images: Array<string> = []
  @State fileAssets: Array<multimedia_mediaLibrary.FileAsset> = []
  @State startStatus: boolean = false
  @State isOn: boolean = false
  @State deviceList: Array<string> = []
  @State discoveryList: Array<string> = []
  private serviceId: number = -1
  private clientId: number = -1
  private bluetoothState: boolean = false
  private pinDialogController: CustomDialogController | null = null
  private intervalId: number = -1
  handlerClickButton = () => {
    globalThis.abilityContext.terminateSelf()
  }

  foundDevices() {
    bluetooth.on('bluetoothDeviceFind', (data) => {
      logger.info(TAG, `enter on bluetoothDeviceFind`)
      if (data !== null && data.length > 0) {
        if (this.discoveryList.indexOf(data[0]) === -1 && this.deviceList.indexOf(data[0]) === -1) {
          this.discoveryList.push(data[0])
        }
        logger.info(TAG, `discoveryList = ${JSON.stringify(this.discoveryList)}`)
      }
      let list = bluetooth.getPairedDevices()
      if (list !== null && list.length > 0) {
        this.deviceList = list
        logger.info(TAG, `deviceList =  ${JSON.stringify(this.deviceList)}`)
      }
    })
    bluetooth.startBluetoothDiscovery()
    bluetooth.setBluetoothScanMode(bluetooth.ScanMode.SCAN_MODE_CONNECTABLE_GENERAL_DISCOVERABLE, TIME)
  }

  async aboutToAppear() {
    await globalThis.abilityContext.requestPermissionsFromUser(['ohos.permission.USE_BLUETOOTH', 'ohos.permission.DISCOVER_BLUETOOTH', 'ohos.permission.LOCATION', 'ohos.permission.MANAGE_BLUETOOTH'])
    logger.info(TAG, `grantPermission,requestPermissionsFromUser,PermissionRequestResult`)

    let state = bluetooth.getState()
    if (state === bluetooth.BluetoothState.STATE_ON) {
      this.isOn = true
      this.foundDevices()
    }
    if (state === bluetooth.BluetoothState.STATE_OFF) {
      this.isOn = false
    }

    bluetooth.on('pinRequired', (data) => {
      logger.info(TAG, `enter pinRequired`)
      this.pinDialogController = new CustomDialogController({
        builder: PinDialog({ data: data }),
        autoCancel: true,
        alignment: DialogAlignment.Bottom
      })
      this.pinDialogController.open()
      logger.info(TAG, `onPinRequiredData = ${JSON.stringify(data)}`)
    })

    bluetooth.on('bondStateChange', (data) => {
      logger.info(TAG, `enter bondStateChange`)
      logger.info(TAG, `data = ${JSON.stringify(data)}`)
      if (data.state === bluetooth.BondState.BOND_STATE_BONDED) {
        logger.info(TAG, `BOND_STATE_BONDED`)
        let index = this.discoveryList.indexOf(data.deviceId)
        this.discoveryList.splice(index, 1)
        this.deviceList = bluetooth.getPairedDevices()
      }
      if (data.state === bluetooth.BondState.BOND_STATE_INVALID) {
        logger.info(TAG, `BOND_STATE_INVALID`)
        this.deviceList = bluetooth.getPairedDevices()
      }
      logger.info(TAG, `bondStateChange,data = ${JSON.stringify(data)}`)
    })

    this.intervalId = setInterval(() => {
      this.discoveryList = []
      this.foundDevices()
    }, 30000)

  }

  initBluetooth() {
    bluetooth.on('stateChange', (data) => {
      logger.info(TAG, `enter on stateChange`)
      if (data === bluetooth.BluetoothState.STATE_ON) {
        logger.info(TAG, `enter BluetoothState.STATE_ON`)
        this.foundDevices()
      }
      if (data === bluetooth.BluetoothState.STATE_OFF) {
        logger.info(TAG, `enter BluetoothState.STATE_OFF`)
        bluetooth.off('bluetoothDeviceFind', (data) => {
          logger.info(TAG, `offBluetoothDeviceFindData = ${JSON.stringify(data)}`)
        })
        bluetooth.stopBluetoothDiscovery()
        this.discoveryList = []
      }
      logger.info(TAG, `BluetoothState = ${JSON.stringify(data)}`)
    })
    bluetooth.enableBluetooth()
  }

  build() {
    Column() {
      TitleBar({ handlerClickButton: this.handlerClickButton })
      Scroll() {
        Column() {
          Row() {
            Column() {
              Text($r('app.string.bluetooth'))
                .fontSize(30)
                .margin({ top: 20 })
                .alignSelf(ItemAlign.Start)
              if (true === this.isOn) {
                Text($r('app.string.discovery'))
                  .fontSize(20)
                  .alignSelf(ItemAlign.Start)
              }
            }

            Blank()

            Column() {
              Toggle({ type: ToggleType.Switch, isOn: this.isOn })
                .selectedColor('#ff2982ea')
                .onChange((isOn: boolean) => {
                  if (isOn) {
                    this.isOn = true
                    this.initBluetooth()
                  } else {
                    this.isOn = false
                    bluetooth.disableBluetooth()
                    this.deviceList = []
                    this.discoveryList = []
                  }
                })
            }
          }
          .width('90%')

          if (this.isOn) {
            Divider()
              .vertical(false)
              .strokeWidth(10)
              .color('#ffece7e7')
              .lineCap(LineCapStyle.Butt)
              .margin('1%')

            Text($r('app.string.paired_device'))
              .fontSize(25)
              .fontColor('#ff565555')
              .margin({ left: '5%' })
              .alignSelf(ItemAlign.Start)

            ForEach(this.deviceList, (item) => {
              Row() {
                Text(item)
                  .fontSize(20)
              }
              .alignSelf(ItemAlign.Start)
              .width('100%')
              .height(50)
              .margin({ left: '5%', top: '1%' })
              .onClick(() => {
                AlertDialog.show({
                  title: $r('app.string.disconnect'),
                  message: '此操作将会断开您与以下设备的连接：' + item,
                  primaryButton: {
                    value: $r('app.string.cancel'),
                    action: () => {
                    }
                  },
                  secondaryButton: {
                    value: $r('app.string.confirm'),
                    action: () => {
                      let deleteStatus = bluetooth.cancelPairedDevice(item);
                      logger.info(TAG, `deleteStatus = ${deleteStatus}`)
                      if (deleteStatus === true) {
                        this.deviceList = bluetooth.getPairedDevices()
                        this.discoveryList = []
                        bluetooth.startBluetoothDiscovery()
                      }
                    }
                  }
                })
              })
            })

            Divider()
              .vertical(false)
              .strokeWidth(10)
              .color('#ffece7e7')
              .lineCap(LineCapStyle.Butt)
              .margin('1%')

            Text($r('app.string.available_device'))
              .fontSize(25)
              .fontColor('#ff565555')
              .margin({ left: '5%', bottom: '2%' })
              .alignSelf(ItemAlign.Start)

            ForEach(this.discoveryList, (item) => {
              Row() {
                Text(item)
                  .fontSize(20)
              }
              .alignSelf(ItemAlign.Start)
              .width('100%')
              .height(50)
              .margin({ left: '5%', top: '1%' })
              .onClick(() => {
                logger.info(TAG, `start bluetooth.pairDevice,item = ${item}`)
                let pairStatus = bluetooth.pairDevice(item)
                logger.info(TAG, `pairStatus = ${pairStatus}`)
              })

              Divider()
                .vertical(false)
                .color('#ffece7e7')
                .lineCap(LineCapStyle.Butt)
                .margin('1%')
            })
          }
        }
      }
      .constraintSize({ maxHeight: '85%' })
    }
  }
}