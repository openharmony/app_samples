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
import appAccount from '@ohos.account.appAccount'

const TAG: string = '[AccountModel]'
const app: appAccount.AppAccountManager = appAccount.createAppAccountManager()

export class AccountModel {
    async addAccount(username: string) {
        await app.addAccount(username)
        Logger.info(TAG, `addAccount success.`)
        return
    }

    async deleteAccount(username: string) {
        await app.deleteAccount(username)
        Logger.info(TAG, `deleteAccount username: ${username}`)
        return
    }

    async setAccountCredential(username: string, credentialType: string, credential: string) {
        await app.setAccountCredential(username, credentialType, credential)
        Logger.info(TAG, `setAccountCredential username: ${username} credentialType: ${credentialType},
    credential: ${credential}}`)
        return
    }

    async setAccountExtraInfo(name: string, extraInfo: string) {
        await app.setAccountExtraInfo(name, extraInfo)
        Logger.info(TAG, `setAccountExtraInfo name: ${name} extraInfo: ${extraInfo}`)
        return
    }

    async setAssociatedData(name: string, key: string, value: string) {
        await app.setAssociatedData(name, key, value)
        Logger.info(TAG, `setAssociatedData name: ${name} key: ${key} value: ${value}`)
        return
    }

    async getAccountCredential(name: string, credentialType: string) {
        let result = await app.getAccountCredential(name, credentialType)
        Logger.info(TAG, `getAccountCredential name: ${name} credentialType: ${credentialType} result: ${result}`)
        return result
    }

    async getAccountExtraInfo(name: string) {
        let result = await app.getAccountExtraInfo(name)
        Logger.info(TAG, `getAccountExtraInfo name: ${name} result: ${result}`)
        return result
    }

    async getAssociatedData(name: string, key: string) {
        let result = await app.getAssociatedData(name, key)
        Logger.info(TAG, `getAssociatedData name: ${name} key: ${key} result: ${result}`)
        return result
    }
}
