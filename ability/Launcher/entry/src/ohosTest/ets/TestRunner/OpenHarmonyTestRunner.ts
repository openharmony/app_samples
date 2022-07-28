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

import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import TestRunner from '@ohos.application.testRunner'
import Logger from '../../../../../base/src/main/ets/default/utils/Logger'

var abilityDelegator = undefined
var abilityDelegatorArguments = undefined
const TAG: string = 'OpenHarmonyTestRunner'

function translateParamsToString(parameters) {
  const keySet = new Set([
    '-s class', '-s notClass', '-s suite', '-s it',
    '-s level', '-s testType', '-s size', '-s timeout',
    '-s dryRun'
  ])
  let targetParams = '';
  for (const key in parameters) {
    if (keySet.has(key)) {
      targetParams = `${targetParams} ${key} ${parameters[key]}`
    }
  }
  return targetParams.trim()
}

async function onAbilityCreateCallback() {
  Logger.info(TAG, 'onAbilityCreateCallback')
}

async function addAbilityMonitorCallback(err: any) {
  Logger.info(TAG, `addAbilityMonitorCallback: ${JSON.stringify(err)}`)
}

export default class OpenHarmonyTestRunner implements TestRunner {
  constructor() {
  }

  onPrepare() {
    Logger.info(TAG, 'OpenHarmonyTestRunner OnPrepare')
  }

  async onRun() {
    Logger.info(TAG, 'OpenHarmonyTestRunner onRun run')
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments()
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
    var testAbilityName = abilityDelegatorArguments.bundleName + '.TestAbility'
    let lMonitor = {
      abilityName: testAbilityName,
      onAbilityCreate: onAbilityCreateCallback,
    };
    abilityDelegator.addAbilityMonitor(lMonitor, addAbilityMonitorCallback)
    var cmd = 'aa start -d 0 -a TestAbility' + ' -b ' + abilityDelegatorArguments.bundleName
    cmd += ' ' + translateParamsToString(abilityDelegatorArguments.parameters)
    var debug = abilityDelegatorArguments.parameters["-D"]
    if (debug == 'true') {
      cmd += ' -D'
    }
    Logger.info(TAG, `cmd : ${cmd}`)
    abilityDelegator.executeShellCommand(cmd,
      (err: any, d: any) => {
        console.info('executeShellCommand : err : ' + JSON.stringify(err));
        console.info('executeShellCommand : data : ' + d.stdResult);
        console.info('executeShellCommand : data : ' + d.exitCode);
      })
    Logger.info(TAG, 'OpenHarmonyTestRunner onRun end')
  }
}