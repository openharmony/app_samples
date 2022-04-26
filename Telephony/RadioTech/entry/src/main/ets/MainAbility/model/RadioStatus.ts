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

import Logger from '../model/Logger'
import sim from '@ohos.telephony.sim'
import radio from '@ohos.telephony.radio'

const TAG = '[RadioStatus]'

export class RadioStatus {
    constructor() {
    }

    async getSimSpn(slotId: number) {
        const simSpn = await sim.getSimSpn(slotId)
        Logger.info(`${TAG}, getSimSpn radioTech = ${simSpn}`)
        return simSpn
    }

    async getRadioTech(slotId: number) {
        const radioTech = await radio.getRadioTech(slotId)
        Logger.info(`${TAG}, getRadioTech radioTech = ${JSON.stringify(radioTech)}`)
        return radioTech
    }

    async getSignalInformation(slotId: number) {
        const signalInformation = await radio.getSignalInformation(slotId)
        Logger.info(`${TAG}, getSignalInformation signalInformation = ${JSON.stringify(signalInformation)}`)
        if (signalInformation.length === 0) {
            return 'not available'
        } else {
            return signalInformation
        }
    }

    async getNetworkSelectionMode(slotId: number) {
        Logger.info(`${TAG}, getNetworkSelectionMode networkSelectionMode start`)
        const networkSelectionMode = await radio.getNetworkSelectionMode(slotId)
        Logger.info(`${TAG}, getNetworkSelectionMode networkSelectionMode = ${networkSelectionMode}`)
        return networkSelectionMode
    }

    async getISOCountryCodeForNetwork(slotId: number) {
        const iSOCountryCode = await radio.getISOCountryCodeForNetwork(slotId)
        Logger.info(`${TAG}, getISOCountryCodeForNetwork iSOCountryCode = ${iSOCountryCode}`)
        if (typeof (iSOCountryCode) == `undefined`) {
            return 'not available'
        } else {
            return iSOCountryCode
        }
    }

    async getNetworkState() {
        const data = await radio.getNetworkState()
        Logger.info(`${TAG}, getNetworkState data = ${JSON.stringify(data)}`)
        if (typeof (JSON.stringify(data)) == `undefined`) {
            return 'not available'
        } else {
            const networkState: string = `longOperatorName:${JSON.stringify(data.longOperatorName)}\n` +
            `shortOperatorName:${JSON.stringify(data.shortOperatorName)}\n` +
            `plmnNumeric:${JSON.stringify(data.plmnNumeric)}\n` +
            `isRoaming:${JSON.stringify(data.isRoaming)}\n` +
            `regState:${JSON.stringify(data.regState)}\n` +
            `nsaState:${JSON.stringify(data.nsaState)}\n` +
            `isCaActive:${JSON.stringify(data.isCaActive)}\n` +
            `isEmergency:${JSON.stringify(data.isEmergency)}\n`
            Logger.info(`${TAG}, getNetworkState networkState = ${JSON.stringify(networkState)}`)
            return networkState
        }
    }

    async getRadioOn() {
        Logger.info(`${TAG}, getRadioOn radioOn start`)
        const radioOn = await radio.isRadioOn()
        Logger.info(`${TAG}, getRadioOn radioOn = ${radioOn}`)
        return JSON.stringify(radioOn)
    }
}