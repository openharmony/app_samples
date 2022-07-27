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

import launcherBundleMgr from '@ohos.bundle.innerBundleManager'
import osAccount from '@ohos.account.osAccount'
import AppItemInfo from '../bean/AppItemInfo'
import CheckEmptyUtils from '../utils/CheckEmptyUtils'
import Logger from '../utils/Logger'
import ResourceManager from './ResourceManager'

const TAG: string = 'LauncherAbilityManager'

/**
 * Wrapper class for innerBundleManager and formManager interfaces.
 */
export default class LauncherAbilityManager {
  private static readonly BUNDLE_STATUS_CHANGE_KEY = 'BundleStatusChange'
  private readonly mAppMap = new Map<string, AppItemInfo>()
  private mResourceManager: ResourceManager = undefined
  private mUserId: number = 100
  private context: any = undefined

  constructor(context) {
    this.context = context
    this.mResourceManager = ResourceManager.getInstance(context)
    const osAccountManager = osAccount.getAccountManager()
    osAccountManager.getOsAccountLocalIdFromProcess((err, localId) => {
      Logger.debug(TAG, `getOsAccountLocalIdFromProcess localId ${localId}`)
      this.mUserId = localId
    })
  }

  /**
  * Get the application data model object.
  *
  * @return {object} application data model singleton
  */
  static getInstance(context): LauncherAbilityManager {
    if (globalThis.launcherAbilityManager === null || globalThis.launcherAbilityManager === undefined) {
      globalThis.launcherAbilityManager = new LauncherAbilityManager(context)
    }
    return globalThis.launcherAbilityManager
  }

  /**
   * get all app List info from BMS
   *
   *  @return 应用的入口Ability信息列表
   */
  async getLauncherAbilityList(): Promise<AppItemInfo[]> {
    Logger.info(TAG, 'getLauncherAbilityList begin')
    let abilityList = await launcherBundleMgr.getAllLauncherAbilityInfos(this.mUserId)
    const appItemInfoList = new Array<AppItemInfo>()
    if (CheckEmptyUtils.isEmpty(abilityList)) {
      Logger.info(TAG, 'getLauncherAbilityList Empty')
      return appItemInfoList
    }
    for (let i = 0; i < abilityList.length; i++) {
      let appItem = await this.transToAppItemInfo(abilityList[i])
      appItemInfoList.push(appItem)
    }
    return appItemInfoList
  }

  /**
   * get AppItemInfo from BMS with bundleName
   * @params bundleName
   * @return AppItemInfo
   */
  async getAppInfoByBundleName(bundleName: string): Promise<AppItemInfo | undefined> {
    let appItemInfo: AppItemInfo | undefined = undefined
    // get from cache
    if (this.mAppMap != null && this.mAppMap.has(bundleName)) {
      appItemInfo = this.mAppMap.get(bundleName)
    }
    if (appItemInfo != undefined) {
      Logger.info(TAG, `getAppInfoByBundleName from cache: ${JSON.stringify(appItemInfo)}`)
      return appItemInfo
    }
    // get from system
    let abilityInfos = await launcherBundleMgr.getLauncherAbilityInfos(bundleName, this.mUserId)
    if (abilityInfos == undefined || abilityInfos.length == 0) {
      Logger.info(TAG, `${bundleName} has no launcher ability`)
      return undefined
    }
    let appInfo = abilityInfos[0]
    const data = await this.transToAppItemInfo(appInfo)
    Logger.info(TAG, `getAppInfoByBundleName from BMS: ${JSON.stringify(data)}`)
    return data
  }

  private async transToAppItemInfo(info): Promise<AppItemInfo> {
    const appItemInfo = new AppItemInfo()
    appItemInfo.appName = await this.mResourceManager.getAppNameSync(
      info.labelId, info.elementName.bundleName, info.applicationInfo.label
    )
    appItemInfo.isSystemApp = info.applicationInfo.systemApp
    appItemInfo.isUninstallAble = info.applicationInfo.removable
    appItemInfo.appIconId = info.iconId
    appItemInfo.appLabelId = info.labelId
    appItemInfo.bundleName = info.elementName.bundleName
    appItemInfo.abilityName = info.elementName.abilityName
    await this.mResourceManager.updateIconCache(appItemInfo.appIconId, appItemInfo.bundleName)
    this.mAppMap.set(appItemInfo.bundleName, appItemInfo)
    return appItemInfo
  }


  /**
   * 启动应用
   *
   * @params paramAbilityName Ability名
   * @params paramBundleName 应用包名
   */
  startLauncherAbility(paramAbilityName, paramBundleName) {
    Logger.info(TAG, `startApplication abilityName: ${paramAbilityName}, bundleName: ${paramBundleName}`)
    this.context.startAbility({
      bundleName: paramBundleName,
      abilityName: paramAbilityName
    }).then(() => {
      Logger.info(TAG, 'startApplication promise success')
    }, (err) => {
      Logger.error(TAG, `startApplication promise error: ${JSON.stringify(err)}`)
    })
  }
}