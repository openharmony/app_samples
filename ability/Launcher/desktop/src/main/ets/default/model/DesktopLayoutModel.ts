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

import router from '@ohos.router'
import AppItemInfo from '../../../../../../base/src/main/ets/default/bean/AppItemInfo'
import CheckEmptyUtils from '../../../../../../base/src/main/ets/default/utils/CheckEmptyUtils'
import CommonConstants from '../../../../../../base/src/main/ets/default/constants/CommonConstants'
import GridLayoutItemInfo from '../../../../../../base/src/main/ets/default/bean/GridLayoutItemInfo'
import FormManager from '../../../../../../base/src/main/ets/default/manager/FormManager'
import FormModel from '../../../../../../base/src/main/ets/default/model/FormModel'
import Logger from '../../../../../../base/src/main/ets/default/utils/Logger'
import LauncherAbilityManager from '../../../../../../base/src/main/ets/default/manager/LauncherAbilityManager'
import MenuInfo from '../../../../../../base/src/main/ets/default/bean/MenuInfo'
import ResourceManager from '../../../../../../base/src/main/ets/default/manager/ResourceManager'

const TAG: string = 'LayoutInfoModel'
const SYSTEM_APPLICATIONS: string = 'com.ohos.launcher,ohos.samples.launcher,com.ohos.systemui,com.ohos.devicemanagerui,com.ohos.callui,com.example.kikakeyboard,com.ohos.contactdataability,com.ohos.telephonydataability,com.ohos.medialibrary.MediaLibraryDataA,com.ohos.medialibrary.MediaScannerAbilityA'
const KEY_NAME = 'name'

export default class DesktopLayoutModel {
  private layoutInfo: Array<Array<GridLayoutItemInfo>> = []
  private readonly mSystemApplicationName = SYSTEM_APPLICATIONS.split(',')
  private mLauncherAbilityManager: LauncherAbilityManager = undefined
  private context: any = undefined

  constructor(context) {
    this.context = context
    this.mLauncherAbilityManager = LauncherAbilityManager.getInstance(context)
  }


  /**
  * Get the application data model object.
  *
  * @return {object} application data model singleton
  */
  static getInstance(context): DesktopLayoutModel {
    if (globalThis.LayoutInfoModel == null) {
      globalThis.LayoutInfoModel = new DesktopLayoutModel(context)
    }
    return globalThis.LayoutInfoModel
  }

  /**
   * getAppItemFormInfo
   *
   * @param bundleName
   */
  getAppItemFormInfo(bundleName: string) {
    return FormModel.getAppItemFormInfo(bundleName)
  }

  /**
   * buildMenuInfoList
   *
   * @param appInfo: GridLayoutItemInfo
   */
  buildMenuInfoList(appInfo: GridLayoutItemInfo) {
    if (CheckEmptyUtils.isEmpty(appInfo)) {
      return undefined
    }
    let menuInfoList = new Array<MenuInfo>()
    let open = new MenuInfo()
    open.menuImgSrc = $r('app.media.ic_public_add_norm')
    open.menuText = $r('app.string.app_menu_open')
    open.onMenuClick = () => {
      this.jumpTo(appInfo.abilityName, appInfo.bundleName)
    }
    menuInfoList.push(open)

    Logger.info(TAG, `buildMenuInfoList getAppItemFormInfo,bundleName =  ${appInfo.bundleName}`)
    const formInfoList = FormModel.getAppItemFormInfo(appInfo.bundleName)
    Logger.info(TAG, `buildMenuInfoList formInfoList = ${JSON.stringify(formInfoList)}`)
    if (!CheckEmptyUtils.isEmptyArr(formInfoList)) {
      let addFormToDeskTopMenu = new MenuInfo()
      addFormToDeskTopMenu.menuImgSrc = $r('app.media.ic_public_app')
      addFormToDeskTopMenu.menuText = $r('app.string.add_form_to_desktop')
      addFormToDeskTopMenu.onMenuClick = () => {
        Logger.info(TAG, 'Launcher click menu item into add form to desktop view')
        if (!CheckEmptyUtils.isEmpty(appInfo)) {
          AppStorage.SetOrCreate('formAppInfo', appInfo)
          Logger.info(TAG, 'Launcher AppStorage.SetOrCreate formAppInfo')
          this.jumpToFormManagerView(appInfo)
        }
      }
      menuInfoList.push(addFormToDeskTopMenu)
    }
    return menuInfoList
  }

  /**
   * buildCardInfoList
   *
   * @param dialog
   */
  buildCardInfoList(dialog: any) {
    let menuInfoList = new Array<MenuInfo>()
    const uninstallMenu = new MenuInfo()
    uninstallMenu.menuImgSrc = $r('app.media.ic_public_delete')
    uninstallMenu.menuText = $r('app.string.remove')
    uninstallMenu.onMenuClick = () => {
      Logger.info(TAG, 'Launcher click menu item uninstall')
      if (!CheckEmptyUtils.isEmpty(dialog)) {
        dialog.open()
      }
    }
    menuInfoList.push(uninstallMenu)
    return menuInfoList
  }

  /**
   * getAppName
   *
   * @param cacheKey
   */
  getAppName(cacheKey: string) {
    return ResourceManager.getInstance(this.context).getAppResourceCache(cacheKey, KEY_NAME)
  }

  /**
   * jump to form manager
   * @param formInfo

  * */
  jumpToFormManagerView(formInfo: GridLayoutItemInfo) {
    router.push({
      url: 'pages/FormPage',
      params: {
        formInfo: formInfo
      }
    })
  }

  /**
   * Start target ability
   *
   * @param bundleName target bundle name
   * @param abilityName target ability name
   */
  jumpTo(abilityName: string, bundleName: string): void {
    this.mLauncherAbilityManager.startLauncherAbility(abilityName, bundleName)
  }

  /**
   * getLayoutInfoCache
   */
  getLayoutInfoCache() {
    return this.layoutInfo
  }

  /**
   * Get the list of apps displayed on the desktop (private function).
   *
   * @return {array} bundleInfoList, excluding system applications
   */
  async getAppListAsync(): Promise<AppItemInfo[]> {
    let allAbilityList: AppItemInfo[] = await this.mLauncherAbilityManager.getLauncherAbilityList()
    Logger.info(TAG, `getAppListAsync allAbilityList length: ${allAbilityList.length}`)
    let launcherAbilityList: AppItemInfo[] = []
    for (let i in allAbilityList) {
      if (this.mSystemApplicationName.indexOf(allAbilityList[i].bundleName) === CommonConstants.INVALID_VALUE) {
        launcherAbilityList.push(allAbilityList[i])
        FormModel.updateAppItemFormInfo(allAbilityList[i].bundleName)
      }
    }
    Logger.debug(TAG, `getAppListAsync launcherAbiltyList length: ${launcherAbilityList.length}`)
    return launcherAbilityList
  }

  /**
   * getLayoutInfo
   */
  async getLayoutInfo() {
    let infos = await this.getAppListAsync()
    let result = this.initPositionInfos(infos)
    Logger.info(TAG, `getLayoutInfo result0,${JSON.stringify(result)}`)
    this.layoutInfo = result
    return this.layoutInfo

  }

  /**
   * initPositionInfos
   *
   * @param appInfos
   */
  initPositionInfos(appInfos: Array<AppItemInfo>) {
    Logger.info(TAG, `initPositionInfos, appInfos size = ${appInfos.length}`)
    let countsOnePage = CommonConstants.DEFAULT_COLUMN_COUNT * CommonConstants.DEFAULT_ROW_COUNT
    let result: Array<Array<GridLayoutItemInfo>> = []
    let page = Math.floor(appInfos.length / countsOnePage) + 1
    for (let i = 0;i < page; i++) {
      let item: Array<GridLayoutItemInfo> = []
      result.push(item)
    }
    Logger.debug(TAG, `result0 = ${JSON.stringify(result)}`)
    for (let j = 0;j < appInfos.length; j++) {
      let item = appInfos[j]
      Logger.debug(TAG, `infos[${j}], item = ${JSON.stringify(item)}`)
      let page = Math.floor(j / countsOnePage)
      let column = Math.floor(j % CommonConstants.DEFAULT_COLUMN_COUNT)
      let row = Math.floor(j / CommonConstants.DEFAULT_COLUMN_COUNT) % countsOnePage
      let gridItem: GridLayoutItemInfo = this.covertAppItemToGridItem(item, page, column, row)
      if (!CheckEmptyUtils.isEmpty(gridItem)) {
        result[page].push(gridItem)
      }
      Logger.debug(TAG, `infos[${j}], page = ${page},row = ${row},column = ${column}`)
    }
    Logger.debug(TAG, `result1 = ${JSON.stringify(result)}`)
    return result
  }

  private covertAppItemToGridItem(item: AppItemInfo, page: number, column: number, row: number) {
    if (CheckEmptyUtils.isEmpty(item)) {
      return undefined
    }
    let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo()
    gridItem.appName = item.appName
    gridItem.appIconId = item.appIconId
    gridItem.bundleName = item.bundleName
    gridItem.moduleName = item.moduleName
    gridItem.abilityName = item.abilityName
    gridItem.container = -100
    gridItem.page = page
    gridItem.column = column
    gridItem.row = row
    gridItem.area = [1, 1]
    gridItem.typeId = 0
    return gridItem
  }

  /**
   * createCardToDeskTop
   *
   * @param formCardItem
   */
  async createCardToDeskTop(formCardItem: any) {
    if (CheckEmptyUtils.isEmpty(formCardItem)) {
      return
    }
    Logger.info(TAG, `createCardToDeskTop formCardItem ${JSON.stringify(formCardItem)}`)
    let gridItem = this.createNewCardItemInfo(formCardItem)
    let page = this.layoutInfo.length
    gridItem = this.updateItemLayoutInfo(gridItem)
    if (gridItem.page >= page) {
      this.layoutInfo.push([])
    }
    this.layoutInfo[gridItem.page].push(gridItem)
    Logger.info(TAG, `createCardToDeskTop gridItem2 =  ${JSON.stringify(gridItem)}`)
    AppStorage.SetOrCreate('isRefresh', true)
  }

  /**
   * remove item from desktop
   *
   * @param item
   */
  async removeItemFromDeskTop(item: GridLayoutItemInfo) {
    if (CheckEmptyUtils.isEmpty(item)) {
      return
    }
    Logger.info(TAG, 'removeCardFromDeskTop start')
    let pageInfos = this.layoutInfo
    searchCircle:for (let i = 0;i < pageInfos.length; i++) {
      Logger.info(TAG, `removeCardFromDeskTop pageInfos${i}`)
      for (let j = 0;j < pageInfos[i].length; j++) {
        if (pageInfos[i][j].bundleName === item.bundleName && pageInfos[i][j].page === item.page
        && pageInfos[i][j].row === item.row && pageInfos[i][j].column === item.column) {
          Logger.debug(TAG, `removeCardFromDeskTop pageInfos${i}${j} is find,remove`)
          pageInfos[i].splice(j, 1)
          // 移除后是空白屏幕，移除屏幕
          if (pageInfos[i].length === 0) {
            pageInfos.splice(i, 1)
          }
          break searchCircle
        }
      }
    }
    this.layoutInfo = pageInfos
    Logger.info(TAG, `removeCardFromDeskTop item= ${JSON.stringify(item)}`)
    AppStorage.SetOrCreate('isRefresh', true)
  }

  private updateItemLayoutInfo(item: GridLayoutItemInfo) {
    let page = this.layoutInfo.length
    const row = CommonConstants.DEFAULT_ROW_COUNT
    const column = CommonConstants.DEFAULT_COLUMN_COUNT
    let isNeedNewPage = true
    pageCycle: for (let i = 0; i < page; i++) {
      for (let y = 0; y < row; y++) {
        for (let x = 0; x < column; x++) {
          if (this.isPositionValid(item, i, x, y)) {
            isNeedNewPage = false
            item.page = i
            item.column = x
            item.row = y
            break pageCycle
          }
        }
      }
    }

    if (isNeedNewPage) {
      item.page = page
      item.column = 0
      item.row = 0
    }
    return item
  }

  private isPositionValid(item: GridLayoutItemInfo, page: number, startColumn: number, startRow: number) {
    const row = CommonConstants.DEFAULT_ROW_COUNT
    const column = CommonConstants.DEFAULT_COLUMN_COUNT
    if ((startRow + item.area[0]) > row || (startColumn + item.area[1]) > column) {
      Logger.info(TAG, 'isPositionValid return false 1')
      return false
    }
    let isValid = true
    for (let x = startColumn; x < startColumn + item.area[1]; x++) {
      for (let y = startRow; y < startRow + item.area[0]; y++) {
        if (this.isPositionOccupied(page, x, y)) {
          Logger.info(TAG, 'isPositionValid return false 2')
          isValid = false
          break
        }
      }
    }
    return isValid
  }

  private isPositionOccupied(page: number, column: number, row: number) {
    const layoutInfo = this.layoutInfo[page]
    // current page has space
    for (const item of layoutInfo) {
      const xMatch = (column >= item.column) && (column < item.column + item.area[1])
      const yMatch = (row >= item.row) && (row < item.row + item.area[0])
      if (xMatch && yMatch) {
        return true
      }
    }
    return false
  }

  private createNewCardItemInfo(formCardItem: any): GridLayoutItemInfo {
    if (CheckEmptyUtils.isEmpty(formCardItem)) {
      return undefined
    }
    let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo()
    gridItem.appName = formCardItem.appName
    gridItem.typeId = CommonConstants.TYPE_CARD
    gridItem.cardId = formCardItem.cardId
    gridItem.cardName = formCardItem.cardName
    gridItem.bundleName = formCardItem.bundleName
    gridItem.moduleName = formCardItem.moduleName
    gridItem.abilityName = formCardItem.abilityName
    gridItem.container = -100
    gridItem.page = 0
    gridItem.column = 0
    gridItem.row = 0
    gridItem.area = FormManager.getCardSize(formCardItem.dimension)
    return gridItem
  }
}