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
import DetailData from '../modle/DetailData'
import router from '@ohos.router'
import Logger from '../modle/Logger'

const TAG: string = 'Detail'

@Entry
@Component
export struct Detail {
  @State detailData?: DetailData = new DetailData()

  aboutToAppear() {
    this.detailData = <DetailData> router.getParams()['detailData']
    Logger.info(TAG, `this.detailData = ${JSON.stringify(this.detailData)}`)
  }

  regState(regState) {
    switch (regState) {
      case 0:
        return $r('app.string.REG_STATE_NO_SERVICE')
        break
      case 1:
        return $r('app.string.REG_STATE_IN_SERVICE')
        break
      case 2:
        return $r('app.string.REG_STATE_EMERGENCY_CALL_ONLY')
        break
      case 3:
        return $r('app.string.REG_STATE_POWER_OFF')
        break
      default:
        return 'NA'
        break
    }
  }

  radioTechnology(radioTechnology) {
    switch (radioTechnology) {
      case 0:
        return $r('app.string.RADIO_TECHNOLOGY_UNKNOWN')
        break
      case 1:
        return $r('app.string.RADIO_TECHNOLOGY_GSM')
        break
      case 2:
        return $r('app.string.RADIO_TECHNOLOGY_1XRTT')
        break
      case 3:
        return $r('app.string.RADIO_TECHNOLOGY_WCDMA')
        break
      case 4:
        return $r('app.string.RADIO_TECHNOLOGY_HSPA')
        break
      case 5:
        return $r('app.string.RADIO_TECHNOLOGY_HSPAP')
        break
      case 6:
        return $r('app.string.RADIO_TECHNOLOGY_TD_SCDMA')
        break
      case 7:
        return $r('app.string.RADIO_TECHNOLOGY_EVDO')
        break
      case 8:
        return $r('app.string.RADIO_TECHNOLOGY_EHRPD')
        break
      case 9:
        return $r('app.string.RADIO_TECHNOLOGY_LTE')
        break
      case 10:
        return $r('app.string.RADIO_TECHNOLOGY_LTE_CA')
        break
      case 11:
        return $r('app.string.RADIO_TECHNOLOGY_IWLAN')
        break
      case 12:
        return $r('app.string.RADIO_TECHNOLOGY_NR')
        break
      default:
        return 'NA'
        break
    }
  }

  nsaState(nsaState) {
    switch (nsaState) {
      case 1:
        return $r('app.string.NSA_STATE_NOT_SUPPORT')
        break
      case 2:
        return $r('app.string.NSA_STATE_NO_DETECT')
        break
      case 3:
        return $r('app.string.NSA_STATE_CONNECTED_DETECT')
        break
      case 4:
        return $r('app.string.NSA_STATE_IDLE_DETECT')
        break
      case 5:
        return $r('app.string.NSA_STATE_DUAL_CONNECTED')
        break
      case 6:
        return $r('app.string.NSA_STATE_SA_ATTACHED')
        break
      default:
        return 'NA'
        break
    }
  }

  networkType(networkType) {
    switch (networkType) {
      case 0:
        return $r('app.string.NETWORK_TYPE_UNKNOWN')
        break
      case 1:
        return $r('app.string.NETWORK_TYPE_GSM')
        break
      case 2:
        return $r('app.string.NETWORK_TYPE_CDMA')
        break
      case 3:
        return $r('app.string.NETWORK_TYPE_WCDMA')
        break
      case 4:
        return $r('app.string.NETWORK_TYPE_TDSCDMA')
        break
      case 5:
        return $r('app.string.NETWORK_TYPE_LTE')
        break
      case 6:
        return $r('app.string.NETWORK_TYPE_NR')
        break
      default:
        return 'NA'
        break
    }
  }

  callState(callState) {
    switch (callState) {
      case -1:
        return $r('app.string.CALL_STATE_UNKNOWN')
        break
      case 0:
        return $r('app.string.CALL_STATE_IDLE')
        break
      case 1:
        return $r('app.string.CALL_STATE_RINGING')
        break
      case 2:
        return $r('app.string.CALL_STATE_OFFHOOK')
        break
      default:
        return 'NA'
        break
    }
  }

  dataConnectState(dataConnectState) {
    switch (dataConnectState) {
      case -1:
        return $r('app.string.DATA_STATE_UNKNOWN')
        break
      case 0:
        return $r('app.string.DATA_STATE_DISCONNECTED')
        break
      case 1:
        return $r('app.string.DATA_STATE_CONNECTING')
        break
      case 2:
        return $r('app.string.DATA_STATE_CONNECTED')
        break
      case 3:
        return $r('app.string.DATA_STATE_SUSPENDED')
        break
      default:
        return 'NA'
        break
    }
  }

  dataFlowType(dataFlowType) {
    switch (dataFlowType) {
      case 0:
        return $r('app.string.DATA_FLOW_TYPE_NONE')
        break
      case 1:
        return $r('app.string.DATA_FLOW_TYPE_DOWN')
        break
      case 2:
        return $r('app.string.DATA_FLOW_TYPE_UP')
        break
      case 3:
        return $r('app.string.DATA_FLOW_TYPE_UP_DOWN')
        break
      case 4:
        return $r('app.string.DATA_FLOW_TYPE_DORMANT')
        break
      default:
        return 'NA'
        break
    }
  }

  cardType(cardType) {
    switch (cardType) {
      case -1:
        return $r('app.string.UNKNOWN_CARD')
        break
      case 10:
        return $r('app.string.SINGLE_MODE_SIM_CARD')
        break
      case 20:
        return $r('app.string.SINGLE_MODE_USIM_CARD')
        break
      case 30:
        return $r('app.string.SINGLE_MODE_RUIM_CARD')
        break
      case 40:
        return $r('app.string.DUAL_MODE_CG_CARD')
        break
      case 41:
        return $r('app.string.CT_NATIONAL_ROAMING_CARD')
        break
      case 42:
        return $r('app.string.CU_DUAL_MODE_CARD')
        break
      case 43:
        return $r('app.string.DUAL_MODE_TELECOM_LTE_CARD')
        break
      case 50:
        return $r('app.string.DUAL_MODE_UG_CARD')
        break
      case 60:
        return $r('app.string.SINGLE_MODE_ISIM_CARD')
        break
      default:
        return 'NA'
        break
    }
  }

  simState(simState) {
    switch (simState) {
      case 0:
        return $r('app.string.SIM_STATE_UNKNOWN')
        break
      case 1:
        return $r('app.string.SIM_STATE_NOT_PRESENT')
        break
      case 2:
        return $r('app.string.SIM_STATE_LOCKED')
        break
      case 3:
        return $r('app.string.SIM_STATE_NOT_READY')
        break
      case 4:
        return $r('app.string.SIM_STATE_READY')
        break
      case 5:
        return $r('app.string.SIM_STATE_LOADED')
        break
      default:
        return 'NA'
        break
    }
  }

  lockReason(lockReason) {
    switch (lockReason) {
      case 0:
        return $r('app.string.SIM_NONE')
        break
      case 1:
        return $r('app.string.SIM_PIN')
        break
      case 2:
        return $r('app.string.SIM_PUK')
        break
      case 3:
        return $r('app.string.SIM_PN_PIN')
        break
      case 4:
        return $r('app.string.SIM_PN_PUK')
        break
      case 5:
        return $r('app.string.SIM_PU_PIN')
        break
      case 6:
        return $r('app.string.SIM_PU_PUK')
        break
      case 7:
        return $r('app.string.SIM_PP_PIN')
        break
      case 8:
        return $r('app.string.SIM_PP_PUK')
        break
      case 9:
        return $r('app.string.SIM_PC_PIN')
        break
      case 10:
        return $r('app.string.SIM_PC_PUK')
        break
      case 11:
        return $r('app.string.SIM_SIM_PIN')
        break
      case 12:
        return $r('app.string.SIM_SIM_PUK')
        break
      default:
        return 'NA'
        break
    }
  }

  isOrNo(isOrNo) {
    return isOrNo ? $r('app.string.yes') : $r('app.string.no')
  }

  @Builder textComponent(name: Resource, value: Resource | string) {
    Row() {
      Text(name)
        .fontSize(16)
      Text(value)
        .fontSize(16)
    }
    .width('100%')
    .margin({ left: 20 })
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .objectFit(ImageFit.Contain)
          .margin({ left: 20 })
          .size({ width: 30, height: 30 })
          .onClick(() => {
            router.back()
          })
        Text($r('app.string.detail'))
          .fontSize(30)
          .margin({ left: '26%' })
          .fontColor(Color.White)
      }
      .width('100%')
      .height('8%')
      .backgroundColor('#0D9FFB')

      Scroll() {
        Column() {
          Column() {
            Text($r('app.string.network_registration_status'))
              .fontSize(20)
            if (this.detailData.networkState) {
              this.textComponent($r('app.string.network_state_long_operator_name'), `${this.detailData.networkState.longOperatorName}`)
              this.textComponent($r('app.string.network_state_short_operator_name'), `${this.detailData.networkState.shortOperatorName}`)
              this.textComponent($r('app.string.plmn_numeric'), `${this.detailData.networkState.plmnNumeric}`)
              this.textComponent($r('app.string.is_roaming'), `${this.isOrNo(this.detailData.networkState.isRoaming)}`)
              this.textComponent($r('app.string.reg_state'), this.regState(this.detailData.networkState.regState))
              this.textComponent($r('app.string.cfg_tech'), `${this.detailData.networkState.cfgTech}`)
              this.textComponent($r('app.string.nsa_state'), `${this.nsaState(this.detailData.networkState.nsaState)}`)
              this.textComponent($r('app.string.is_ca_active'), `${this.detailData.networkState.isCaActive}`)
              this.textComponent($r('app.string.is_emergency'), `${this.isOrNo(this.detailData.networkState.isEmergency)}`)
            }
          }
          .margin({ top: 10, left: 20 })
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text($r('app.string.signal_information'))
              .fontSize(20)
            if (this.detailData.signalInformation) {
              ForEach(this.detailData.signalInformation, (item) => {
                this.textComponent($r('app.string.signal_type'), this.networkType(item.signalType))
                this.textComponent($r('app.string.signal_level'), `${item.signalLevel}`)
              }, item => JSON.stringify(item.signalLevel))
            }
          }
          .margin({ top: 10, left: 20 })
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text($r('app.string.call_state'))
              .fontSize(20)
            this.textComponent($r('app.string.call_state_code'), this.callState(this.detailData.callState))
            this.textComponent($r('app.string.phone_number'), `${this.detailData.callNumber}`)
          }
          .margin({ top: 10, left: 20 })
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text($r('app.string.cellular_data'))
              .fontSize(20)
            this.textComponent($r('app.string.cellular_data_connection_state'), this.dataConnectState(this.detailData.dataConnectState))
            this.textComponent($r('app.string.cellular_data_flow_type'), this.dataFlowType(this.detailData.dataFlowType))
          }
          .margin({ top: 10, left: 20 })
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text($r('app.string.sim_card_status'))
              .fontSize(20)
            if (this.detailData.simStateData) {
              this.textComponent($r('app.string.card_type'), this.cardType(this.detailData.simStateData.type))
              this.textComponent($r('app.string.sim_status'), this.simState(this.detailData.simStateData.state))
              this.textComponent($r('app.string.lock_reason'), this.lockReason(this.detailData.simStateData.reason))
            }
          }
          .margin({ top: 10, left: 20 })
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .height('92%')
    }
    .width('100%')
    .height('100%')
  }
}