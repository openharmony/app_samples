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

import AppMenu from '../../../../../../base/src/main/ets/default/components/AppMenu'
import CommonConstants from '../../../../../../base/src/main/ets/default/constants/CommonConstants'
import DesktopLayoutModel from '../model/DesktopLayoutModel'
import FormManager from '../../../../../../base/src/main/ets/default/manager/FormManager'
import GridLayoutItemInfo from '../../../../../../base/src/main/ets/default/bean/GridLayoutItemInfo'
import Logger from '../../../../../../base/src/main/ets/default/utils/Logger'
import MenuInfo from '../../../../../../base/src/main/ets/default/bean/MenuInfo'
import RemoveDialog from '../../../../../../base/src/main/ets/default//components/RemoveDialog'

const TAG: string = 'CardItem'

@Component
export default struct CardItem {
  private formInfo: GridLayoutItemInfo = new GridLayoutItemInfo()
  private dialogTitle: string = ''
  private dimension: number = 0
  private menuInfos: Array<MenuInfo> = undefined
  private desktopLayoutModel: DesktopLayoutModel = DesktopLayoutModel.getInstance(getContext(this))

  @Builder MenuBuilder() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      AppMenu({
        menuInfos: this.menuInfos
      })
    }
    .width(243)
    .borderRadius(12)
  }

  build() {
    Flex({
      direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      FormComponent({
        id: this.formInfo.cardId,
        name: this.formInfo.cardName,
        bundle: this.formInfo.bundleName,
        ability: this.formInfo.abilityName,
        module: this.formInfo.moduleName,
        dimension: this.dimension
      })
        .clip(new Rect({
          width: CommonConstants.FORM_COMPONENT_WIDTH[this.dimension - 1],
          height: CommonConstants.FORM_COMPONENT_HEIGHT[this.dimension - 1],
          radius: CommonConstants.DEFAULT_CARD_RADIUS
        }))
        .size({
          width: CommonConstants.FORM_COMPONENT_WIDTH[this.dimension - 1],
          height: CommonConstants.FORM_COMPONENT_HEIGHT[this.dimension - 1]
        })
        .onAcquired(form => {
          this.formInfo.cardId = form.id
          Logger.info(TAG, `onAcquired this.formInfo.cardId: ${this.formInfo.cardId}`);
        })
        .allowUpdate(true)

      Text(this.formInfo.appName)
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .margin({ top: 5 })
        .width('90%')
        .fontSize(14)
    }
    .width('100%')
    .height('100%')
    .bindContextMenu(this.MenuBuilder, ResponseType.LongPress)
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: RemoveDialog({
      confirm: async () => {
        // 移除卡片的逻辑
        this.desktopLayoutModel.removeItemFromDeskTop(this.formInfo)
      },
      cardName: this.formInfo.appName
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center
  })

  aboutToAppear() {
    this.dimension = FormManager.getCardDimension(this.formInfo.area)
    this.menuInfos = this.desktopLayoutModel.buildCardInfoList(this.dialogController)
  }
}