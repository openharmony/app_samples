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
import ServiceExtension from '@ohos.application.ServiceExtensionAbility'
import Log from '../model/Log'

let TAG: string = 'service->'

class ServiceExtAbility extends ServiceExtension {
  onCreate(want) {
    Log.showInfo(TAG, 'onCreate want: ' + want.abilityName);
  }

  onRequest(want, startId) {
    Log.showInfo(TAG, 'onRequest want: ' + want.abilityName + ',startId: ' + startId);
  }

  onConnect(want) {
    Log.showInfo(TAG, 'onConnect want: ' + want.abilityName);
    return null;
  }

  onDisconnect(want) {
    Log.showInfo(TAG, 'onDisconnect want: ' + want.abilityName);
  }

  onDestroy() {
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility