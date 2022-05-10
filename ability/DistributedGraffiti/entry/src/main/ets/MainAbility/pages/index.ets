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

import abilityAccessCtrl from "@ohos.abilityAccessCtrl";
import bundle from '@ohos.bundle';
import deviceManager from "@ohos.distributedHardware.deviceManager";
import featureAbility from '@ohos.ability.featureAbility';
import rpc from "@ohos.rpc";
import prompt from '@ohos.prompt';

let REQUEST_PERMISSION_CODE = 1;
let CODE_CONNECT_REMOTE = 1;
let CODE_CONNECT_LOCAL = 2;
let CODE_CONTROL_FA = 3;

let dmClass;
let deviceList = [];
let mLocal;
let mRemote;
let connectedAbility;

class MainAbilityStub extends rpc.RemoteObject {
    callback;

    constructor(des : any) {
        if (typeof des === 'string') {
            super(des);
        } else {
            return null;
        }
    }

    registerCallback(callback : any) : void {
        this.callback = callback;
    }

    addDeathRecipient(recipient : any, flags : number) : boolean {
        return true;
    }

    removeDeathRecipient(recipient : any, flags : number) : boolean {
        return true;
    }

    isObjectDead() : boolean {
        return true;
    }

    onRemoteRequest(code : number, data : any, reply : any, options : any) : boolean {
        if (code === CODE_CONTROL_FA) {
            let x = data.readInt();
            let y = data.readInt();
            let touchType = data.readInt();
            this.callback(x, y, touchType);
        } else {
            console.log("MainAbilityStub unknown request code");
            return false;
        }
        return true;
    }
}

let mainAbilityStub = new MainAbilityStub("MainAbilityStub");

async function requestPermission() {
  let array: Array<string> = ["ohos.permission.DISTRIBUTED_DATASYNC"];
  let tokenID = undefined;
  const appInfo = await bundle.getApplicationInfo('ohos.samples.distributedgraffiti', 0, 100);
  tokenID = appInfo.accessTokenId;
  const atManager = abilityAccessCtrl.createAtManager();
  let requestPermissions: Array<string> = [];
  for (let i = 0;i < array.length; i++) {
    let result = await atManager.verifyAccessToken(tokenID, array[i]);
    if (result != abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      requestPermissions.push(array[i]);
    }
  }
  if (requestPermissions.length === 0) {
    return;
  }
  let context = featureAbility.getContext();
  context.requestPermissionsFromUser(requestPermissions, REQUEST_PERMISSION_CODE, (data)=>{
    console.info("data:" + JSON.stringify(data));
  });
}

function getDm() {
  deviceManager.createDeviceManager('ohos.samples.distributedgraffiti', (err, dm) => {
    if (err) {
      console.log("createDeviceManager error");
    }
    dmClass = dm;
  })
}

function getRemoteDeviceId() {
  let list = dmClass.getTrustedDeviceListSync();
  if (typeof (list) != 'undefined' && typeof (list.length) != 'undefined') {
    deviceList = list;
  }
  if (deviceList.length <= 0) {
    return "";
  }
  return deviceList[0].deviceId;
}

function startRemoteAbility() {
  let remoteDeviceId = getRemoteDeviceId();
  if (remoteDeviceId === "") {
    return;
  }
  let params;
  let wantValue = {
    bundleName: 'ohos.samples.distributedgraffiti',
    abilityName: 'com.example.entry.MainAbility',
    deviceId: remoteDeviceId,
    parameters: params
  };
  featureAbility.startAbility({
    want: wantValue
  }).then((data) => {
    console.info('startRemoteAbility finished, ' + JSON.stringify(data));
  });
}

function connectLocalAbility() {
  async function onConnectCallback(element, local) {
    console.log('connectLocalAbility onConnectDone local: ' + local);
    mLocal = local;
    if (mLocal == null) {
      return;
    }
    let option = new rpc.MessageOption();
    let data = new rpc.MessageParcel();
    let reply = new rpc.MessageParcel();
    data.writeRemoteObject(mainAbilityStub);
    await mLocal.sendRequest(CODE_CONNECT_LOCAL, data, reply, option);
  }

  function onDisconnectCallback(element) {
    console.log('connectLocalAbility onDisconnectDone element: ' + element);
  }

  function onFailedCallback(code) {
    console.log('connectLocalAbility onFailed errCode: ' + code);
  }

  connectedAbility = featureAbility.connectAbility(
    {
      deviceId: "",
      bundleName: "ohos.samples.distributedgraffiti",
      abilityName: "com.example.entry.ServiceAbility",
    },
    {
      onConnect: onConnectCallback,
      onDisconnect: onDisconnectCallback,
      onFailed: onFailedCallback,
    },
  );
}

function connectRemoteAbility() {
  async function onConnectCallback(element, remote) {
    console.log('connectRemoteAbility onConnectDone remote: ' + remote);
    mRemote = remote;
  }

  function onDisconnectCallback(element) {
    console.log('connectRemoteAbility onDisconnectDone element: ' + element);
  }

  function onFailedCallback(code) {
    console.log('connectRemoteAbility onFailed errCode: ' + code);
  }

  let remoteDeviceId = getRemoteDeviceId();
  if (remoteDeviceId === "") {
    return;
  }
  connectedAbility = featureAbility.connectAbility(
    {
      deviceId: remoteDeviceId,
      bundleName: "ohos.samples.distributedgraffiti",
      abilityName: "com.example.entry.ServiceAbility",
    },
    {
      onConnect: onConnectCallback,
      onDisconnect: onDisconnectCallback,
      onFailed: onFailedCallback,
    },
  );
}

async function disconnectRemoteAbility() {
  if (connectedAbility == null) {
    prompt.showToast({
      message: "disconnectRemoteAbility not connected yet"
    });
    return;
  }
  await featureAbility.disconnectAbility(connectedAbility);
  connectedAbility = null;
  prompt.showToast({
    message: "disconnectRemoteAbility disconnect done"
  });
}

@Entry
@Component
struct Index {
  @State x: number = 0;
  @State y: number = 0;
  @State touchType: number = 0;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  private aboutToAppear() : void {
    requestPermission();
    getDm();
    connectLocalAbility();
    mainAbilityStub.registerCallback((x, y, touchType) => {
      this.drawFromRemote(x, y, touchType);
    });
  }

  private aboutToDisappear() : void {
    disconnectRemoteAbility();
  }

  public async drawToRemote(x : number, y : number, touchType: number) : Promise<void> {
    if (mRemote == null) {
      console.info('mRemote is null, no need to remote');
      return;
    }
    let option = new rpc.MessageOption();
    let data = new rpc.MessageParcel();
    let reply = new rpc.MessageParcel();
    data.writeInt(x);
    data.writeInt(y);
    data.writeInt(touchType);
    await mRemote.sendRequest(CODE_CONNECT_REMOTE, data, reply, option);
  }

  public async drawFromRemote(x : number, y : number, touchType: number) : Promise<void> {
    this.x = x;
    this.y = y;
    this.touchType = touchType;
    if(this.touchType == TouchType.Down){
      await this.context.moveTo(this.x, this.y);
    }
    if(this.touchType == TouchType.Up){
      await this.context.save();
    }
    if(this.touchType == TouchType.Move){
      this.context.lineWidth = 6;
      this.context.lineJoin = 'miter';
      this.context.miterLimit = 3;
      this.context.lineJoin = "round";
      this.context.lineCap = "round";
      this.context.lineTo(this.x+1, this.y+1);
      await this.context.stroke();
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('TuYa')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)

      Button() {
        Text('start remote ability')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .type(ButtonType.Capsule)
      .margin({
        top: 2
      })
      .backgroundColor('#0D9FFB')
      .width(300).height(30)
      .onClick(() => {
        startRemoteAbility();
      })

      Button() {
        Text('connect remote ability')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .type(ButtonType.Capsule)
      .margin({
        top: 2
      })
      .backgroundColor('#0D9FFB')
      .width(300).height(30)
      .onClick(() => {
        connectRemoteAbility();
      })

      Canvas(this.context)
        .width('100%')
        .height('90%')
        .margin({
          top: 10
        })
        .backgroundColor('#c0cdcd')
        .touchable(true)
        .onTouch((event:TouchEvent) => {
          if(event.type == TouchType.Down){
            this.context.moveTo(event.touches[0].x, event.touches[0].y);
            this.drawToRemote(event.touches[0].x, event.touches[0].y, TouchType.Down);
          }
          if(event.type == TouchType.Up){
            this.context.save();
            this.drawToRemote(0, 0, TouchType.Up);
          }
          if(event.type == TouchType.Move){
            this.context.lineWidth = 6;
            this.context.lineJoin = 'miter';
            this.context.miterLimit = 3;
            this.context.lineJoin = "round";
            this.context.lineCap = "round";
            this.context.lineTo(event.touches[0].x+1, event.touches[0].y+1);
            this.context.stroke();
            this.drawToRemote(event.touches[0].x+1, event.touches[0].y+1, TouchType.Move);
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}