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
import GridLayoutInfoColumns from './GridLayoutInfoColumns'

/**
 * Item info of GridLayoutInfo item.
 */
export default class GridLayoutItemInfo {
  /**
   * GridLayoutItemInfo: id
   */
  id: number | undefined

  /**
   * GridLayoutItemInfo: app_name
   */
  appName: string | undefined

  /**
   * Indicates appIconId.
   */
  appIconId: number | undefined

  /**
   * GridLayoutItemInfo: type  0:app  1:card
   */
  typeId: number | undefined

  /**
   * GridLayoutItemInfo: cardId
   */
  cardId: number | undefined

  /**
   * Indicates cardName.
   */
  cardName: string | undefined

  /**
   * GridLayoutItemInfo: badgeNumber
   */
  badgeNumber: number | undefined

  /**
   * Indicates bundleName.
   */
  bundleName: string | undefined

  /**
   * Indicates form abilityName.
   */
  abilityName: string | undefined

  /**
   * Indicates form moduleName.
  */
  moduleName: string | undefined

  /**
   * Indicates container,folder id.
   */
  container: number | undefined

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

  constructor() {
  }

  private setId(id: number) {
    this.id = id
    return this
  }

  private setAppName(appName: string) {
    this.appName = appName
    return this
  }

  private setAppIconId(appIconId: number) {
    this.appIconId = appIconId
    return this
  }

  private setTypeId(typeId: number) {
    this.typeId = typeId
    return this
  }

  private setCardId(cardId: number) {
    this.cardId = cardId
    return this
  }

  private setCardName(cardName: string) {
    this.cardName = cardName
    return this
  }

  private setBadgeNumber(badgeNumber: number) {
    this.badgeNumber = badgeNumber
    return this
  }

  private setBundleName(bundleName: string) {
    this.bundleName = bundleName
    return this
  }

  private setModelName(moduleName: string) {
    this.moduleName = moduleName
    return this
  }

  private setAbilityName(abilityName: string) {
    this.abilityName = abilityName
    return this
  }

  private setContainer(container: number) {
    this.container = container
    return this
  }

  private setArea(area: string) {
    let areaArray: number[] = []
    let temp = area.split(',')
    if (!CheckEmptyUtils.isEmptyArr(temp) && temp.length === 2) {
      areaArray[0] = Number(temp[0])
      areaArray[1] = Number(temp[1])
    }
    this.area = areaArray
    return this
  }

  private setPage(page: number) {
    this.page = page
    return this
  }

  private setColumn(column: number) {
    this.column = column
    return this
  }

  private setRow(row: number) {
    this.row = row
    return this
  }

  static fromResultSet(resultSet: any): GridLayoutItemInfo {
    let gridlayoutItemInfo = new GridLayoutItemInfo()
    gridlayoutItemInfo.setId(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ID)))
    gridlayoutItemInfo.setAppName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_NAME)))
    gridlayoutItemInfo.setAppIconId(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APPICON_ID)))
    gridlayoutItemInfo.setCardId(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.CARD_ID)))
    gridlayoutItemInfo.setCardName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.CARD_NAME)))
    gridlayoutItemInfo.setContainer(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.CONTAINER)))
    gridlayoutItemInfo.setBadgeNumber(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.BADGE_NUMBER)))
    gridlayoutItemInfo.setTypeId(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.TYPE_ID)))
    gridlayoutItemInfo.setArea(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.AREA)))
    gridlayoutItemInfo.setPage(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.PAGE)))
    gridlayoutItemInfo.setColumn(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.COLUMN)))
    gridlayoutItemInfo.setRow(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ROW)))
    gridlayoutItemInfo.setBundleName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.BUNDLE_NAME)))
    gridlayoutItemInfo.setAbilityName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ABILITY_NAME)))
    gridlayoutItemInfo.setModelName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.MODEL_NAME)))
    return gridlayoutItemInfo
  }
}
