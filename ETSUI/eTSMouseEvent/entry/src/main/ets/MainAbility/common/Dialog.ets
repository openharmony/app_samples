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

import router from '@system.router';

@CustomDialog
export struct GameOverDialog {
  controller: CustomDialogController
  confirm: () => void

  build() {
    Column() {
      Text($r('app.string.game_over'))
        .fontSize(36)
        .margin({ top: 20, bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.restart'))
          .fontSize(24)
          .onClick(() => {
            this.controller.close()
            this.confirm()
          }).backgroundColor(0xffffff).fontColor(Color.Black)

        Divider().height(30).vertical(true).strokeWidth(2).color('#999999')

        Button($r('app.string.exit'))
          .fontSize(24)
          .onClick(() => {
            this.controller.close()
            router.back()
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
  }
}