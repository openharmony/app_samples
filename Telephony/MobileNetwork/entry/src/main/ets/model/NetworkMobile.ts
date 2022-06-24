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

import Logger from './Logger'
import data from '@ohos.telephony.data'

const TAG: string = '[NetworkMobile]'
const DATA_FLOW_TYPE_RESOURCES = {
    [data.DataFlowType.DATA_FLOW_TYPE_NONE]: $r('app.string.none'),
    [data.DataFlowType.DATA_FLOW_TYPE_DOWN]: $r('app.string.down'),
    [data.DataFlowType.DATA_FLOW_TYPE_UP]: $r('app.string.up'),
    [data.DataFlowType.DATA_FLOW_TYPE_UP_DOWN]: $r('app.string.upDown'),
    [data.DataFlowType.DATA_FLOW_TYPE_DORMANT]: $r('app.string.dormant'),
}
const DATA_STATE_RESOURCES = {
    [data.DataConnectState.DATA_STATE_UNKNOWN]: $r('app.string.unknown'),
    [data.DataConnectState.DATA_STATE_DISCONNECTED]: $r('app.string.disconnect'),
    [data.DataConnectState.DATA_STATE_CONNECTING]: $r('app.string.connecting'),
    [data.DataConnectState.DATA_STATE_CONNECTED]: $r('app.string.connect'),
    [data.DataConnectState.DATA_STATE_SUSPENDED]: $r('app.string.suspended'),
}


export class NetworkMobile {
    async getDefaultCellularDataSlotId() {
        let slotId = await data.getDefaultCellularDataSlotId()
        Logger.info(TAG, `getDefaultCellularDataSlotId slotId = ${slotId}`)
        return slotId
    }

    async getCellularDataFlowType() {
        let dataFlowTypeResult = await data.getCellularDataFlowType()
        Logger.info(TAG, `getCellularDataFlowType dataFlowTypeResult = ${dataFlowTypeResult}`)
        let result = DATA_FLOW_TYPE_RESOURCES[dataFlowTypeResult]
        Logger.info(TAG, `getCellularDataFlowType dataFlowType = ${JSON.stringify(result)}`)
        return result
    }

    async getCellularDataState() {
        let dataStateResult = await data.getCellularDataState()
        Logger.info(TAG, `getCellularDataState dataStateResult = ${dataStateResult}`)
        let result = DATA_STATE_RESOURCES[dataStateResult]
        Logger.info(TAG, `getCellularDataState dataState = ${JSON.stringify(result)}`)
        return result
    }

    async isCellularDataEnabled() {
        let dataEnabled = await data.isCellularDataEnabled()
        Logger.info(TAG, `isCellularDataEnabled dataEnabled = ${dataEnabled}`)
        return dataEnabled
    }

    async isCellularDataRoamingEnabled(slotId: number) {
        let dataRoamingEnabled = await data.isCellularDataRoamingEnabled(slotId)
        Logger.info(TAG, `isCellularDataRoamingEnabled dataRoamingEnabled = ${dataRoamingEnabled}`)
        return dataRoamingEnabled
    }
}