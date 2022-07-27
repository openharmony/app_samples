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

/**
 * common app info
 */
export default class AppItemInfo {
  /**
   * Indicates app id.
   */
  appId: string | undefined

  /**
   * Indicates app name.
   */
  appName: string | undefined

  /**
   * Indicates appIconId.
   */
  appIconId: number | undefined

  /**
   * Indicates appLabelId.
   */
  appLabelId: string | undefined

  /**
   * Indicates bundleName.
   */
  bundleName: string | undefined

  /**
   * Indicates abilityName.
   */
  abilityName: string | undefined

  /**
   * Indicates is system App.
   */
  isSystemApp: boolean | undefined

  /**
   * Indicates is uninstallAble.
   */
  isUninstallAble: boolean | undefined

  /**
   * badge number.
   */
  badgeNumber: number | undefined

  /**
   * Indicates is moduleName.
   */
  moduleName: string | undefined

  /**
 * GridLayoutItemInfo: type  0:app  1:card  3:bigfolder
 */
  typeId: number | undefined

  /**
   * GridLayoutItemInfo: area
   */
  area: number[] | undefined

  /**
   * GridLayoutItemInfo: page
   */
  page: number | undefined

  /**
   * GridLayoutItemInfo: column of positons
   */
  column: number | undefined

  /**
   * GridLayoutItemInfo: row of positons
   */
  row: number | undefined
}