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
import dataStorage from '@ohos.data.storage'
import featureAbility from '@ohos.ability.featureAbility'
import Logger from '../model/Logger'

const TAG: string = 'LiteStore'
const KEY: string = 'sync_state'

export const SyncState = {
    AutomaticSync: 'AutomaticSync',
    ManualSync: 'ManualSync'
}

class LiteStore {
    private store: dataStorage.Storage = undefined
    private key: string = ''

    constructor(key: string) {
        this.key = key
    }

    async setValue(value) {
        if (this.store === undefined) {
            await this.getStore()
        }
        Logger.info(TAG, `setValue: ${value}`)
        await this.store.put(this.key, value)
        await this.store.flush()
    }

    async getValue() {
        if (this.store === undefined) {
            await this.getStore()
        }
        let result = await this.store.get(this.key, 'ManualSync')
        Logger.info(TAG, `getValue: ${result}`)
        return result
    }

    async getStore() {
        let context = featureAbility.getContext()
        let path = await context.getFilesDir()
        this.store = await dataStorage.getStorage(path + '/mystore')
    }
}

export default new LiteStore(KEY)