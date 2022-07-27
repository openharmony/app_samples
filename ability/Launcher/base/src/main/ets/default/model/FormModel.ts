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

import CardItemInfo from '../bean/CardItemInfo'
import FormManager from '../manager/FormManager'
import Logger from '../utils/Logger'

const TAG = 'FormModel'

/**
 * form model.
 */
class FormModel {
  private readonly mAppItemFormInfoMap = new Map<string, CardItemInfo[]>()

  /**
   * Get the form info list of all ohos applications on the device.
   *
   * @return {array} allFormList
   */
  async getAllFormsInfo() {
    Logger.info(TAG, 'getAllFormsInfo start')
    const allFormList = await FormManager.getAllFormsInfo()
    return allFormList
  }

  /**
   * Get the form info list of all ohos applications on the device by bundle name.
   *
   * @param {array} bundleName
   * @param {function | undefined} callback
   *
   * @return {array} currentBundleFormsInfo
   */
  async getFormsInfoByBundleName(bundleName: string, callback?) {
    Logger.info(TAG, `getFormsInfoByBundleName bundleName: ${bundleName}`)
    let currentBundleFormsInfo: Array<CardItemInfo> = new Array<CardItemInfo>()
    await FormManager.getFormsInfoByApp(bundleName)
      .then(bundleFormsInfo => {
        Logger.info(TAG, `getFormsInfoByBundleName bundleFormsInfo: ${JSON.stringify(bundleFormsInfo)}`)
        currentBundleFormsInfo = bundleFormsInfo
        if (callback != undefined) {
          callback(bundleName, bundleFormsInfo)
        }
      })
      .catch(err => {
        Logger.debug(TAG, `getFormsInfoByBundleName err: ${JSON.stringify(err)}`)
      })
    AppStorage.SetOrCreate('formMgrItem', currentBundleFormsInfo)
    return currentBundleFormsInfo
  }

  /**
   * Set app item form info into map.
   *
   * @param {string} bundleName
   * @param {array} appItemFormInfo
   */
  setAppItemFormInfo(bundleName: string, appItemFormInfo: CardItemInfo[]): void {
    this.mAppItemFormInfoMap.set(bundleName, appItemFormInfo)
  }

  /**
   * Get app item form info from map.
   *
   * @param {string} bundleName
   *
   * @return {array | undefined} mAppItemFormInfoMap
   */
  public getAppItemFormInfo(bundleName: string): CardItemInfo[] | undefined {
    Logger.info(TAG, `getAppItemFormInfo bundleName: ${bundleName},
      appItemFormInfo: ${JSON.stringify(this.mAppItemFormInfoMap.get(bundleName))}`)
    return this.mAppItemFormInfoMap.get(bundleName)
  }


  /**
   * Update app item form info into map.
   *
   * @param {string} bundleName
   * @param {string | undefined} eventType
   */
  public updateAppItemFormInfo(bundleName: string): void {
    this.getFormsInfoByBundleName(bundleName, this.setAppItemFormInfo.bind(this))
  }
}

export default new FormModel()