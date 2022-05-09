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
import dataStorage from '@ohos.data.storage';
import featureAbility from '@ohos.ability.featureAbility';

@Entry
@Component
struct SwitchControl {
  build() {
  }
}

export function readFile(key) {
  let context = featureAbility.getContext()
  return context.getFilesDir().then((path) => {
    let promise = dataStorage.getStorage(`${path}/mystore`)
    return promise.then((storage) => {
      let readText = storage.get(key, 'default')
      return readText.then((value) => {
        return new Promise((resolve) => {
          return resolve(value)
        })
      })
    })
  })
}

export function writeFile({ key="", val="" }) {
  // 读取文件
  let context = featureAbility.getContext()
  context.getFilesDir().then((path) => {
    // 获取实例
    let storage = dataStorage.getStorageSync(`${path}/mystore`)
    // 将数据写入
    storage.putSync(key, val)
    // 持久化储存
    storage.flushSync()
  })
}