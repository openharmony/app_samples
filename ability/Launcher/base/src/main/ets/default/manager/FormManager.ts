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

import formManagerAbility from '@ohos.application.formHost'
import CardItemInfo from '../bean/CardItemInfo'
import CommonConstants from '../constants/CommonConstants'
import Logger from '../utils/Logger'

const TAG: string = 'FormManager'

/**
 * Wrapper class for formManager interfaces.
 */
class FormManager {
  private readonly CARD_SIZE_1x2: number[] = [1, 2]
  private readonly CARD_SIZE_2x2: number[] = [2, 2]
  private readonly CARD_SIZE_2x4: number[] = [2, 4]
  private readonly CARD_SIZE_4x4: number[] = [4, 4]

  /**
   * get all form info
   *
   * @return Array<CardItemInfo> cardItemInfoList
   */
  public async getAllFormsInfo(): Promise<CardItemInfo[]> {
    const formList = await formManagerAbility.getAllFormsInfo()
    const cardItemInfoList = new Array<CardItemInfo>()
    for (const formItem of formList) {
      const cardItemInfo = new CardItemInfo()
      cardItemInfo.bundleName = formItem.bundleName
      cardItemInfo.abilityName = formItem.abilityName
      cardItemInfo.moduleName = formItem.moduleName
      cardItemInfo.cardName = formItem.name
      cardItemInfo.cardDimension = formItem.defaultDimension
      cardItemInfo.description = formItem.description
      cardItemInfo.formConfigAbility = formItem.formConfigAbility
      cardItemInfo.supportDimensions = formItem.supportDimensions
      cardItemInfo.area = this.getCardSize(cardItemInfo.cardDimension)
      cardItemInfoList.push(cardItemInfo)
    }
    return cardItemInfoList
  }

  /**
   * get card area by dimension
   *
   * @param dimension
   * @return number[]
   */
  public getCardSize(dimension: number): number[] {
    if (dimension == CommonConstants.CARD_DIMENSION_1x2) {
      return this.CARD_SIZE_1x2
    } else if (dimension == CommonConstants.CARD_DIMENSION_2x2) {
      return this.CARD_SIZE_2x2
    } else if (dimension == CommonConstants.CARD_DIMENSION_2x4) {
      return this.CARD_SIZE_2x4
    } else {
      return this.CARD_SIZE_4x4
    }
  }

  /**
   * get card dimension bty area
   *
   * @param dimension
   * @return number[]
   */
  public getCardDimension(area: number[]) {
    if (area.toString() === this.CARD_SIZE_1x2.toString()) {
      return CommonConstants.CARD_DIMENSION_1x2
    } else if (area.toString() === this.CARD_SIZE_2x2.toString()) {
      return CommonConstants.CARD_DIMENSION_2x2
    } else if (area.toString() == this.CARD_SIZE_2x4.toString()) {
      return CommonConstants.CARD_DIMENSION_2x4
    } else {
      return CommonConstants.CARD_DIMENSION_4x4
    }
  }

  /**
   * get form info by bundleName
   *
   * @param bundle
   * @return Array<CardItemInfo> cardItemInfoList
   */
  public async getFormsInfoByApp(bundle: string): Promise<CardItemInfo[]> {
    Logger.info(TAG, `getFormsInfoByApp bundle: ${bundle}`)
    const formList = await formManagerAbility.getFormsInfo(bundle)
    const cardItemInfoList = new Array<CardItemInfo>()
    for (const formItem of formList) {
      const cardItemInfo = new CardItemInfo()
      cardItemInfo.bundleName = formItem.bundleName
      cardItemInfo.abilityName = formItem.abilityName
      cardItemInfo.moduleName = formItem.moduleName
      cardItemInfo.cardName = formItem.name
      cardItemInfo.cardDimension = formItem.defaultDimension
      cardItemInfo.area = this.getCardSize(cardItemInfo.cardDimension)
      cardItemInfo.description = formItem.description
      cardItemInfo.formConfigAbility = formItem.formConfigAbility
      cardItemInfo.supportDimensions = formItem.supportDimensions
      cardItemInfoList.push(cardItemInfo)
    }
    return cardItemInfoList
  }
}

export default new FormManager()

