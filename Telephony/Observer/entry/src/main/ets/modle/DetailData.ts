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
import radio from '@ohos.telephony.radio'
import call from '@ohos.telephony.call'
import data from '@ohos.telephony.data'
import observer from '@ohos.telephony.observer'

export default class DetailData {
  //网络注册状态
  public networkState: radio.NetworkState
  //网络信号强度信息
  public signalInformation: Array<radio.SignalInformation>
  //通话状态
  public callState: call.CallState
  //电话号码
  public callNumber: string
  //蜂窝数据链路连接状态
  public dataConnectState: data.DataConnectState
  //无线接入技术
  public ratType: radio.RadioTechnology
  //蜂窝数据流类型
  public dataFlowType: data.DataFlowType
  //SIM卡类型和状态
  public simStateData: observer.SimStateData

  constructor() {
    this.networkState = undefined
    this.signalInformation = undefined
    this.callState = undefined
    this.callNumber = undefined
    this.dataConnectState = undefined
    this.ratType = undefined
    this.dataFlowType = undefined
    this.simStateData = undefined
  }
}
