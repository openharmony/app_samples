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

import MenuInfo from '../bean/MenuInfo'

@Component
export default struct AppMenu {
  private menuInfos: Array<MenuInfo> = new Array<MenuInfo>()

  build() {
    Column() {
      ForEach(this.menuInfos, (item) => {
        Column() {
          MenuItem({
            menuInfo: item
          })
        }
      }, item => JSON.stringify(item))
    }
    .padding({ top: 4, bottom: 4, left: 4, right: 4 })
    .borderRadius(12)
  }
}

@Component
struct MenuItem {
  private menuInfo: MenuInfo

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center
    }) {

      Image(this.menuInfo.menuImgSrc)
        .objectFit(ImageFit.Contain)
        .height(20)
        .width(20)
        .margin({ left: 12 })
      Text(this.menuInfo.menuText)
        .fontColor("#e5000000")
        .fontSize(14)
        .height(20)
        .margin({ left: 8 })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .borderRadius(12)
    .height(40)
    .width(235)
    .onClick(() => {
      this.menuInfo.onMenuClick()
      ContextMenu.close()
    })
  }
}