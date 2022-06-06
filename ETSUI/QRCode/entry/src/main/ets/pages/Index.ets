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
import Logger from '../model/Logger'
import TitleBar from '../common/TitleBar'

const PERMISSIONS: Array<string> = [
  'ohos.permission.READ_MEDIA',
  'ohos.permission.WRITE_MEDIA',
  'ohos.permission.CAPTURE_SCREEN']
const TAG: string = '[Index]'

@Entry
@Component
struct Index {
  async aboutToAppear() {
    await globalThis.abilityContext.requestPermissionsFromUser(PERMISSIONS)
    Logger.info(TAG, 'grantPermission,requestPermissionsFromUser')
  }

  @Builder
  OperationBtn(text: Resource, handleClick: () => void) {
    Button({ type: ButtonType.Capsule }) {
      Text(text)
        .fontSize(30)
        .fontColor(Color.White)
    }
    .width('90%')
    .height(70)
    .backgroundColor('#0D9FFB')
    .margin(20)
    .onClick(handleClick)
  }

  build() {
    Column() {
      TitleBar()
      this.OperationBtn($r('app.string.create_qrcode'), () => {
        router.push({
          url: 'pages/CreateQRCode'
        })
      })
      this.OperationBtn($r('app.string.parse_qrcode'), () => {
        router.push({
          url: 'pages/ParseQRCode'
        })
      })
    }
    .height('100%')
    .width('100%')
  }
}