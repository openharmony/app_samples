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

import { UiDriver, BY } from '@ohos.uitest'
import { describe, it, expect } from '@ohos/hypium'
import Logger from '../../../../../base/src/main/ets/default/utils/Logger'

const TAG: string = 'AppTest'

export default function AppTest() {
  describe('appTest', function () {
    it('testClick_001', 0, async function (done) {
      Logger.info(TAG, 'testClick_001 begin')
      let want = {
        bundleName: 'ohos.samples.launcher',
        abilityName: 'MainAbility'
      }
      await globalThis.abilityContext.startServiceExtensionAbility(want, (err) => {
        expect(0).assertEqual(err.code)
        done()
      })
    })

    it('testClick_002', 0, async function () {
      Logger.info(TAG, 'testClick_002 begin')

      let driver = await UiDriver.create()
      await driver.assertComponentExist(BY.key('Clock'))
      let debug = await driver.findComponent(BY.key('Clock'))
      await debug.click()
      await driver.delayMs(1000)
      Logger.info(TAG, 'testClick_002_01')

      await driver.click(200, 1200)
      await driver.delayMs(1000)
      Logger.info(TAG, 'testClick_002_02')

      Logger.info(TAG, 'testClick_002 end')
    })

    it('testClick_003', 0, async function () {
      Logger.info(TAG, 'testClick_003 begin')

      let driver = await UiDriver.create()
      await driver.assertComponentExist(BY.key('图库'))
      let debug = await driver.findComponent(BY.key('图库'))
      await debug.longClick()
      await driver.delayMs(1000)
      Logger.info(TAG, 'testClick_003_01')

      await driver.assertComponentExist(BY.key('服务卡片'))
      let debugForm = await driver.findComponent(BY.key('服务卡片'))
      await debugForm.click()

      await driver.click(378, 1036)
      await driver.delayMs(1000)
      Logger.info(TAG, 'testClick_002_03')

      Logger.info(TAG, 'testClick_003 end')
    })
  })
}