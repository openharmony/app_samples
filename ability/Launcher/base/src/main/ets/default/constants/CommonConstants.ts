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
 * default form size od one grid
 */
const FORM_MGR_FORM_SIZE: number = 350

export default class CommonConstants {
  /**
   * Grid item type for apps.
   */
  static TYPE_APP = 0

  /**
   * Grid item type for cards.
   */
  static TYPE_CARD = 1

  /**
   * Default invalid value.
   */
  static INVALID_VALUE = -1

  /**
   * Card dimension constants for 1 row 2 columns.
   */
  static CARD_DIMENSION_1x2 = 1

  /**
   * Card dimension constants for 2 rows 2 columns.
   */
  static CARD_DIMENSION_2x2 = 2

  /**
   * Card dimension constants for 2 rows 4 columns.
   */
  static CARD_DIMENSION_2x4 = 3

  /**
   * Card dimension constants for 4 rows 4 columns.
   */
  static CARD_DIMENSION_4x4 = 4

  /**
   * Menu type for dynamic items.
   */
  static MENU_TYPE_DYNAMIC = 1

  /**
   * if uninstal succeeded, success, successful.
   */
  static UNINSTALL_SUCCESS = 0

  /**
   * uninstall is forbidden.
   */
  static UNINSTALL_FORBID = 1

  /**
   * default page for launcher
   */
  static DEFAULT_PAGE_COUNT: number = 1

  /**
   * default row count for launcher
   */
  static DEFAULT_ROW_COUNT: number = 6

  /**
   * default column count for launcher
   */
  static DEFAULT_COLUMN_COUNT: number = 5

  /**
   * default form components radius for launcher
   */
  static DEFAULT_CARD_RADIUS: number = 16

  /**
   * form components width for launcher
   */
  static FORM_COMPONENT_WIDTH: number[] =
    [FORM_MGR_FORM_SIZE / 2,
    FORM_MGR_FORM_SIZE / 2,
    FORM_MGR_FORM_SIZE,
    FORM_MGR_FORM_SIZE]

  /**
   * form components height for launcher
   */
  static readonly FORM_COMPONENT_HEIGHT: number[] =
    [FORM_MGR_FORM_SIZE / 4,
    FORM_MGR_FORM_SIZE / 2,
    FORM_MGR_FORM_SIZE / 2,
    FORM_MGR_FORM_SIZE]
}