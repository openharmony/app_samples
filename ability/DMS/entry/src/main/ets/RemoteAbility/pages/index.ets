/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import featureAbility from '@ohos.ability.featureAbility';
import prompt from '@system.prompt';
import rpc from "@ohos.rpc";
import RemoteDeviceModel from '../../model/RemoteDeviceModel.ets';

enum Operation {
  AuthDeviceOperation,
  StartRemoteAbilityOperation,
  ContinueAbilityOperation,
  ConnectRemoteServiceOperation,
}
var connectedAbility;
var localDeviceId = "";
var mRemote;
var remoteDeviceModel = new RemoteDeviceModel;
let discovereDeviceIdList = [];
let DeviceIdList = [];
let mOperation = Operation.AuthDeviceOperation;

function RegisterDeviceListCallback() {
  console.info('[dmsDemo] RegisterDeviceListCallback begin');
  remoteDeviceModel.registerDeviceListCallback(() => {
    console.info('[dmsDemo] RegisterDeviceListCallback, callback entered');
    let discoveredDeviceSize = remoteDeviceModel.discoverList.length;
    let deviceSize = remoteDeviceModel.deviceList.length;
    console.info('[dmsDemo] discoveredDeviceSize =' + discoveredDeviceSize);
    console.info('[dmsDemo] deviceSize =' + deviceSize);
    discovereDeviceIdList.length = 0;
    for (var i = 0; i < discoveredDeviceSize; i++) {
      discovereDeviceIdList.push(remoteDeviceModel.discoverList[i].deviceId);
    }
    DeviceIdList.length = 0;
    for (var i = 0; i < deviceSize; i++) {
      DeviceIdList.push(remoteDeviceModel.deviceList[i].deviceId);
    }
    console.info('[dmsDemo] RegisterDeviceListCallback on remote device updated, count=' + deviceSize);
    if (deviceSize === 0) {
      if (discoveredDeviceSize > 0) {
        prompt.showToast({
          message: "RegisterDeviceListCallback dicovered " + discoveredDeviceSize + " devices, need to authenticate"
        });
      } else {
        prompt.showToast({
          message: "RegisterDeviceListCallback no device discovered"
        });
      }
    }
    if (deviceSize >= 1) {
      prompt.showToast({
        message: "RegisterDeviceListCallback at least one device is successfully networked"
      });
    }
  });
  console.info('[dmsDemo] RegisterDeviceListCallback end');
}

function AuthDevice(deviceId) {
  console.info('[dmsDemo] AuthDevice begin');
  if (remoteDeviceModel.deviceList.length >= 1 && remoteDeviceModel.discoverList.length == 0) {
    prompt.showToast({
      message: "AuthDevice all devices networking success, no need authenticate"
    });
    return;
  }
  if (remoteDeviceModel.discoverList.length > 0) {
    remoteDeviceModel.authDevice(deviceId, () => {
      console.info('[dmsDemo] AuthDevice, callback entered');
      prompt.showToast({
        message: "AuthDevice device authenticate success"
      });
    });
  } else {
    prompt.showToast({
      message: "AuthDevice no device discovered"
    });
  }
  console.info('[dmsDemo] AuthDevice end');
}

function onStartLocalAbility() {
  console.info('[dmsDemo] onStartLocalAbility begin');
  console.info('[dmsDemo] onStartLocalAbility deviceId is ' + localDeviceId);
  var wantValue = {
    deviceId: localDeviceId,
    bundleName: 'ohos.samples.etsDemo',
    abilityName: 'ohos.samples.etsDemo.LocalAbility',
  };
  featureAbility.startAbility({
    want: wantValue
  }).then((data) => {
    console.info('[dmsDemo] featureAbility.startAbility finished, ' + JSON.stringify(data));
  });
  console.info('[dmsDemo] onStartLocalAbility end');
}

function onStartRemoteAbility(deviceId) {
  console.info('[dmsDemo] onStartRemoteAbility begin');
  let numDevices = remoteDeviceModel.deviceList.length;
  if (numDevices === 0) {
    prompt.showToast({
      message: "onStartRemoteAbility no device found"
    });
    return;
  }
  console.info('[dmsDemo] onStartRemoteAbility deviceId is ' + deviceId);
  var params;
  var wantValue = {
    bundleName: 'ohos.samples.etsDemo',
    abilityName: 'ohos.samples.etsDemo.RemoteAbility',
    deviceId: deviceId,
    parameters: params
  };
  console.info('[dmsDemo] onStartRemoteAbility want=' + JSON.stringify(wantValue));
  featureAbility.startAbility({
    want: wantValue
  }).then((data) => {
    console.info('[dmsDemo] onStartRemoteAbility finished, ' + JSON.stringify(data));
  });
  console.info('[dmsDemo] onStartRemoteAbility end');
}

function onConnectLocalService() {
  console.info('[dmsDemo] onConnectLocalService begin');
  console.info('[dmsDemo] onConnectLocalService deviceId is ' + localDeviceId);
  async function onConnectCallback(element, remote) {
    console.log('[dmsDemo] onConnectLocalService onConnectDone element: ' + element);
    console.log('[dmsDemo] onConnectLocalService onConnectDone remote: ' + remote);
    mRemote = remote;
    if (mRemote == null) {
      prompt.showToast({
        message: "onConnectLocalService not connected yet"
      });
      return;
    }
    let option = new rpc.MessageOption();
    let data = new rpc.MessageParcel();
    let reply = new rpc.MessageParcel();
    data.writeInt(1);
    data.writeInt(99);
    await mRemote.sendRequest(1, data, reply, option);
    let msg = reply.readInt();
    prompt.showToast({
      message: "onConnectLocalService connect result: " + msg,
      duration: 3000
    });
  }

  function onDisconnectCallback(element) {
    console.log('[dmsDemo] onConnectLocalService onDisconnectDone element: ' + element);
  }

  function onFailedCallback(code) {
    console.log('[dmsDemo] onConnectLocalService onFailed errCode: ' + code)
    prompt.showToast({
      message: "onConnectLocalService onFailed: " + code
    });
  }
  connectedAbility = featureAbility.connectAbility(
    {
      deviceId: localDeviceId,
      bundleName: "ohos.samples.etsDemo",
      abilityName: "ohos.samples.etsDemo.ServiceAbility",
    },
    {
      onConnect: onConnectCallback,
      onDisconnect: onDisconnectCallback,
      onFailed: onFailedCallback,
    },
  );
  console.log('[dmsDemo] onConnectLocalService connectedAbility: ' + connectedAbility)
}

function onConnectRemoteService(deviceId) {
  console.info('[dmsDemo] onConnectRemoteService begin');
  async function onConnectCallback(element, remote) {
    console.log('[dmsDemo] onConnectRemoteService onConnectDone element: ' + element);
    console.log('[dmsDemo] onConnectRemoteService onConnectDone remote: ' + remote);
    mRemote = remote;
    if (mRemote == null) {
      prompt.showToast({
        message: "onConnectRemoteService not connected yet"
      });
      return;
    }
    let option = new rpc.MessageOption();
    let data = new rpc.MessageParcel();
    let reply = new rpc.MessageParcel();
    data.writeInt(1);
    data.writeInt(99);
    await mRemote.sendRequest(1, data, reply, option);
    let msg = reply.readInt();
    prompt.showToast({
      message: "onConnectRemoteService connect result: " + msg,
      duration: 3000
    });
  }

  function onDisconnectCallback(element) {
    console.log('[dmsDemo] onConnectRemoteService onDisconnectDone element: ' + element);
  }

  function onFailedCallback(code) {
    console.log('[dmsDemo] onConnectRemoteService onFailed errCode: ' + code)
    prompt.showToast({
      message: "onConnectRemoteService onFailed: " + code
    });
  }
  let numDevices = remoteDeviceModel.deviceList.length;
  if (numDevices === 0) {
    prompt.showToast({
      message: "onConnectRemoteService no device found"
    });
    return;
  }
  console.info('[dmsDemo] onConnectRemoteService deviceId is ' + deviceId);
  connectedAbility = featureAbility.connectAbility(
    {
      deviceId: deviceId,
      bundleName: "ohos.samples.etsDemo",
      abilityName: "ohos.samples.etsDemo.ServiceAbility",
    },
    {
      onConnect: onConnectCallback,
      onDisconnect: onDisconnectCallback,
      onFailed: onFailedCallback,
    },
  );
  console.log('[dmsDemo] onConnectRemoteService connectedAbility: ' + connectedAbility)
}

async function onDisconnectService() {
  console.log('[dmsDemo] onDisconnectService begin');
  if (connectedAbility == null) {
    prompt.showToast({
      message: "onDisconnectService not connected yet"
    });
    return;
  }
  await featureAbility.disconnectAbility(connectedAbility);
  connectedAbility = null;
  prompt.showToast({
    message: "onDisconnectService disconnect done"
  });
}

function callFunction(item) {
  console.log('[dmsDemo] callFunction Operation:' + mOperation);
  console.log('[dmsDemo] callFunction item:' + item);
  if (mOperation === Operation.AuthDeviceOperation) {
    console.info('[dmsDemo] call AuthDevice, deviceId is: ' + item);
    AuthDevice(item);
  } else if (mOperation === Operation.StartRemoteAbilityOperation) {
    console.info('[dmsDemo] call onStartRemoteAbility, deviceId is: ' + item);
    onStartRemoteAbility(item);
  } else if (mOperation === Operation.ConnectRemoteServiceOperation) {
    console.info('[dmsDemo] call onConnectRemoteService, deviceId is: ' + item);
    onConnectRemoteService(item);
  }
  console.log('[dmsDemo] callFunction end');
}

@CustomDialog
struct CustomDialogExample1 {
  @State editFlag: boolean = false
  controller: CustomDialogController
  cancel: () => void
  confirm: () => void

  build() {
    Column() {
      List({ space: 10, initialIndex: 0 }) {
        ForEach(discovereDeviceIdList, (item) => {
          ListItem() {
            Row() {
              Text(item)
                .width('87%').height(50).fontSize(10)
                .textAlign(TextAlign.Center).borderRadius(10).backgroundColor(0xFFFFFF)
                .onClick(() => {
                  console.log('[dmsDemo] Text Item onClick:' + item);
                  callFunction(item);
                  this.controller.close();
                })
              Radio({value:item})
                .onChange((isChecked) => {
                  console.log('[dmsDemo] Radio Item:' + item + ' onChange isChecked:' + isChecked);
                  callFunction(item);
                  this.controller.close();
                }).checked(false)
            }
          }.editable(this.editFlag)
        }, item => item)
      }
    }.width('100%').height(200).backgroundColor(0xDCDCDC).padding({ top: 5 })
  }
}

@CustomDialog
struct CustomDialogExample2 {
  @State editFlag: boolean = false
  controller: CustomDialogController
  cancel: () => void
  confirm: () => void
  build() {
    Column() {
      List({ space: 10, initialIndex: 0 }) {
        ForEach(DeviceIdList, (item) => {
          ListItem() {
            Row() {
              Text(item)
                .width('87%').height(50).fontSize(10)
                .textAlign(TextAlign.Center).borderRadius(10).backgroundColor(0xFFFFFF)
                .onClick(() => {
                  console.log('[dmsDemo] Text Item onClick:' + item);
                  callFunction(item);
                  this.controller.close();
                })
              Radio({value:item})
                .onChange((isChecked) => {
                  console.log('[dmsDemo] Radio Item:' + item + ' onChange isChecked:' + isChecked);
                  callFunction(item);
                  this.controller.close();
                }).checked(false)
            }
          }.editable(this.editFlag)
        }, item => item)
      }
    }.width('100%').height(200).backgroundColor(0xDCDCDC).padding({ top: 5 })
  }
}

@Entry
@Component
struct Index {
  dialogController1: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample1({ cancel: this.onCancel, confirm: this.onAccept }),
    cancel: this.existApp,
    autoCancel: true
  })
  dialogController2: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample2({ cancel: this.onCancel, confirm: this.onAccept }),
    cancel: this.existApp,
    autoCancel: true
  })
  onCancel() {
    console.info('[dmsDemo] Callback when onCancel button is clicked');
  }
  onAccept() {
    console.info('[dmsDemo] Callback when onAccept button is clicked');
  }
  existApp() {
    console.info('[dmsDemo] Click the callback in the blank area');
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Button() {
        Text('RegisterDeviceListCallback')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        RegisterDeviceListCallback();
      }).width(400).height(30)

      Button() {
        Text('AuthDevice')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        mOperation = Operation.AuthDeviceOperation;
        console.log('[dmsDemo] discovereDeviceIdList length:' + discovereDeviceIdList.length);
        this.dialogController1.open();
      }).width(400).height(30)

      Button() {
        Text('StartLocalAbility')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        onStartLocalAbility();
      }).width(400).height(30)

      Button() {
        Text('StartRemoteAbility')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        mOperation = Operation.StartRemoteAbilityOperation;
        console.log('[dmsDemo] DeviceIdList length:' + DeviceIdList.length);
        this.dialogController2.open();
      }).width(400).height(30)

      Button() {
        Text('ConnectLocalService')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        onConnectLocalService();
      }).width(400).height(30)

      Button() {
        Text('ConnectRemoteService')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        mOperation = Operation.ConnectRemoteServiceOperation;
        console.log('[dmsDemo] DeviceIdList length:' + DeviceIdList.length);
        this.dialogController2.open();
      }).width(400).height(30)

      Button() {
        Text('DisConnectService')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        onDisconnectService();
      }).width(400).height(30)
    }
    .width('100%')
    .height('100%')
  }
}