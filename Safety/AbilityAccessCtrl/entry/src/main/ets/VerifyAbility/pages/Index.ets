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
import bundle from '@ohos.bundle'
import Logger from '../../MainAbility/model/Logger'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import featureAbility from '@ohos.ability.featureAbility'

const TAG: string = '[Index]'

@Entry
@Component
struct Index {
  private tokenID: number = 0
  private permission: string = ''
  private bundleName: string = ''
  private atManager: abilityAccessCtrl.AtManager

  aboutToAppear() {
    featureAbility.getWant(async (error, want) => {
      Logger.info(TAG, `featureAbility.getWant = ${JSON.stringify(want.parameters)}`);
      this.bundleName = want.parameters.bundleName
      this.permission = want.parameters.permissions
      let bundleFlags = 0
      let appInfo = await  bundle.getApplicationInfo(this.bundleName, bundleFlags)
      this.tokenID = appInfo.accessTokenId
      this.atManager = abilityAccessCtrl.createAtManager()
      Logger.info(TAG, `this.atManager = ${JSON.stringify(this.atManager)}`)
      this.grantUserPermissions(this.permission)
    })
  }

  grantUserPermissions = (grantPermissions: string) => {
    AlertDialog.show({
      title: $r('app.string.title'),
      message: grantPermissions,
      primaryButton: {
        value: $r('app.string.cancel'),
        fontColor: Color.Red,
        action: () => {
          featureAbility.terminateSelf()
        }
      },
      secondaryButton: {
        value: $r('app.string.confirm'),
        fontColor: Color.Blue,
        action: () => {
          let permissionFlag = 2 // 授权选项，表示允许后不在提醒
          this.atManager.grantUserGrantedPermission(this.tokenID, grantPermissions, permissionFlag, () => {
            featureAbility.terminateSelf()
          })
        }
      }
    })
  }

  build() {
    Row() {
      Column() {
      }
      .width('100%')
    }
    .height('100%')
  }
}