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

import { UiDriver } from '@ohos.uitest'
import { describe, it, expect } from '@ohos/hypium'
import Logger from '../../../main/ets/data/Logger'

const TAG: string = 'AppTest'

export default function AppTest() {
  describe('appTest', function () {
    it('testClick_001', 0, async function (done) {
      let want = {
        bundleName: 'ohos.samples.sportshealthfa',
        abilityName: 'MainAbility'
      }
      await globalThis.abilityContext.startAbility(want, (err, data) => {
        expect(0).assertEqual(err.code)
        done()
      })
    })

    it('testClick_002', 0, async function () {
      Logger.info(TAG, 'SampleTest begin')

      let driver = await UiDriver.create()
      await driver.delayMs(1000)

      Logger.info(TAG, 'SampleTest end')
    })
  })
}