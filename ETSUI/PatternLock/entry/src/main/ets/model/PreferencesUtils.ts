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
import preferences from '@ohos.data.preferences'
import Logger from '../model/Logger'

const TAG: string = '[PreferencesUtils]'
const PREFERENCES_NAME: string = 'myPreferences'
const PASSWORD_KEY: string = 'password'

class PreferencesUtils {
  private preferences: preferences.Preferences | undefined = undefined

  constructor() {
    this.preferences = undefined
    Logger.info(TAG, `constructor`)
  }

  async getPassword() {
    Logger.info(TAG, `get passworld`)
    if (this.preferences === undefined) {
      this.preferences = await preferences.getPreferences(globalThis.abilityContext, PREFERENCES_NAME)
    }
    return await this.preferences.get(PASSWORD_KEY, 'null')
  }

  async setPassword(passWorld: string) {
    Logger.info(TAG, `set passworld`)
    if (this.preferences === undefined) {
      this.preferences = await preferences.getPreferences(globalThis.abilityContext, PREFERENCES_NAME)
    }
    await this.preferences.put(PASSWORD_KEY, passWorld)
    await this.preferences.flush()
  }
}

export default new PreferencesUtils()
