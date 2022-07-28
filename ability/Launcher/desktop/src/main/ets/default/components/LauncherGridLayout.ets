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

import Bubble from './Bubble'
import CardItem from './CardItem'
import CommonConstants from '../../../../../../base/src/main/ets/default/constants/CommonConstants'
import GridLayoutItemInfo from '../../../../../../base/src/main/ets/default/bean/GridLayoutItemInfo'
import Logger from '../../../../../../base/src/main/ets/default/utils/Logger'
import ResourceManager from '../../../../../../base/src/main/ets/default/manager/ResourceManager'

const TAG: string = 'LauncherGridLayout'

@Component
export default struct LauncherGridLayout {
  @State columnsTemplate: string = ''
  @State rowsTemplate: string = ''
  @State gridInfos: Array<GridLayoutItemInfo> = []

  build() {
    Grid() {
      ForEach(this.gridInfos, item => {
        GridItem() {
          if (item.typeId === CommonConstants.TYPE_APP) {
            Bubble({
              appInfo: item,
              icon: ResourceManager.getInstance(getContext(this))
                .getCachedAppIcon(item.appIconId, item.bundleName)
            })
          } else {
            CardItem({ formInfo: item })
          }
        }
        .rowStart(item.row)
        .columnStart(item.column)
        .rowEnd(item.row + item.area[0] - 1)
        .columnEnd(item.column + item.area[1] - 1)
      }, item => {
        return `${item.typeId}${item.row}${item.column}`
      })
    }
    .columnsTemplate(this.columnsTemplate)
    .rowsTemplate(this.rowsTemplate)
    .columnsGap(10)
    .rowsGap(10)
    .margin({ bottom: 20 })
  }

  aboutToAppear() {
    Logger.info(TAG, `gridInfos.size = ${this.gridInfos.length}`)
    for (let i = 0;i < CommonConstants.DEFAULT_COLUMN_COUNT; i++) {
      this.columnsTemplate += '1fr '
    }
    for (let i = 0;i < CommonConstants.DEFAULT_ROW_COUNT; i++) {
      this.rowsTemplate += '1fr '
    }
    Logger.info(TAG, `this.columnsTemplate = ${this.columnsTemplate},this.rowsTemplate = ${this.rowsTemplate}`)
  }
}