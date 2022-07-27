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

import CheckEmptyUtils from '../utils/CheckEmptyUtils'
import Logger from '../utils/Logger'
import LruCache from './LruCache'

const KEY_ICON = 'icon'
const KEY_NAME = 'name'
const TAG = 'ResourceManager'

/**
 * Wrapper class for resourceManager interfaces.
 */
export default class ResourceManager {
  private readonly memoryCache = new LruCache()
  private context: any = undefined

  constructor(context) {
    this.context = context
  }

  /**
  * Get the application data model object.
  *
  * @return {object} application data model singleton
  */
  static getInstance(context): ResourceManager {
    if (globalThis.resourceManager === null || globalThis.resourceManager === undefined) {
      globalThis.resourceManager = new ResourceManager(context)
    }
    return globalThis.resourceManager
  }

  private getCacheFromMemory(cacheKey: string, cacheType: string) {
    const cache = this.memoryCache.getCache(cacheKey)
    if (cache == undefined || cache == null || cache == '' || cache === -1) {
      return null
    } else if (cache[cacheType] == undefined || cache[cacheType] == null || cache[cacheType] == '') {
      return null
    } else {
      return cache[cacheType]
    }
  }

  private setCacheToMemory(cacheKey: string, cacheType: string, value: object | string): void {
    let cache = this.memoryCache.getCache(cacheKey)
    if (cache == undefined || cache == null || cache == '' || cache === -1) {
      cache = {}
      cache[cacheType] = value
    } else {
      cache[cacheType] = value
    }
    this.memoryCache.putCache(cacheKey, cache)
  }

  getCachedAppIcon(iconId: number, bundleName: string) {
    const cacheKey = `${iconId}${bundleName}`
    return this.getCacheFromMemory(cacheKey, KEY_ICON)
  }

  setAppResourceCache(cacheKey: string, cacheType: string, value: object | string): void {
    this.setCacheToMemory(cacheKey, cacheType, value)
  }

  deleteAppResourceCache(cacheKey: string, cacheType: string): void {
    this.memoryCache.remove(cacheKey)
  }

  async updateIconCache(iconId: number, bundleName: string): Promise<void> {
    try {
      let cacheKey = `${iconId}${bundleName}`
      const iconBase64 = this.getCacheFromMemory(cacheKey, KEY_ICON)
      if (!CheckEmptyUtils.isEmpty(iconBase64)) {
        return
      }
      const bundleContext = this.context.createBundleContext(bundleName)
      if (bundleContext == null) {
        return
      }
      await bundleContext.resourceManager.getMediaBase64(iconId).then((value) => {
        if (value != null) {
          this.setAppResourceCache(cacheKey, KEY_ICON, value)
        }
      })
    } catch (error) {
      Logger.error(TAG, `updateIconCache error ${error}`)
    }
  }

  getAppIconWithCache(iconId: number, bundleName: string, callback: Function, defaultAppIcon: string) {
    if (CheckEmptyUtils.isEmpty(iconId) || iconId <= 0) {
      Logger.info(TAG, 'getAppIconWithCache defaultAppIcon')
      callback(defaultAppIcon)
    } else {
      const cacheKey = iconId + bundleName
      const iconBase64 = this.getCacheFromMemory(cacheKey, KEY_ICON)
      if (CheckEmptyUtils.isEmpty(iconBase64)) {
        if (this.isResourceManagerEmpty()) {
          Logger.error(TAG, 'getAppIconWithCache resourceManager is empty')
          callback(defaultAppIcon)
          return
        }
        try {
          const bundleContext = this.context.createBundleContext(bundleName)
          bundleContext.resourceManager.getMediaBase64(iconId).then((value: string) => {
            Logger.info(TAG, `getAppIconWithCache getMediaBase64 success`)
            if (value != null) {
              this.setAppResourceCache(cacheKey, KEY_ICON, value)
              callback(value)
            }
            else {
              callback(defaultAppIcon)
            }
          })
        } catch (error) {
          Logger.error(TAG, `getAppIconWithCache error ${error}`)
          callback(defaultAppIcon)
        }
      } else {
        callback(iconBase64)
      }
    }
  }

  async getAppNameSync(labelId: number, bundleName: string, appName: string) {
    if (CheckEmptyUtils.isEmpty(labelId) || labelId <= 0 || CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      Logger.info(TAG, `getAppNameSync param empty! appName: ${appName}`)
      return appName
    } else {
      const cacheKey = labelId + bundleName
      Logger.info(TAG, `getAppNameSync getResourceManager cacheKey: ${cacheKey}`)
      if (this.isResourceManagerEmpty()) {
        Logger.info(TAG, 'getAppNameSync resourceManager is empty')
        return appName
      }
      const bundleContext = this.context.createBundleContext(bundleName)
      let resMgrName  = await bundleContext.resourceManager.getString(labelId)
      Logger.info(TAG, `getAppNameSync resMgrName: ${resMgrName}`)
      if (resMgrName != null) {
        return resMgrName
      } else {
        return appName
      }
    }
  }

  getAppNameWithCache(labelId: number, bundleName: string, appName: string, callback) {
    if (CheckEmptyUtils.isEmpty(labelId) || labelId <= 0) {
      Logger.info(TAG, `getAppNameWithCache ResourceManager getAppName callback: ${appName}`)
      callback(appName)
    } else {
      const cacheKey = labelId + bundleName
      const name = this.getCacheFromMemory(cacheKey, KEY_ICON)
      if (CheckEmptyUtils.isEmpty(name)) {
        if (this.isResourceManagerEmpty()) {
          Logger.info(TAG, 'getAppNameWithCache resourceManager is empty')
          return appName
        }
        try {
          const bundleContext = this.context.createBundleContext(bundleName)
          bundleContext.resourceManager.getString(labelId).then((value) => {
            if (CheckEmptyUtils.checkStrIsEmpty(value)) {
              Logger.info(TAG, `getAppNameWithCache getAppName getString ERROR! value is empty id ${labelId}`)
              callback(appName)
            } else {
              this.setAppResourceCache(cacheKey, KEY_NAME, value)
              callback(value)
            }
          })
        } catch (err) {
          Logger.error(TAG, `getAppNameWithCache error: ${JSON.stringify(err)}`)
          callback(appName)
        }
      } else {
        callback(name)
      }
    }
  }

  /**
     * Get app resource cache.
     *
     * @param {string} cacheKey
     * @param {string} cacheType
     */
  getAppResourceCache(cacheKey, cacheType) {
    return this.getCacheFromMemory(cacheKey, cacheType)
  }

  /**
   * get string by resource.id.
   *
   * @param {number} resource.id
   * @param {function} callback(value)
   */
  getStringById(resId: number, callback: (value: string) => void): void {
    if (this.isResourceManagerEmpty()) {
      Logger.info(TAG, 'resourceManager is empty')
      callback('')
      return
    }
    try {
      this.context.resourceManager.getString(resId).then((value) => {
        if (CheckEmptyUtils.checkStrIsEmpty(value)) {
          Logger.info(TAG, 'getStringById ERROR! value is empty:' + resId)
        }
        callback(value)
      })
    } catch (err) {
      Logger.error(TAG, `getStringById error: ${JSON.stringify(err)}`)
      callback('')
    }
  }

  private isResourceManagerEmpty(): boolean {
    return CheckEmptyUtils.isEmpty(this.context)
    || CheckEmptyUtils.isEmpty(this.context.resourceManager)
  }

  async getStringByResource(res: Resource): Promise<string> {
    const json = JSON.parse(JSON.stringify(res))
    const id = json.id
    return await this.getStringByIdSync(id)
  }

  /**
   * get string by resource.id.
   *
   * @param {number} resource.id
   * @return {string} resource name
   */
  async getStringByIdSync(resId: number): Promise<string> {
    let resMgrName = ''
    if (resId <= 0) {
      Logger.info(TAG, `getStringByIdSync resId: ${resId}`)
      return resMgrName
    } else {
      if (this.isResourceManagerEmpty()) {
        Logger.info(TAG, 'getStringByIdSync resourceManager is empty')
        return resMgrName
      }
      try {
        resMgrName = await this.context.resourceManager.getString(resId)
      } catch (err) {
        Logger.error(TAG, `getStringByIdSync error: ${JSON.stringify(err)}`)
      }
      Logger.info(TAG, `getStringByIdSync resMgrName: ${resMgrName}`)
      return resMgrName
    }
  }
}